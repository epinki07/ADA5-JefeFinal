package mx.edu.tecdesoftware.market_backend.persistence.web.controller;

import java.util.Map;

import org.springframework.dao.DataAccessException;
import org.springframework.http.CacheControl;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class HealthController {
    private final JdbcTemplate database;

    public HealthController(JdbcTemplate database) {
        this.database = database;
    }

    @GetMapping("/healthz")
    public ResponseEntity<Map<String, String>> health() {
        try {
            database.queryForObject("SELECT 1", Integer.class);
            return ResponseEntity.ok().cacheControl(CacheControl.noStore()).body(Map.of("status", "up"));
        } catch (DataAccessException exception) {
            return ResponseEntity.status(HttpStatus.SERVICE_UNAVAILABLE)
                    .cacheControl(CacheControl.noStore())
                    .body(Map.of("status", "down"));
        }
    }
}
