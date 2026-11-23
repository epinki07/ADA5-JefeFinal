# Product images

The ten demo products use generated grocery photographs named by barcode. Spring Boot serves the files from `backend/src/main/resources/static/catalog-images/`. The images were made with built-in ImageGen from one clean product-photography contact sheet with ten individual grocery subjects on a warm studio background.

For local PostgreSQL, run `backend/sql/seed-postgres.sql` and then `backend/sql/catalog-images-postgres.sql` against the catalog database. The H2 development catalog includes these image paths automatically.

## Public Supabase bucket

1. In the ADA5 Supabase project, open Storage and create a public bucket named `productos`.
2. Upload the ten WebP files from `backend/src/main/resources/static/catalog-images/` to the bucket root. Keep the barcode filenames.
3. Open one public URL in a private window and confirm that it returns its image. Use the URL prefix through `/storage/v1/object/public/productos` as the `catalog_image_base` value below.
4. Use `psql` with the same authenticated connection you used to seed PostgreSQL. Apply the supplied SQL with the prefix from your bucket:

```sh
psql -v ON_ERROR_STOP=1 \
  -v catalog_image_base='https://PROJECT_REF.supabase.co/storage/v1/object/public/productos' \
  -f backend/sql/catalog-images-postgres.sql
```

Refresh the catalog and verify that `GET /products` returns the public HTTPS URLs. The SQL updates missing and included-demo URLs. It preserves product images already set to custom external URLs. The Flutter app reads public URLs and needs no Supabase storage key.
