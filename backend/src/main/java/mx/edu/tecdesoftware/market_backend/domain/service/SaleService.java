package mx.edu.tecdesoftware.market_backend.domain.service;

import com.fasterxml.jackson.annotation.JsonFormat;
import mx.edu.tecdesoftware.market_backend.persistence.crud.ProductoCrudRepository;
import mx.edu.tecdesoftware.market_backend.persistence.crud.SaleCrudRepository;
import mx.edu.tecdesoftware.market_backend.persistence.entity.Producto;
import mx.edu.tecdesoftware.market_backend.persistence.entity.Sale;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.Instant;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.TreeMap;
import java.util.UUID;

@Service
public class SaleService {
    private final SaleCrudRepository sales;
    private final ProductoCrudRepository products;

    public SaleService(SaleCrudRepository sales, ProductoCrudRepository products) {
        this.sales = sales;
        this.products = products;
    }

    @Transactional
    public Receipt recordSale(Order order) {
        var items = validate(order);
        var existing = replay(order, items);
        if (existing.isPresent()) {
            return existing.get();
        }

        // Lock rows in a consistent order so overlapping sales cannot oversell.
        var selected = new ArrayList<Producto>();
        for (int id : items.keySet()) {
            selected.add(products.findForUpdate(id).orElseThrow(
                    () -> conflict("Un producto ya no está disponible.")));
        }
        existing = replay(order, items);
        if (existing.isPresent()) {
            return existing.get();
        }

        var lines = new ArrayList<Sale.Line>();
        BigDecimal total = BigDecimal.ZERO.setScale(2);
        for (Producto product : selected) {
            int id = product.getIdProducto();
            Item item = items.get(id);
            int quantity = item.quantity();
            if (!product.isEstado()) {
                throw conflict("Producto no disponible: " + product.getNombre());
            }
            Integer stock = product.getCantidadStock();
            if (stock == null || stock < quantity) {
                throw conflict("Existencias insuficientes: " + product.getNombre());
            }
            Double price = product.getPrecioVenta();
            if (price == null || !Double.isFinite(price) || price < 0 || price > 999_999_999.99) {
                throw conflict("Precio no disponible: " + product.getNombre());
            }
            BigDecimal unitPrice = BigDecimal.valueOf(price).setScale(2, RoundingMode.HALF_UP);
            if (unitPrice.compareTo(item.unitPrice()) != 0) {
                throw conflict("Cambió el precio de " + product.getNombre() + ". Actualiza el catálogo.");
            }
            BigDecimal amount = unitPrice.multiply(BigDecimal.valueOf(quantity));
            lines.add(new Sale.Line(id, product.getNombre(), quantity, unitPrice, amount));
            total = total.add(amount);
            product.setCantidadStock(stock - quantity);
        }

        return Receipt.from(sales.saveAndFlush(
                new Sale(order.requestId(), customer(order), order.payment(), total, lines)));
    }

    @Transactional(readOnly = true)
    public Optional<Receipt> replay(Order order) {
        return replay(order, validate(order));
    }

    private Optional<Receipt> replay(Order order, TreeMap<Integer, Item> items) {
        return sales.findByRequestId(order.requestId()).map(sale -> {
            if (!sale.getCustomer().equals(customer(order)) || sale.getPayment() != order.payment()
                    || sale.getLines().size() != items.size()
                    || sale.getLines().stream().anyMatch(line -> !matches(line, items.get(line.productId())))) {
                throw conflict("Esta operación ya corresponde a otra venta.");
            }
            return Receipt.from(sale);
        });
    }

    private boolean matches(Sale.Line line, Item item) {
        return item != null && line.quantity() == item.quantity() && line.unitPrice().compareTo(item.unitPrice()) == 0;
    }

    @Transactional(readOnly = true)
    public History history(int page) {
        if (page < 0 || page > 1_000_000) {
            throw new IllegalArgumentException("Página inválida.");
        }
        var result = sales.findAll(PageRequest.of(page, 20, Sort.by(Sort.Direction.DESC, "id")));
        return new History(result.stream().map(Summary::from).toList(), result.hasNext());
    }

    @Transactional(readOnly = true)
    public Optional<Receipt> find(long id) {
        return sales.findById(id).map(Receipt::from);
    }

    private TreeMap<Integer, Item> validate(Order order) {
        if (order == null || order.requestId() == null || order.payment() == null
                || order.items() == null || order.items().isEmpty() || order.items().size() > 50
                || (order.customer() != null && order.customer().strip().length() > 100)) {
            throw new IllegalArgumentException("Revisa el cliente, la forma de pago y los productos.");
        }
        var items = new TreeMap<Integer, Item>();
        for (Item item : order.items()) {
            if (item == null || item.productId() < 1 || item.quantity() < 1 || item.quantity() > 1_000_000
                    || item.unitPrice() == null || item.unitPrice().signum() < 0 || item.unitPrice().scale() > 2
                    || items.putIfAbsent(item.productId(), item) != null) {
                throw new IllegalArgumentException("Selecciona productos distintos con cantidades y precios válidos.");
            }
        }
        return items;
    }

    private String customer(Order order) {
        return order.customer() == null || order.customer().isBlank() ? "Público general" : order.customer().strip();
    }

    private ResponseStatusException conflict(String message) {
        return new ResponseStatusException(HttpStatus.CONFLICT, message);
    }

    public record Order(UUID requestId, String customer, Sale.Payment payment, List<Item> items) {
    }

    public record Item(int productId, int quantity, BigDecimal unitPrice) {
    }

    public record Summary(long id, String customer, Instant createdAt, Sale.Payment payment,
                          @JsonFormat(shape = JsonFormat.Shape.STRING) BigDecimal total) {
        static Summary from(Sale sale) {
            return new Summary(sale.getId(), sale.getCustomer(), sale.getCreatedAt(), sale.getPayment(),
                    sale.getTotal());
        }
    }

    public record Receipt(long id, String customer, Instant createdAt, Sale.Payment payment,
                          @JsonFormat(shape = JsonFormat.Shape.STRING) BigDecimal total, List<Sale.Line> lines) {
        static Receipt from(Sale sale) {
            return new Receipt(sale.getId(), sale.getCustomer(), sale.getCreatedAt(), sale.getPayment(),
                    sale.getTotal(), List.copyOf(sale.getLines()));
        }
    }

    public record History(List<Summary> sales, boolean hasNext) {
    }
}
