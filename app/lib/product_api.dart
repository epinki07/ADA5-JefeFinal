import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'api_client.dart';

class ProductApi {
  ProductApi({ApiClient? client}) : _client = client ?? ApiClient.shared;

  final ApiClient _client;
  static const _configuredBaseUrl = String.fromEnvironment('API_BASE_URL');
  static final _bundledImage = RegExp(r'^/catalog-images/[0-9]{13}\.webp$');

  String get baseUrl {
    if (_configuredBaseUrl.isNotEmpty) return _configuredBaseUrl;
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:8090';
    }
    return 'http://127.0.0.1:8090';
  }

  static bool isBundledImage(String value) => _bundledImage.hasMatch(value);

  String imageUrl(String value) {
    return isBundledImage(value)
        ? Uri.parse(baseUrl).resolve(value).toString()
        : value;
  }

  Future<List<Map<String, dynamic>>> getProducts() async {
    final response = await _client.request(baseUrl, '/products');
    if (response.statusCode == 404) return [];
    _check(response, 200);
    final data = jsonDecode(utf8.decode(response.bodyBytes));
    if (data is! List) throw const FormatException('Invalid product list.');
    return data.map((item) => Map<String, dynamic>.from(item as Map)).toList();
  }

  Future<Map<int, String>> getCategories() async {
    final response = await _client.request(baseUrl, '/categories');
    _check(response, 200);
    final data = jsonDecode(utf8.decode(response.bodyBytes));
    if (data is! List) throw const FormatException('Invalid category list.');
    return {
      for (final item in data)
        (item as Map)['categoryId'] as int: item['category'].toString(),
    };
  }

  Future<void> saveProduct(Map<String, dynamic> product, {int? id}) async {
    final response = await _client.request(
      baseUrl,
      id == null ? '/products/save' : '/products/$id',
      method: id == null ? 'POST' : 'PUT',
      body: product,
    );
    _check(response, id == null ? 201 : 200);
  }

  Future<void> deleteProduct(int id) async {
    final response = await _client.request(
      baseUrl,
      '/products/delete/$id',
      method: 'DELETE',
    );
    _check(response, 200);
  }

  Future<String> askAssistant(String question) async {
    final response = await _client.request(
      baseUrl,
      '/assistant',
      method: 'POST',
      body: {'question': question},
      timeout: const Duration(seconds: 40),
    );
    _check(response, 200);
    final data = jsonDecode(utf8.decode(response.bodyBytes));
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
