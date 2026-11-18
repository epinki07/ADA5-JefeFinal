package mx.edu.tecdesoftware.market_backend.domain.service;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.stereotype.Service;

import java.util.Comparator;
import java.util.List;
import java.util.Map;

@Service
public class ShoppingAssistantService {
    private final ProductService productService;
    private final GeminiClient geminiClient;
    private final ObjectMapper objectMapper;

    public ShoppingAssistantService(ProductService productService, GeminiClient geminiClient,
                                    ObjectMapper objectMapper) {
        this.productService = productService;
        this.geminiClient = geminiClient;
        this.objectMapper = objectMapper;
    }

    public String answer(String question) {
        if (question == null || question.isBlank() || question.length() > 500) {
            throw new IllegalArgumentException("Question must have 1 to 500 characters");
        }
        List<Product> products = productService.getAll();
        if (products.isEmpty()) return "El catálogo está vacío por ahora.";
        if (products.size() > 100) {
            throw new AssistantUnavailableException("Catalog is too large for the shopping assistant");
        }
        List<Map<String, Object>> catalog = products.stream()
                .sorted(Comparator.comparing(Product::getProductId))
                .map(product -> Map.<String, Object>of(
                        "id", product.getProductId(),
                        "name", product.getName(),
                        "category", product.getCategory() == null ? "" : product.getCategory().getCategory(),
                        "price", product.getPrice(),
                        "stock", product.getStock()
                )).toList();
        try {
            String input = "Current active product catalog (JSON): " + objectMapper.writeValueAsString(catalog)
                    + "\nCustomer question: " + question.trim();
            return geminiClient.answer(input);
        } catch (JsonProcessingException exception) {
            throw new AssistantUnavailableException("Catalog could not be prepared for the shopping assistant");
        }
    }
}
