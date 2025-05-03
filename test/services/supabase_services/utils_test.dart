import 'package:flutter_test/flutter_test.dart';
import 'package:kimikoe_app/models/artist.dart';
import 'package:kimikoe_app/models/table_and_column_name.dart';
import 'package:kimikoe_app/providers/logger_provider.dart';
import 'package:kimikoe_app/services/supabase_services/utils.dart';
import 'package:mock_supabase_http_client/mock_supabase_http_client.dart';
import 'package:mockito/mockito.dart';

import '../../test_utils/mocks/a_mock_generater.mocks.dart';
import '../../test_utils/mocks/logger.mocks.dart';
import '../../test_utils/test_utils.dart';

void main() {
  late MockSupabaseHttpClient mockHttpClient;
  late Utils supabaseUtils;
  late MockLogger mockLogger;
  late MockSupabaseFetch mockSupabaseFetch;
  late MockSupabaseStorage mockSupabaseStorage;

  setUpAll(() async {
    final container = await TestUtils.setupTestContainer();
    mockLogger = container.read(loggerProvider) as MockLogger;
    mockHttpClient = MockSupabaseHttpClient();

    mockSupabaseFetch = MockSupabaseFetch();
    mockSupabaseStorage = MockSupabaseStorage();

    // モックの設定
    when(mockSupabaseFetch.fetchArtistsList()).thenAnswer((_) async => []);
    when(mockSupabaseStorage.fetchImageUrl(any)).thenReturn('');

    supabaseUtils =
        Utils(fetch: mockSupabaseFetch, storage: mockSupabaseStorage);
  });

  tearDown(() {
    mockHttpClient.reset();
    reset(mockLogger);
    reset(mockSupabaseFetch);
    reset(mockSupabaseStorage);
  });

  tearDownAll(() async {
    await TestUtils.cleanup();
  });

  group('createArtistList', () {
    test('アーティストのリストを取得', () async {
      // モックデータを設定
      when(mockSupabaseFetch.fetchArtistsList()).thenAnswer(
        (_) async => [
          {
            ColumnName.id: 1,
            ColumnName.name: 'test artist',
            ColumnName.imageUrl: 'test.jpg',
            ColumnName.comment: 'comment',
          },
        ],
      );
      when(mockSupabaseStorage.fetchImageUrl(any))
          .thenReturn('https://example.com/test.jpg');

      final artists = await supabaseUtils.createArtistList();

      expect(artists, isA<List<Artist>>());
      expect(artists.length, 1, reason: 'リストに1件のデータが含まれるはず');
      expect(artists[0].name, 'test artist');
      expect(artists[0].imageUrl, 'https://example.com/test.jpg');
    });

    test('createArtistListの例外処理', () async {
      when(mockSupabaseFetch.fetchArtistsList())
          .thenThrow(Exception('Fetch error'));

      final artists = await supabaseUtils.createArtistList();

      expect(artists, isEmpty);
    });
  });

  group('fetchSelectedDataIdFromName', () {
    final mockDataList = <Map<String, dynamic>>[
      {
        'id': 1,
        'name': 'test idol',
      },
      {
        'id': 2,
        'name': 'test idol2',
      },
    ];

    test('正常にデータIDを取得できる', () {
      final idolId =
          supabaseUtils.findDataIdByName(list: mockDataList, name: 'test idol');
      expect(idolId, 1);
    });

    test('指定された名前がない場合はnullを返す', () {
      final result = supabaseUtils.findDataIdByName(
        list: mockDataList,
        name: 'test idol3',
      );
      expect(result, isNull);
    });
  });
}
