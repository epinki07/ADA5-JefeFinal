package mx.edu.tecdesoftware.market_backend.persistence.entity;

import com.fasterxml.jackson.annotation.JsonFormat;
import jakarta.persistence.*;
import java.math.BigDecimal;
import java.time.Instant;
import java.util.List;
import java.util.UUID;

@Entity
@Table(name = "ventas")
public class Sale {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, unique = true, updatable = false)
    private UUID requestId;

    @Column(nullable = false, length = 100)
    private String customer;

    @Column(nullable = false)
    private Instant createdAt;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 12)
    private Payment payment;

    @Column(nullable = false, precision = 21, scale = 2)
    private BigDecimal total;

    @ElementCollection
    @CollectionTable(name = "ventas_partidas", joinColumns = @JoinColumn(name = "venta_id"))
    @OrderColumn(name = "line_index")
    private List<Line> lines;

    protected Sale() {
    }

    public Sale(UUID requestId, String customer, Payment payment, BigDecimal total, List<Line> lines) {
        this.requestId = requestId;
        this.customer = customer;
        this.payment = payment;
        this.total = total;
        this.lines = List.copyOf(lines);
        this.createdAt = Instant.now();
    }

    public Long getId() { return id; }
    public String getCustomer() { return customer; }
    public Instant getCreatedAt() { return createdAt; }
    public Payment getPayment() { return payment; }
    public BigDecimal getTotal() { return total; }
    public List<Line> getLines() { return lines; }

    public enum Payment { CASH, CARD, TRANSFER }

    @Embeddable
    public record Line(
            @Column(nullable = false) int productId,
            @Column(nullable = false) String name,
            @Column(nullable = false) int quantity,
            @JsonFormat(shape = JsonFormat.Shape.STRING)
            @Column(nullable = false, precision = 17, scale = 2) BigDecimal unitPrice,
            @JsonFormat(shape = JsonFormat.Shape.STRING)
            @Column(nullable = false, precision = 21, scale = 2) BigDecimal amount) {
    }
}
