import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:login_river_animation/api_client.dart';

void main() {
  test('protected reads refresh a rejected token once over HTTPS', () async {
    final seen = <String?>[];
    final httpClient = MockClient((request) async {
      seen.add(request.headers['Authorization']);
      expect(request.followRedirects, isFalse);
      return http.Response('[]', seen.length == 1 ? 401 : 200);
    });
    final client = ApiClient(
      httpClient,
      protectedApi: true,
      readToken: (refresh) async => refresh ? 'fresh' : 'old',
    );
    final result = await client.request('https://api.example.com/', '/products');
    expect(result.statusCode, 200);
    expect(seen, ['Bearer old', 'Bearer fresh']);
  });

  test('protected writes are never replayed after a response', () async {
    var calls = 0;
    final httpClient = MockClient((request) async {
      calls++;
      return http.Response('', 401);
    });
    final client = ApiClient(
      httpClient,
      protectedApi: true,
      readToken: (_) async => 'old',
    );
    final result = await client.request(
      'https://api.example.com',
      '/sales',
      method: 'POST',
      body: {'requestId': 'test'},
    );
    expect(result.statusCode, 401);
    expect(calls, 1);
  });

  test('protected requests cannot send a token over plain HTTP', () {
    final client = ApiClient(
      MockClient((_) async => throw StateError('Transport was reached.')),
      protectedApi: true,
      readToken: (_) async => throw StateError('Token reader was reached.'),
    );
    expect(
      () => client.request('http://localhost:8090', '/products'),
      throwsStateError,
    );
  });
}
