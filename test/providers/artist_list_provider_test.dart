// TODO: supabase_serviceを先にテスト
import 'package:flutter_test/flutter_test.dart';
import 'package:kimikoe_app/models/artist.dart';
import 'package:kimikoe_app/models/table_and_column_name.dart';
import 'package:kimikoe_app/providers/artist_list_provider.dart';
import 'package:kimikoe_app/providers/logger_provider.dart';
import 'package:kimikoe_app/providers/supabase_provider.dart';
import 'package:mock_supabase_http_client/mock_supabase_http_client.dart';
import 'package:mockito/mockito.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../test_utils/mocks/logger_mock.dart';
import '../test_utils/test_helpers.dart';

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
      verify(mockLogger.w('アーティストのIDがNULLです')).called(1);
    });

    test('IDが見つからない場合は例外をスローする', () {
      expect(() => notifier.getArtistById(999), throwsA(isA<StateError>()));
      verify(mockLogger.e('IDが 999 のアーティストが見つかりませんでした'));
      //
      try {
        notifier.getArtistById(999);
      } catch (e) {
        verify(mockLogger.e('ID:999 のアーティストを見つける際にエラーが発生しました', error: e));
      }
    });
  });

  group('artistListFromSupabaseProvider', () {
    late final SupabaseClient mockSupabase;
    late final SupabaseClient errorSupabase;
    late final MockSupabaseHttpClient mockHttpClient;
    late final MockLogger mockLogger;

    setUpAll(() {
      mockHttpClient = MockSupabaseHttpClient();
      mockSupabase = SupabaseClient(
        'https://mock.supabase.co',
        'fakeAnonKey',
        httpClient: MockSupabaseHttpClient(),
      );
      errorSupabase = SupabaseClient(
        'error',
        'error',
      );
      mockLogger = MockLogger();
    });

    setUp(() async {
      final artist = {
        ColumnName.name: 'Artist 1',
        ColumnName.imageUrl: 'https://example.com/artist1.jpg',
        ColumnName.comment: 'Great artist',
        ColumnName.id: 1,
      };
      await mockSupabase.from(TableName.artists).insert(artist);
      resetMockitoState();
    });

    tearDown(() async {
      mockHttpClient.reset();
    });

    test('Supabaseからデータを取得', () async {
      final container = createContainer(
        overrides: [
          loggerProvider.overrideWith((ref) => mockLogger),
          supabaseProvider.overrideWith((ref) => mockSupabase),
        ],
      );

      final artists =
          await container.read(artistListFromSupabaseProvider.future);

      expect(artists.length, 1);
      expect(artists.first.name, 'Artist 1');
      verify(mockLogger.i('Supabaseからアーティストデータを取得中...')).called(1);
      verify(mockLogger.i('1件のアーティストデータをSupabaseから取得しました')).called(1);
      verify(mockLogger.i('1件のアーティストデータをリストにしました')).called(1);
      container.dispose();
    });

    test('Supabaseからデータを取得中にエラーが発生した場合', () async {
      final container = createContainer(
        overrides: [
          loggerProvider.overrideWith((ref) => mockLogger),
          supabaseProvider.overrideWith((ref) => errorSupabase),
        ],
      );
      try {
        await container.read(artistListFromSupabaseProvider.future);
      } catch (e) {
        verify(
          mockLogger.e(
            'アーティストリストの取得またはマッピング中にエラーが発生しました',
            error: anything,
          ),
        ).called(1);
      }
      container.dispose();
    });
  });
}
