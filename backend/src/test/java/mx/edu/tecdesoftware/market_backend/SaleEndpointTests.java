package mx.edu.tecdesoftware.market_backend;

import com.fasterxml.jackson.databind.ObjectMapper;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;

import java.util.Map;
import java.util.UUID;

import static org.hamcrest.Matchers.containsString;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@AutoConfigureMockMvc
@SpringBootTest(properties = "spring.datasource.url=jdbc:h2:mem:sale-tests;DB_CLOSE_DELAY=-1")
class SaleEndpointTests {
    @Autowired
    private MockMvc mvc;

    @Autowired
    private ObjectMapper json;

    @Test
    void recordsReceiptAndReplaysWithoutChangingStockTwice() throws Exception {
        int product = product("Producto de prueba", 19.95, 10);
        var key = UUID.randomUUID();
        String order = order(key, line(product, 3, "19.95"));
        String result = mvc.perform(post("/sales").contentType(MediaType.APPLICATION_JSON).content(order))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.total").value("59.85"))
                .andExpect(jsonPath("$.lines[0].unitPrice").value("19.95"))
                .andReturn().getResponse().getContentAsString();
        long sale = json.readTree(result).get("id").asLong();

        mvc.perform(post("/sales").contentType(MediaType.APPLICATION_JSON).content(order))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.id").value(sale));
        mvc.perform(post("/sales").contentType(MediaType.APPLICATION_JSON)
                        .content(order(key, line(product, 1, "19.95"))))
                .andExpect(status().isConflict());
        mvc.perform(get("/products/{id}", product))
                .andExpect(jsonPath("$.stock").value(7));

        mvc.perform(put("/products/{id}", product).contentType(MediaType.APPLICATION_JSON)
                        .content(productData("Producto actualizado", 21, 7)))
                .andExpect(status().isOk());
        mvc.perform(get("/sales/{id}", sale))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.total").value("59.85"))
                .andExpect(jsonPath("$.lines[0].name").value("Producto de prueba"));
        mvc.perform(get("/sales"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.sales[?(@.id == " + sale + ")].total").value("59.85"));
    }

    @Test
    void rollsBackStockWhenAnotherLineCannotBeSold() throws Exception {
        int available = product("Con existencias", 10, 5);
        int empty = product("Sin existencias", 12, 0);
        String order = order(UUID.randomUUID(), line(available, 2, "10.00"), line(empty, 1, "12.00"));
        mvc.perform(post("/sales").contentType(MediaType.APPLICATION_JSON).content(order))
                .andExpect(status().isConflict())
                .andExpect(jsonPath("$.message").value(containsString("Existencias insuficientes")));
        mvc.perform(get("/products/{id}", available))
                .andExpect(jsonPath("$.stock").value(5));
    }

    @Test
    void rejectsAStalePriceAndDuplicateProductLines() throws Exception {
        int product = product("Precio vigente", 12, 5);
        mvc.perform(post("/sales").contentType(MediaType.APPLICATION_JSON)
                        .content(order(UUID.randomUUID(), line(product, 1, "10.00"))))
                .andExpect(status().isConflict())
                .andExpect(jsonPath("$.message").value(containsString("Cambió el precio")));
        mvc.perform(post("/sales").contentType(MediaType.APPLICATION_JSON)
                        .content(order(UUID.randomUUID(), line(product, 1, "12.00"), line(product, 1, "12.00"))))
                .andExpect(status().isBadRequest());
        mvc.perform(get("/products/{id}", product))
                .andExpect(jsonPath("$.stock").value(5));
    }

    private int product(String name, double price, int stock) throws Exception {
        String body = mvc.perform(post("/products/save").contentType(MediaType.APPLICATION_JSON)
                        .content(productData(name, price, stock)))
                .andExpect(status().isCreated())
                .andReturn().getResponse().getContentAsString();
        return json.readTree(body).get("productId").asInt();
    }

    private String productData(String name, double price, int stock) throws Exception {
        return json.writeValueAsString(Map.of(
                "name", name, "categoryId", 1, "price", price, "stock", stock, "active", true));
    }

    private String order(UUID id, Map<?, ?>... lines) throws Exception {
        return json.writeValueAsString(Map.of(
                "requestId", id, "customer", "Cliente de prueba", "payment", "CASH", "items", lines));
    }

    private Map<String, Object> line(int product, int quantity, String price) {
        return Map.of("productId", product, "quantity", quantity, "unitPrice", price);
    }
}
