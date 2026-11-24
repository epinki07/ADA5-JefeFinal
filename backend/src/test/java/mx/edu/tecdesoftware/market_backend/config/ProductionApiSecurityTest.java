package mx.edu.tecdesoftware.market_backend.config;

import static org.springframework.security.test.web.servlet.request.SecurityMockMvcRequestPostProcessors.jwt;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.web.servlet.MockMvc;

@SpringBootTest(properties = {
        "spring.datasource.url=jdbc:h2:mem:productionSecurity;DB_CLOSE_DELAY=-1",
        "spring.datasource.driver-class-name=org.h2.Driver",
        "spring.datasource.username=sa",
        "spring.datasource.password=",
        "spring.sql.init.mode=always",
        "ada5.firebase.project-id=ada5-test",
        "ada5.firebase.operator-uids=operator-1"
})
@AutoConfigureMockMvc
@ActiveProfiles("production")
class ProductionApiSecurityTest {
    @Autowired
    MockMvc api;

    @Test
    void publicChecksAndImagesWorkButGuestCatalogIsRejected() throws Exception {
        api.perform(get("/healthz"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.status").value("up"));
        api.perform(get("/catalog-images/7501000000011.webp"))
                .andExpect(status().isOk());
        api.perform(get("/products"))
                .andExpect(status().isUnauthorized());
    }

    @Test
    void signedInViewersCanReadCatalogButOnlyOperatorsAccessSalesAndWrites() throws Exception {
        var viewer = jwt().jwt(token -> token.subject("viewer-1"));
        var operator = jwt().jwt(token -> token.subject("operator-1"));

        api.perform(get("/products").with(viewer))
                .andExpect(status().isOk());
        api.perform(post("/products/save").with(viewer))
                .andExpect(status().isForbidden());
        api.perform(get("/sales").with(viewer))
                .andExpect(status().isForbidden());
        api.perform(get("/sales").with(operator))
                .andExpect(status().isOk());
        api.perform(get("/v3/api-docs").with(operator))
                .andExpect(status().isForbidden());
    }
}
