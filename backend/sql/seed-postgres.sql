-- Idempotent sample catalog for an ADA5 PostgreSQL database created by JPA.
INSERT INTO categorias (descripcion, estado)
SELECT seed.descripcion, true
FROM (VALUES ('Frutas y verduras'), ('Lacteos'), ('Panaderia')) AS seed(descripcion)
WHERE NOT EXISTS (
  SELECT 1 FROM categorias c WHERE c.descripcion = seed.descripcion
);

INSERT INTO productos (nombre, id_categoria, codigo_barras, precio_venta, cantidad_stock, estado)
SELECT seed.nombre, c.id_categoria, seed.codigo_barras, seed.precio_venta, seed.cantidad_stock, true
FROM (VALUES
  ('Manzana roja', 'Frutas y verduras', '7501000000011', 18.0, 60),
  ('Platano', 'Frutas y verduras', '7501000000028', 14.0, 45),
  ('Leche entera', 'Lacteos', '7501000000035', 28.0, 30),
  ('Pan integral', 'Panaderia', '7501000000042', 35.0, 20),
  ('Naranja', 'Frutas y verduras', '7501000000059', 16.0, 52),
  ('Zanahoria', 'Frutas y verduras', '7501000000066', 12.0, 38),
  ('Yogur natural', 'Lacteos', '7501000000073', 24.0, 18),
  ('Queso fresco', 'Lacteos', '7501000000080', 48.0, 22),
  ('Bolillo', 'Panaderia', '7501000000097', 7.0, 65),
  ('Concha', 'Panaderia', '7501000000103', 15.0, 28)
) AS seed(nombre, categoria, codigo_barras, precio_venta, cantidad_stock)
JOIN categorias c ON c.descripcion = seed.categoria
WHERE NOT EXISTS (
  SELECT 1 FROM productos p WHERE p.codigo_barras = seed.codigo_barras
);
