package mx.edu.tecdesoftware.market_backend.persistence.crud;

import mx.edu.tecdesoftware.market_backend.persistence.entity.Sale;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.Optional;
import java.util.UUID;

public interface SaleCrudRepository extends JpaRepository<Sale, Long> {
    Optional<Sale> findByRequestId(UUID requestId);
}
