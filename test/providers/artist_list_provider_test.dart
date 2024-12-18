// TODO: supabase_serviceを先にテスト
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kimikoe_app/models/artist.dart';
import 'package:kimikoe_app/models/table_and_column_name.dart';
import 'package:kimikoe_app/providers/artist_list_provider.dart';
import 'package:kimikoe_app/providers/logger_provider.dart';
import 'package:kimikoe_app/services/supabase_service.dart';
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
    late final MockSupabaseHttpClient mockHttpClient;
    late final MockLogger mockLogger;
    late final ProviderContainer container;

    setUpAll(() {
      mockHttpClient = MockSupabaseHttpClient();
      mockSupabase = SupabaseClient(
        'https://mock.supabase.co',
        'fakeAnonKey',
        httpClient: MockSupabaseHttpClient(),
      );
      mockLogger = MockLogger();
      container = createContainer(
        overrides: [loggerProvider.overrideWithValue(mockLogger),],
      );
    });

    tearDown(() async {
      mockHttpClient.reset();
    });

    setUp(() {
      final artist = {
        ColumnName.name: 'Artist 1',
        ColumnName.imageUrl: 'https://example.com/artist1.jpg',
        ColumnName.comment: 'Great artist',
        ColumnName.id: 1,
      };
      mockSupabase.from(TableName.artists).insert(artist);
    });

    test('Supabaseからデータを取得', () async {
      await fetchArtists(supabase: mockSupabase);

      final asyncValue = container.read(artistListFromSupabaseProvider.future);
      final artists = await asyncValue;

      expect(artists.length, 1);
      expect(artists.first.name, 'Artist 1');
      verify(mockLogger.i('Supabaseからアーティストデータを取得中...')).called(1);
      verify(mockLogger.i('1件のアーティストデータをSupabaseから取得しました')).called(1);
      verify(mockLogger.i('1件のアーティストデータをリストにしました')).called(1);
    });
  });
}
