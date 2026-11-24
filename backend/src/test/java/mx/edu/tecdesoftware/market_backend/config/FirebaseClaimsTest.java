package mx.edu.tecdesoftware.market_backend.config;

import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertTrue;

import java.time.Instant;
import java.util.List;

import org.junit.jupiter.api.Test;
import org.springframework.security.oauth2.jwt.Jwt;

class FirebaseClaimsTest {
    @Test
    void validatesProjectAndExpiration() {
        var validator = ApiSecurityConfig.firebaseClaims("ada5-test");
        var now = Instant.now();

        assertFalse(validator.validate(token("ada5-test", now.plusSeconds(300))).hasErrors());
        assertTrue(validator.validate(token("other-project", now.plusSeconds(300))).hasErrors());
        assertTrue(validator.validate(token("ada5-test", now.minusSeconds(180))).hasErrors());
    }

    private Jwt token(String audience, Instant expires) {
        Instant issued = Instant.now().minusSeconds(300);
        return Jwt.withTokenValue("fixture")
                .header("alg", "RS256")
                .issuer("https://securetoken.google.com/ada5-test")
                .audience(List.of(audience))
                .subject("test-uid")
                .issuedAt(issued)
                .expiresAt(expires)
                .claim("auth_time", issued.getEpochSecond())
                .build();
    }
}
