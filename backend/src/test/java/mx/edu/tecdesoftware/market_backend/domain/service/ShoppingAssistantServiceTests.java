package mx.edu.tecdesoftware.market_backend.domain.service;

import com.fasterxml.jackson.databind.ObjectMapper;
import org.junit.jupiter.api.Test;

import java.util.List;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

class ShoppingAssistantServiceTests {
    private final ProductService products = mock(ProductService.class);
    private final GeminiClient gemini = mock(GeminiClient.class);
    private final ShoppingAssistantService assistant =
            new ShoppingAssistantService(products, gemini, new ObjectMapper());

    @Test
    void sendsCurrentCatalogWithQuestion() {
        Category category = new Category();
        category.setCategory("Frutas");
        Product product = new Product();
        product.setProductId(7);
        product.setName("Manzana");
        product.setCategory(category);
        product.setPrice(12.5);
        product.setStock(9);
        when(products.getAll()).thenReturn(List.of(product));
        when(gemini.answer(anyString())).thenReturn("Hay manzanas disponibles.");

        assertEquals("Hay manzanas disponibles.", assistant.answer(" ¿Qué frutas hay? "));
        var input = org.mockito.ArgumentCaptor.forClass(String.class);
        verify(gemini).answer(input.capture());
        assertTrue(input.getValue().contains("\"name\":\"Manzana\""));
        assertTrue(input.getValue().contains("\"category\":\"Frutas\""));
        assertTrue(input.getValue().contains("Customer question: ¿Qué frutas hay?"));
    }

    @Test
    void rejectsBlankQuestionBeforeProviderCall() {
        assertThrows(IllegalArgumentException.class, () -> assistant.answer("  "));
        verify(gemini, never()).answer(anyString());
    }

    @Test
    void emptyCatalogDoesNotCallProvider() {
        when(products.getAll()).thenReturn(List.of());
        assertEquals("El catálogo está vacío por ahora.", assistant.answer("¿Qué hay?"));
        verify(gemini, never()).answer(anyString());
    }
}
