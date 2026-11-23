import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:login_river_animation/product_api.dart';
import 'package:login_river_animation/screens/products_screen.dart';

class FakeCatalogApi extends ProductApi {
  final results = Queue<Future<List<Map<String, dynamic>>> Function()>();
  int calls = 0;

  @override
  Future<List<Map<String, dynamic>>> getProducts() {
    calls++;
    return results.removeFirst()();
  }
}

class RecordingCatalogApi extends FakeCatalogApi {
  Map<String, dynamic>? savedProduct;
  int? savedId;
  int? deletedId;

  @override
  Future<void> saveProduct(Map<String, dynamic> product, {int? id}) async {
    savedProduct = product;
    savedId = id;
  }

  @override
  Future<void> deleteProduct(int id) async {
    deletedId = id;
  }
}

final sampleProducts = <Map<String, dynamic>>[
  {
    'productId': 1,
    'name': 'Manzana',
    'categoryId': 1,
    'category': {'category': 'Frutas'},
    'price': 12.5,
    'stock': 8,
    'imageUrl': '',
  },
  {
    'productId': 2,
    'name': 'Leche',
    'categoryId': 2,
    'category': {'category': 'Lácteos'},
    'price': 24.0,
    'stock': 60,
    'imageUrl': '',
  },
];

void main() {
  testWidgets('filters products by name and category', (tester) async {
    final api = FakeCatalogApi()..results.add(() async => sampleProducts);
    await tester.pumpWidget(MaterialApp(home: ProductsScreen(api: api)));
    await tester.pumpAndSettle();

    expect(find.text('Manzana'), findsOneWidget);
    expect(find.text('Leche'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'man');
    await tester.pump();
    expect(find.text('Manzana'), findsOneWidget);
    expect(find.text('Leche'), findsNothing);

    await tester.enterText(find.byType(TextField), '');
    await tester.tap(find.text('Lácteos'));
    await tester.pump();
    expect(find.text('Manzana'), findsNothing);
    expect(find.text('Leche'), findsOneWidget);
  });

  testWidgets('retries after a catalog server error', (tester) async {
    final api = FakeCatalogApi()
      ..results.add(() async => throw Exception('offline'))
      ..results.add(() async => sampleProducts);
    await tester.pumpWidget(MaterialApp(home: ProductsScreen(api: api)));
    await tester.pumpAndSettle();
    expect(find.textContaining('Servidor no disponible'), findsOneWidget);

    await tester.tap(find.text('Reintentar'));
    await tester.pumpAndSettle();
    expect(api.calls, 2);
    expect(find.text('Manzana'), findsOneWidget);
  });

  testWidgets(
    'assistant is reachable from the catalog, not the delete dialog',
    (tester) async {
      final api = FakeCatalogApi()..results.add(() async => sampleProducts);
      await tester.pumpWidget(MaterialApp(home: ProductsScreen(api: api)));
      await tester.pumpAndSettle();

      expect(find.byTooltip('Asistente de compras'), findsOneWidget);
      await tester.tap(find.byTooltip('Eliminar').first);
      await tester.pumpAndSettle();
      expect(find.text('Eliminar producto'), findsOneWidget);
      expect(find.byTooltip('Asistente de compras'), findsOneWidget);
      expect(
        find.descendant(
          of: find.byType(AlertDialog),
          matching: find.byTooltip('Asistente de compras'),
        ),
        findsNothing,
      );

      await tester.tap(find.text('Cancelar'));
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('Asistente de compras'));
      await tester.pumpAndSettle();
      expect(find.text('Asistente de compras'), findsOneWidget);
    },
  );

  testWidgets('creates a product and refreshes the catalog', (tester) async {
    final added = {
      'productId': 3,
      'name': 'Pera',
      'categoryId': 1,
      'category': {'category': 'Frutas'},
      'price': 19.5,
      'stock': 4,
      'imageUrl': '',
    };
    final api = RecordingCatalogApi()
      ..results.add(() async => sampleProducts)
      ..results.add(() async => [...sampleProducts, added]);
    await tester.pumpWidget(MaterialApp(home: ProductsScreen(api: api)));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Agregar'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Nombre'),
      'Pera',
    );
    await tester.tap(
      find.widgetWithText(DropdownButtonFormField<int>, 'Categoría'),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Frutas').last);
    await tester.pumpAndSettle();
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Precio'),
      '19.5',
    );
    await tester.enterText(find.widgetWithText(TextFormField, 'Stock'), '4');
    await tester.tap(find.text('Guardar'));
    await tester.pumpAndSettle();

    expect(api.savedId, isNull);
    expect(api.savedProduct, containsPair('name', 'Pera'));
    expect(api.savedProduct, containsPair('categoryId', 1));
    expect(api.savedProduct, containsPair('price', 19.5));
    expect(api.calls, 2);
    expect(find.text('Pera'), findsOneWidget);
  });

  testWidgets('edits and deletes a product with confirmation', (tester) async {
    final renamed = {...sampleProducts.first, 'name': 'Manzana roja'};
    final api = RecordingCatalogApi()
      ..results.add(() async => sampleProducts)
      ..results.add(() async => [renamed, sampleProducts.last])
      ..results.add(() async => [sampleProducts.last]);
    await tester.pumpWidget(MaterialApp(home: ProductsScreen(api: api)));
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Editar').first);
    await tester.pumpAndSettle();
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Nombre'),
      'Manzana roja',
    );
    await tester.tap(find.text('Guardar'));
    await tester.pumpAndSettle();
    expect(api.savedId, 1);
    expect(api.savedProduct, containsPair('name', 'Manzana roja'));
    expect(find.text('Manzana roja'), findsOneWidget);

    await tester.tap(find.byTooltip('Eliminar').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cancelar'));
    await tester.pumpAndSettle();
    expect(api.deletedId, isNull);

    await tester.tap(find.byTooltip('Eliminar').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Eliminar').last);
    await tester.pumpAndSettle();
    expect(api.deletedId, 1);
    expect(api.calls, 3);
    expect(find.text('Manzana roja'), findsNothing);
  });
}
