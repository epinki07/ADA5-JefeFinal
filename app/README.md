# ADA 4: Firebase Authentication y productos

La app valida el formato del correo y la contraseña, inicia sesión en Firebase
Authentication y, al entrar, consulta `GET /products` del backend Spring Boot.

## Configuración de Firebase

1. En Firebase Console, crea un proyecto y registra una app Web (`</>`).
2. En **Authentication > Sign-in method**, activa **Correo electrónico/Contraseña**.
3. En **Authentication > Users**, agrega un usuario de prueba con una contraseña
   de 8 o más caracteres, mayúscula, minúscula, número y símbolo.
4. Copia `lib/firebase_options.example.dart` a `lib/firebase_options.dart`
   y reemplaza los cuatro valores con los de **Configuración del proyecto > Tus apps**.
   El archivo real está ignorado por Git.

## Ejecutar

Inicia el backend `market-backend-2026-3-b` con `./gradlew bootRun`. Debe
responder con JSON en `http://localhost:8090/products`.

```sh
flutter pub get
flutter run -d chrome
```

Para el emulador Android, la app usa automáticamente `http://10.0.2.2:8090`.
En un teléfono físico, indica la IP de la computadora:

```sh
flutter run --dart-define=API_BASE_URL=http://TU_IP_LOCAL:8090
```

## Evidencias solicitadas

- Login exitoso con el usuario creado en Firebase Authentication y productos visibles.
- Credenciales incorrectas con formato válido: mensaje general, sin error en un campo.
- Correo o contraseña con formato inválido: error en el campo correspondiente.
- IntelliJ ejecutando el backend y navegador mostrando el JSON sin formato en
  `http://localhost:8090/products`.
