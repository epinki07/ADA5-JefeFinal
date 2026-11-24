import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

typedef ApiTokenReader = Future<String?> Function(bool forceRefresh);

class ApiClient {
  ApiClient(
    this._http, {
    required this._protectedApi,
    required this._readToken,
  });

  static final shared = ApiClient(
    http.Client(),
    protectedApi: const bool.fromEnvironment('ADA5_PROTECTED_API'),
    readToken: (forceRefresh) async =>
        FirebaseAuth.instance.currentUser?.getIdToken(forceRefresh),
  );

  final http.Client _http;
  final bool _protectedApi;
  final ApiTokenReader _readToken;
  static const _defaultTimeout = Duration(
    seconds: int.fromEnvironment('ADA5_REQUEST_TIMEOUT_SECONDS', defaultValue: 25),
  );

  Future<http.Response> request(
    String baseUrl,
    String path, {
    String method = 'GET',
    Map<String, Object?>? body,
    Duration timeout = _defaultTimeout,
  }) {
    final base = baseUrl.replaceFirst(RegExp(r'/+$'), '');
    final uri = Uri.parse('$base$path');
    if (_protectedApi && (uri.scheme != 'https' || uri.host.isEmpty)) {
      throw StateError('A protected API requires an HTTPS origin.');
    }
    return _request(uri, method, body).timeout(timeout);
  }

  Future<http.Response> _request(
    Uri uri,
    String method,
    Map<String, Object?>? body,
  ) async {
    var response = await _send(uri, method, body, forceRefresh: false);
    if (_protectedApi && response.statusCode == 401 && method == 'GET') {
      response = await _send(uri, method, body, forceRefresh: true);
    }
    return response;
  }

  Future<http.Response> _send(
    Uri uri,
    String method,
    Map<String, Object?>? body, {
    required bool forceRefresh,
  }) async {
    final request = http.Request(method, uri)..followRedirects = false;
    request.headers['Accept'] = 'application/json';
    if (body != null) {
      request.headers['Content-Type'] = 'application/json; charset=utf-8';
      request.body = jsonEncode(body);
    }
    if (_protectedApi) {
      final token = await _readToken(forceRefresh);
      if (token == null || token.isEmpty) {
        throw StateError('You need to sign in to access the API.');
      }
      request.headers['Authorization'] = 'Bearer $token';
    }
    return http.Response.fromStream(await _http.send(request));
  }
}
