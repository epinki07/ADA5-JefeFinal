package mx.edu.tecdesoftware.market_backend.persistence.web.controller;

import mx.edu.tecdesoftware.market_backend.domain.service.SaleService;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.net.URI;

@RestController
@RequestMapping("/sales")
public class SaleController {
    private final SaleService sales;

    public SaleController(SaleService sales) {
        this.sales = sales;
    }

    @PostMapping
    public ResponseEntity<SaleService.Receipt> create(@RequestBody SaleService.Order order) {
        SaleService.Receipt receipt;
        try {
            receipt = sales.recordSale(order);
        } catch (DataIntegrityViolationException exception) {
            receipt = sales.replay(order).orElseThrow(() -> exception);
        }
        return ResponseEntity.created(URI.create("/sales/" + receipt.id())).body(receipt);
    }

    @GetMapping
    public SaleService.History history(@RequestParam(defaultValue = "0") int page) {
        return sales.history(page);
    }

    @GetMapping("/{id}")
    public ResponseEntity<SaleService.Receipt> get(@PathVariable long id) {
        return ResponseEntity.of(sales.find(id));
    }
}
