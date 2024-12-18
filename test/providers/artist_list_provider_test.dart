// TODO: supabase_serviceを先にテスト
import 'package:flutter_test/flutter_test.dart';
import 'package:kimikoe_app/models/artist.dart';
import 'package:kimikoe_app/providers/artist_list_provider.dart';
import 'package:mockito/mockito.dart';

import '../test_utils/mocks/logger_mock.dart';

void main() {
  group('ArtistListNotifier', () {
    late MockLogger mockLogger;
    late ArtistListNotifier notifier;
    setUp(() {
      mockLogger = MockLogger();
      final artist = Artist(
        id: 1,
        name: 'test artist',
        imageUrl: 'https://example.com/test.jpg',
      );

      notifier = ArtistListNotifier([artist], logger: mockLogger);
    });
    test('アーティストデータを取得する', () {
      final result = notifier.getArtistById(1);
      expect(result!.name, 'test artist');
    });

    test('IDがnullの場合はnullを返す', () {
      final result = notifier.getArtistById(null);
      expect(result, isNull);
      verify(mockLogger.w('アーティストのIDがNULLです'));
    });

    test('IDが見つからない場合は例外をスローする', () {
      try {
        notifier.getArtistById(999);
      } catch (e) {
        verify(mockLogger.e('IDが 999 のアーティストが見つかりませんでした'));
        expect(e, throwsA(isA<StateError>()));
        // 例外をキャッチしていることの確認
        verify(
          mockLogger.e(
            'ID:999 のアーティストを見つける際にエラーが発生しました',
            error: anyNamed('error'),
          ),
        ).called(1);
      }
    });
  });
}


// late final SupabaseClient mockSupabase;
  // late final MockSupabaseHttpClient mockHttpClient;

  // setUpAll(() {
  //   mockHttpClient = MockSupabaseHttpClient();
  //   mockSupabase = SupabaseClient(
  //     'https://mock.supabase.co',
  //     'fakeAnonKey',
  //     httpClient: MockSupabaseHttpClient(),
  //   );
  // });

  // tearDown(() async {
  //   mockHttpClient.reset();
  // });




