-- Use the included images unless catalog_image_base names a Supabase public bucket.
\if :{?catalog_image_base}
\else
\set catalog_image_base '/catalog-images'
\endif

UPDATE productos
SET image_url = rtrim(:'catalog_image_base', '/') || '/' || codigo_barras || '.webp'
WHERE codigo_barras IN (
  '7501000000011', '7501000000028', '7501000000035', '7501000000042',
  '7501000000059', '7501000000066', '7501000000073', '7501000000080',
  '7501000000097', '7501000000103'
)
AND (NULLIF(btrim(image_url), '') IS NULL OR image_url = '/catalog-images/' || codigo_barras || '.webp')
AND image_url IS DISTINCT FROM rtrim(:'catalog_image_base', '/') || '/' || codigo_barras || '.webp';
