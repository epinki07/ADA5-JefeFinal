package mx.edu.tecdesoftware.market_backend;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@SpringBootTest(properties = {
        "gemini.api-key=",
        "spring.datasource.url=jdbc:h2:mem:assistantdb;DB_CLOSE_DELAY=-1;DB_CLOSE_ON_EXIT=FALSE"
})
@AutoConfigureMockMvc
class AssistantEndpointTests {
    @Autowired
    MockMvc mockMvc;

    @Test
    void returnsServiceUnavailableWhenProviderIsNotConfigured() throws Exception {
        mockMvc.perform(post("/assistant")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("{\"question\":\"¿Qué productos hay?\"}"))
                .andExpect(status().isServiceUnavailable())
                .andExpect(jsonPath("$.message").value("Shopping assistant is not configured"));
    }

    @Test
    void rejectsBlankQuestion() throws Exception {
        mockMvc.perform(post("/assistant")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("{\"question\":\" \"}"))
                .andExpect(status().isBadRequest());
    }
}
