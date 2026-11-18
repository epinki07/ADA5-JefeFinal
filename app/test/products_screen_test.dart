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
}
