package mx.edu.tecdesoftware.market_backend.domain.service;

import com.sun.net.httpserver.HttpServer;
import org.junit.jupiter.api.Test;
import org.springframework.web.client.RestClient;

import java.io.IOException;
import java.net.InetSocketAddress;
import java.nio.charset.StandardCharsets;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.junit.jupiter.api.Assertions.assertTrue;

class GeminiClientTests {
    @Test
    void parsesProviderResponseAndKeepsKeyInHeader() throws IOException {
        HttpServer server = HttpServer.create(new InetSocketAddress("127.0.0.1", 0), 0);
        try {
            server.createContext("/v1beta/interactions", exchange -> {
                assertEquals("test-key", exchange.getRequestHeaders().getFirst("x-goog-api-key"));
                String request = new String(exchange.getRequestBody().readAllBytes(), StandardCharsets.UTF_8);
                assertTrue(request.contains("\"store\":false"));
                assertTrue(request.contains("¿Qué hay?"));
                byte[] body = ("{\"status\":\"completed\",\"steps\":[{\"type\":\"model_output\","
                        + "\"content\":[{\"type\":\"text\",\"text\":\"Hay manzanas.\"}]}]}")
                        .getBytes(StandardCharsets.UTF_8);
                exchange.getResponseHeaders().set("Content-Type", "application/json");
                exchange.sendResponseHeaders(200, body.length);
                exchange.getResponseBody().write(body);
                exchange.close();
            });
            server.start();
            GeminiClient client = new GeminiClient(RestClient.builder(), "test-key", "gemini-3.5-flash-lite",
                    "http://127.0.0.1:" + server.getAddress().getPort());
            assertEquals("Hay manzanas.", client.answer("¿Qué hay?"));
        } finally {
            server.stop(0);
        }
    }

    @Test
    void missingKeyFailsWithoutNetworkCall() {
        GeminiClient client = new GeminiClient(RestClient.builder(), "", "gemini-3.5-flash-lite",
                "http://127.0.0.1:1");
        assertThrows(AssistantUnavailableException.class, () -> client.answer("question"));
    }
}
