import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:medicine_lab_reader/core/network/dio/dio_client.dart';
import 'package:medicine_lab_reader/core/network/network_info.dart';

class _Net implements NetworkInfo {
  _Net(this.online);
  final bool online;
  @override
  Future<bool> get isConnected async => online;
}

void main() {
  test(
    'postForm sends a multipart form with fields, file and headers',
    () async {
      final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
      addTearDown(() => server.close(force: true));
      String? type, token;
      String body = '';
      server.listen((req) async {
        type = req.headers.contentType?.mimeType;
        token = req.headers.value('x-test');
        body = latin1.decode(
          await req.fold<List<int>>([], (a, b) => a..addAll(b)),
        );
        req.response
          ..headers.contentType = ContentType.json
          ..write('{"ok":true}');
        await req.response.close();
      });
      final client = DioClient(Dio(), _Net(true));
      final res = await client.postForm(
        'http://127.0.0.1:${server.port}/parse',
        FormData.fromMap({
          'language': 'eng',
          'file': MultipartFile.fromBytes([1, 2, 3], filename: 'p.jpg'),
        }),
        headers: {'x-test': 's'},
      );
      expect(res.data, {'ok': true});
      expect(type, 'multipart/form-data');
      expect(token, 's');
      expect(body, contains('name="language"'));
      expect(body, contains('eng'));
      expect(body, contains('filename="p.jpg"'));
    },
  );

  test('offline requests fail fast instead of waiting', () async {
    final client = DioClient(Dio(), _Net(false));
    expect(
      client.postForm('http://x', FormData()),
      throwsA(isA<OfflineException>()),
    );
    expect(client.get('http://x'), throwsA(isA<OfflineException>()));
  });
}
