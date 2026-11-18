import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:login_river_animation/product_api.dart';
import 'package:login_river_animation/screens/shopping_assistant_screen.dart';
import 'package:lottie/lottie.dart';

class FakeProductApi extends ProductApi {
  final response = Completer<String>();
  String? question;

  @override
  Future<String> askAssistant(String question) {
    this.question = question;
    return response.future;
  }
}

void main() {
  testWidgets('asks about the catalog and displays the answer', (tester) async {
    final api = FakeProductApi();
    await tester.pumpWidget(
      MaterialApp(home: ShoppingAssistantScreen(api: api)),
    );

    await tester.enterText(find.byType(TextField), '  ¿Qué frutas hay?  ');
    await tester.tap(find.text('Preguntar'));
    await tester.pump();
    expect(api.question, '¿Qué frutas hay?');
    expect(find.byType(Lottie), findsOneWidget);

    api.response.complete('Hay manzanas.');
    await tester.pumpAndSettle();
    expect(find.text('Hay manzanas.'), findsOneWidget);
  });

  testWidgets('shows unavailable state for an unconfigured provider', (
    tester,
  ) async {
    final api = FakeProductApi();
    await tester.pumpWidget(
      MaterialApp(home: ShoppingAssistantScreen(api: api)),
    );

    await tester.enterText(find.byType(TextField), 'Precio de manzanas');
    await tester.tap(find.text('Preguntar'));
    await tester.pump();
    api.response.completeError(const ProductApiException(503));
    await tester.pumpAndSettle();
    expect(find.textContaining('no está disponible'), findsOneWidget);
  });
}
