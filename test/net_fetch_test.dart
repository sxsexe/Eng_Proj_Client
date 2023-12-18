import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:my_eng_program/data/model_category.dart';
import 'package:my_eng_program/data/net.dart';

import 'net_fetch_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  group('fetchCategories', () {
    test('returns Categories if the http call completes successfully', () async {
      final client = MockClient();

      // Use Mockito to return a successful response when it calls the
      // provided http.Client.
      when(client.get(Uri.parse('https://jsonplaceholder.typicode.com/albums/1'))).thenAnswer((_) async =>
          http.Response(
              '[{"id": 2, "title": "mock1"}, {"id": 3, "title": "mock2"}, {"id": 4, "title": "mock4"}]', 200));
    });

    test('throws an exception if the http call completes with an error', () {
      final client = MockClient();

      // Use Mockito to return an unsuccessful response when it calls the
      // provided http.Client.
      when(client.get(Uri.parse('https://jsonplaceholder.typicode.com/albums/1')))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      expect(fetchCategories(client), throwsException);
    });
  });
}
