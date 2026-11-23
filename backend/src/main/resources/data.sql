INSERT INTO categorias (descripcion, estado) VALUES
    ('Frutas y verduras', true),
    ('Lacteos', true),
    ('Panaderia', true);

INSERT INTO productos (nombre, id_categoria, codigo_barras, precio_venta, cantidad_stock, estado, image_url) VALUES
    ('Manzana roja', 1, '7501000000011', 18, 60, true, '/catalog-images/7501000000011.webp'),
    ('Platano', 1, '7501000000028', 14, 45, true, '/catalog-images/7501000000028.webp'),
    ('Leche entera', 2, '7501000000035', 28, 30, true, '/catalog-images/7501000000035.webp'),
    ('Pan integral', 3, '7501000000042', 35, 20, true, '/catalog-images/7501000000042.webp'),
    ('Naranja', 1, '7501000000059', 16, 52, true, '/catalog-images/7501000000059.webp'),
    ('Zanahoria', 1, '7501000000066', 12, 38, true, '/catalog-images/7501000000066.webp'),
    ('Yogur natural', 2, '7501000000073', 24, 18, true, '/catalog-images/7501000000073.webp'),
    ('Queso fresco', 2, '7501000000080', 48, 22, true, '/catalog-images/7501000000080.webp'),
    ('Bolillo', 3, '7501000000097', 7, 65, true, '/catalog-images/7501000000097.webp'),
    ('Concha', 3, '7501000000103', 15, 28, true, '/catalog-images/7501000000103.webp');

INSERT INTO clientes (id, nombre, apellidos, celular, direccion, correo_electronico) VALUES
    ('CLI001', 'Diego', 'Ramirez', 9991234567, 'Merida, Yucatan', 'diego@example.com');

INSERT INTO compras (id_cliente, fecha, medio_pago, comentario, estado) VALUES
    ('CLI001', CURRENT_TIMESTAMP, 'E', 'Compra de prueba', 'A');

INSERT INTO compras_productos (id_compra, id_producto, cantidad, total, estado) VALUES
    (1, 1, 2, 36.0, true),
    (1, 3, 1, 28.0, true);
