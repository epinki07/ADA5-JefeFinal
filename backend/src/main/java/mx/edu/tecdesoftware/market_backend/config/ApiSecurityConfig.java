package mx.edu.tecdesoftware.market_backend.config;

import java.time.Instant;
import java.util.Arrays;
import java.util.Set;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Profile;
import org.springframework.http.HttpMethod;
import org.springframework.security.authorization.AuthorizationDecision;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configurers.AbstractHttpConfigurer;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.oauth2.core.DelegatingOAuth2TokenValidator;
import org.springframework.security.oauth2.core.OAuth2Error;
import org.springframework.security.oauth2.core.OAuth2TokenValidator;
import org.springframework.security.oauth2.core.OAuth2TokenValidatorResult;
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.security.oauth2.jwt.JwtDecoder;
import org.springframework.security.oauth2.jwt.JwtValidators;
import org.springframework.security.oauth2.jwt.NimbusJwtDecoder;
import org.springframework.security.oauth2.server.resource.authentication.JwtAuthenticationToken;
import org.springframework.security.web.SecurityFilterChain;

@Configuration
public class ApiSecurityConfig {
    private static final String FIREBASE_JWKS =
            "https://www.googleapis.com/service_accounts/v1/jwk/securetoken@system.gserviceaccount.com";

    @Bean
    @Profile("production")
    SecurityFilterChain productionApi(
            HttpSecurity http,
            @Value("${ada5.firebase.operator-uids}") String configuredUids) throws Exception {
        Set<String> operatorUids = Arrays.stream(configuredUids.split(","))
                .map(String::strip)
                .filter(uid -> !uid.isEmpty())
                .collect(Collectors.toUnmodifiableSet());

        return http
                .csrf(AbstractHttpConfigurer::disable)
                .sessionManagement(session -> session.sessionCreationPolicy(SessionCreationPolicy.STATELESS))
                .authorizeHttpRequests(routes -> routes
                        .requestMatchers(HttpMethod.GET, "/healthz", "/catalog-images/**").permitAll()
                        .requestMatchers(HttpMethod.HEAD, "/healthz", "/catalog-images/**").permitAll()
                        .requestMatchers(HttpMethod.GET, "/products", "/products/**", "/categories").authenticated()
                        .requestMatchers("/products/**", "/sales", "/sales/**", "/purchases/**", "/assistant")
                        .access((authentication, context) -> new AuthorizationDecision(
                                authentication.get() instanceof JwtAuthenticationToken jwt
                                        && jwt.isAuthenticated()
                                        && operatorUids.contains(jwt.getToken().getSubject())))
                        .anyRequest().denyAll())
                .oauth2ResourceServer(oauth -> oauth.jwt(jwt -> {}))
                .build();
    }

    @Bean
    @Profile("production")
    JwtDecoder firebaseJwtDecoder(@Value("${ada5.firebase.project-id}") String projectId) {
        if (projectId.isBlank() || projectId.startsWith("demo-")) {
            throw new IllegalArgumentException("Configure a live Firebase project for the production API.");
        }
        NimbusJwtDecoder decoder = NimbusJwtDecoder.withJwkSetUri(FIREBASE_JWKS).build();
        decoder.setJwtValidator(firebaseClaims(projectId));
        return decoder;
    }

    static OAuth2TokenValidator<Jwt> firebaseClaims(String projectId) {
        return new DelegatingOAuth2TokenValidator<>(
                JwtValidators.createDefaultWithIssuer("https://securetoken.google.com/" + projectId),
                token -> {
                    Instant limit = Instant.now().plusSeconds(60);
                    Object authTime = token.getClaim("auth_time");
                    boolean valid = token.getAudience() != null && token.getAudience().contains(projectId)
                            && token.getSubject() != null && !token.getSubject().isBlank()
                            && token.getExpiresAt() != null
                            && token.getIssuedAt() != null && !token.getIssuedAt().isAfter(limit)
                            && authTime instanceof Number time && time.longValue() <= limit.getEpochSecond();
                    if (valid) {
                        return OAuth2TokenValidatorResult.success();
                    }
                    return OAuth2TokenValidatorResult.failure(
                            new OAuth2Error("invalid_token", "Invalid Firebase token claims.", null));
                });
    }

    @Bean
    @Profile("!production")
    SecurityFilterChain localApi(HttpSecurity http) throws Exception {
        return http
                .csrf(AbstractHttpConfigurer::disable)
                .headers(headers -> headers.frameOptions(frame -> frame.sameOrigin()))
                .authorizeHttpRequests(routes -> routes.anyRequest().permitAll())
                .build();
    }
}
