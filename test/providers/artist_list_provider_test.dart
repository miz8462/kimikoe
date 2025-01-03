// TODO: supabase_serviceを先にテスト
import 'package:flutter_test/flutter_test.dart';
import 'package:kimikoe_app/models/artist.dart';
import 'package:kimikoe_app/models/table_and_column_name.dart';
import 'package:kimikoe_app/providers/artist_list_provider.dart';
import 'package:kimikoe_app/providers/logger_provider.dart';
import 'package:mock_supabase_http_client/mock_supabase_http_client.dart';
import 'package:mockito/mockito.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../test_utils/mocks/logger_mock.dart';
import '../test_utils/test_helpers.dart';

void main() {
  setUpAll(() {
    logger = MockLogger();
  });
  group('ArtistListNotifier', () {
    late ArtistsNotifier notifier;
    setUp(() {
      final artist = Artist(
        id: 1,
        name: 'test artist',
        imageUrl: 'https://example.com/test.jpg',
      );

      notifier = ArtistsNotifier([artist]);
    });
    test('アーティストデータを取得する', () {
      final result = notifier.getArtistById(1);
      expect(result!.name, 'test artist');
    });

    test('IDがnullの場合はnullを返す', () {
      final result = notifier.getArtistById(null);
      expect(result, isNull);
      verify(logger.w('アーティストのIDがNULLです')).called(1);
    });

    test('IDが見つからない場合は例外をスローする', () {
      expect(() => notifier.getArtistById(999), throwsA(isA<StateError>()));
      verify(logger.e('IDが 999 のアーティストが見つかりませんでした'));
      //
      try {
        notifier.getArtistById(999);
      } catch (e) {
        verify(logger.e('ID:999 のアーティストを見つける際にエラーが発生しました', error: e));
      }
    });
  });

  group('artistListFromSupabaseProvider', () {
    late final SupabaseClient mockSupabase;
    late final SupabaseClient errorSupabase;
    late final MockSupabaseHttpClient mockHttpClient;

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
    });

    setUp(() async {
      final artist = {
        ColumnName.id: 1,
        ColumnName.name: 'Artist 1',
        ColumnName.imageUrl: 'https://example.com/artist1.jpg',
        ColumnName.comment: 'Great artist',
      };
      await mockSupabase.from(TableName.artists).insert(artist);
      resetMockitoState();
    });

    tearDown(() async {
      mockHttpClient.reset();
    });

    test('Supabaseからデータを取得', () async {
      // ProviderContainerを作りモックを渡す
      final container = supabaseContainer(
        supabaseClient: mockSupabase,
      );

      final artists = await container.read(artistsFromSupabaseProvider.future);

      expect(artists.length, 1);
      expect(artists.first.name, 'Artist 1');
      verify(logger.i('Supabaseからアーティストデータを取得中...')).called(1);
      verify(logger.i('1件のアーティストデータをSupabaseから取得しました')).called(1);
      verify(logger.i('1件のアーティストデータをリストにしました')).called(1);

      // 忘れずコンテナは破棄する。そうしないと他のテストに影響してしまう。
      container.dispose();
    });

    test('Supabaseからデータを取得中にエラーが発生した場合', () async {
      final container = supabaseContainer(
        supabaseClient: errorSupabase,
      );
      try {
        await container.read(artistsFromSupabaseProvider.future);
      } catch (e) {
        verify(
          logger.e(
            'アーティストリストの取得またはマッピング中にエラーが発生しました',
            error: anything,
          ),
        ).called(1);
      }

      // 忘れずコンテナは破棄する。そうしないと他のテストに影響してしまう。
      container.dispose();
    });
  });

  test('artistListProvider', () async {
    final mockSupabase = SupabaseClient(
      'https://mock.supabase.co',
      'fakeAnonKey',
      httpClient: MockSupabaseHttpClient(),
    );
    final container = supabaseContainer(supabaseClient: mockSupabase);

    // StateNotifier インスタンスを取得
    container.read(artistsProvider.notifier);
    await container.read(artistsFromSupabaseProvider.future);
    // 現在の「状態」にアクセス
    final emptyList = container.read(artistsProvider);

    // DBが空の時は、空のリストを返す
    expect(emptyList, isEmpty);
    expect(emptyList.length, 0);

    // テストデータの作成と登録
    final artists = [
      {
        ColumnName.id: 1,
        ColumnName.name: 'Artist 1',
        ColumnName.imageUrl: 'https://example.com/artist1.jpg',
        ColumnName.comment: 'Great artist',
      },
      {
        ColumnName.id: 2,
        ColumnName.name: 'Artist 2',
        ColumnName.imageUrl: 'https://example.com/artist2.jpg',
        ColumnName.comment: 'Good artist',
      }
    ];
    for (final artist in artists) {
      await mockSupabase.from(TableName.artists).insert(artist);
    }

    // プロバイダーのキャッシュをクリア
    container.refresh(artistsFromSupabaseProvider);
    container.refresh(artistsProvider);

    // テストに必要なデータを事前にロードする必要がある
    await container.read(artistsFromSupabaseProvider.future);

    // StateNotifier インスタンスを取得
    final artistsNotifier = container.read(artistsProvider.notifier);
    // 現在の「状態」にアクセス
    final artistList = container.read(artistsProvider);

    expect(artistList.length, 2);

    final artist1 = artistsNotifier.getArtistById(1);
    final artist2 = artistsNotifier.getArtistById(2);

    expect(artist1, isNotNull);
    expect(artist1!.name, 'Artist 1');
    expect(artist2, isNotNull);
    expect(artist2!.comment, 'Good artist');
  });
}
