package mx.edu.tecdesoftware.market_backend.persistence.crud;

import jakarta.persistence.LockModeType;
import org.springframework.data.jpa.repository.Lock;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.data.repository.CrudRepository;
import mx.edu.tecdesoftware.market_backend.persistence.entity.Producto;
import java.util.List;
import java.util.Optional;

public interface ProductoCrudRepository extends CrudRepository<Producto, Integer> {

    // Query Method
    /*
        SELECT *
        FROM categorias
        WHERE id_categoria = ?
        ORDER BY nombre ASC
     */
    // Obtener una lista de productos filtrados por id de categoria
    // y ordenarlos ascendentemente por nombre

    List<Producto> findByIdCategoriaOrderByNombreAsc(int idCategoria);
    List<Producto> findByEstadoTrue();
    List<Producto> findByIdCategoriaAndEstadoTrueOrderByNombreAsc(int idCategoria);
    Optional<Producto> findByIdProductoAndEstadoTrue(int idProducto);

    @Lock(LockModeType.PESSIMISTIC_WRITE)
    @Query("select p from Producto p where p.idProducto = :id")
    Optional<Producto> findForUpdate(@Param("id") int id);

    // Obtener los productos escasos
    Optional<List<Producto>> findByCantidadStockLessThanAndEstado(int cantidad,boolean estado);



}
