import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

void main() {
  test('HTTPリクエストのモックテスト', () async {
    // Dioクライアントのモック作成
    final dio = Dio();
    final dioAdapter = DioAdapter(dio: dio);

    // モックレスポンスの設定
    const url = 'https://example.com/image.jpg';
    dioAdapter.onGet(
      url,
      (server) => server.reply(
        200,
        {'message': 'mock image data'}, // JSON形式のオブジェクトとして返す
      ),
    );

    // リクエストを実行
    final response = await dio.get<Map<String, dynamic>>(url);

    // レスポンスの検証
    expect(response.statusCode, 200);
    expect(response.data?['message'], 'mock image data');
  });
}
