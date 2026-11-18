import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ProductApi {
  static const _configuredBaseUrl = String.fromEnvironment('API_BASE_URL');

  String get baseUrl {
    if (_configuredBaseUrl.isNotEmpty) return _configuredBaseUrl;
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:8090';
    }
    return 'http://localhost:8090';
  }

  Future<List<Map<String, dynamic>>> getProducts() async {
    final response = await http.get(Uri.parse('$baseUrl/products'));
    if (response.statusCode == 404) return [];
    _check(response, 200);
    final data = jsonDecode(response.body);
    if (data is! List) throw const FormatException('Invalid product list.');
    return data.map((item) => Map<String, dynamic>.from(item as Map)).toList();
  }

  Future<Map<int, String>> getCategories() async {
    final response = await http.get(Uri.parse('$baseUrl/categories'));
    _check(response, 200);
    final data = jsonDecode(response.body);
    if (data is! List) throw const FormatException('Invalid category list.');
    return {
      for (final item in data)
        (item as Map)['categoryId'] as int: item['category'].toString(),
    };
  }

  Future<void> saveProduct(Map<String, dynamic> product, {int? id}) async {
    final response = id == null
        ? await http.post(
            Uri.parse('$baseUrl/products/save'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(product),
          )
        : await http.put(
            Uri.parse('$baseUrl/products/$id'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(product),
          );
    _check(response, id == null ? 201 : 200);
  }

  Future<void> deleteProduct(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/products/delete/$id'),
    );
    _check(response, 200);
  }

  Future<String> askAssistant(String question) async {
    final response = await http.post(
      Uri.parse('$baseUrl/assistant'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'question': question}),
    );
    _check(response, 200);
    final data = jsonDecode(response.body);
    if (data is! Map || data['answer'] is! String) {
      throw const FormatException('Invalid assistant response.');
    }
    return data['answer'] as String;
  }

  void _check(http.Response response, int expectedStatus) {
    if (response.statusCode != expectedStatus) {
      throw ProductApiException(response.statusCode);
    }
  }
}

class ProductApiException implements Exception {
  const ProductApiException(this.statusCode);
  final int statusCode;
}
