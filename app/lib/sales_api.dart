import 'dart:convert';

import 'package:http/http.dart' as http;

import 'api_client.dart';

enum SalePayment {
  cash('CASH', 'Efectivo'),
  card('CARD', 'Tarjeta'),
  transfer('TRANSFER', 'Transferencia');

  const SalePayment(this.code, this.label);
  final String code;
  final String label;
}

class SaleSummary {
  SaleSummary.fromJson(Map<String, dynamic> json)
    : id = json['id'] as int,
      customer = json['customer'] as String,
      createdAt = DateTime.parse(json['createdAt'] as String).toLocal(),
      payment = SalePayment.values.byName(
        (json['payment'] as String).toLowerCase(),
      ),
      total = json['total'] as String;

  final int id;
  final String customer;
  final DateTime createdAt;
  final SalePayment payment;
  final String total;

  String get folio => 'V-${id.toString().padLeft(5, '0')}';
}

class SaleReceipt {
  SaleReceipt.fromJson(Map<String, dynamic> json)
    : summary = SaleSummary.fromJson(json),
      lines = (json['lines'] as List)
          .cast<Map<String, dynamic>>()
          .map(
            (line) => (
              name: line['name'] as String,
              quantity: line['quantity'] as int,
              unitPrice: line['unitPrice'] as String,
              amount: line['amount'] as String,
            ),
          )
          .toList();

  final SaleSummary summary;
  final List<({String name, int quantity, String unitPrice, String amount})>
  lines;
}

class SalesApi {
  SalesApi(this.baseUrl, {ApiClient? client})
    : _client = client ?? ApiClient.shared;

  final String baseUrl;
  final ApiClient _client;

  Future<({List<SaleSummary> sales, bool hasNext})> getHistory(int page) async {
    final response = await _client.request(baseUrl, '/sales?page=$page');
    final data = _data(response, 200);
    return (
      sales: (data['sales'] as List)
          .cast<Map<String, dynamic>>()
          .map(SaleSummary.fromJson)
          .toList(),
      hasNext: data['hasNext'] as bool,
    );
  }

  Future<SaleReceipt> getReceipt(int id) async {
    final response = await _client.request(baseUrl, '/sales/$id');
    return SaleReceipt.fromJson(_data(response, 200));
  }

  Future<SaleReceipt> record(Map<String, Object> order) async {
    final response = await _client.request(
      baseUrl,
      '/sales',
      method: 'POST',
      body: order,
    );
    return SaleReceipt.fromJson(_data(response, 201));
  }

  Map<String, dynamic> _data(http.Response response, int expected) {
    final body = utf8.decode(response.bodyBytes);
    if (response.statusCode == expected) {
      return jsonDecode(body) as Map<String, dynamic>;
    }
    if (response.statusCode == 400 || response.statusCode == 409) {
      final data = jsonDecode(body) as Map<String, dynamic>;
      throw SaleRejected(data['message'] as String);
    }
    throw StateError('Sales API returned ${response.statusCode}');
  }
}

class SaleRejected implements Exception {
  const SaleRejected(this.message);
  final String message;
}
