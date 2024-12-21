import 'package:flutter_test/flutter_test.dart';
import 'package:kimikoe_app/models/artist.dart';
import 'package:kimikoe_app/models/table_and_column_name.dart';
import 'package:kimikoe_app/providers/logger_provider.dart';
import 'package:kimikoe_app/services/supabase_services/supabase_utils.dart';
import 'package:mock_supabase_http_client/mock_supabase_http_client.dart';
import 'package:mockito/mockito.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../test_utils/mocks/logger_mock.dart';

void main() {
  late final SupabaseClient errorSupabase;
  late final SupabaseClient mockSupabase;
  late final MockSupabaseHttpClient mockHttpClient;
  late final MockLogger mockLogger;

  setUpAll(() async {
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
    logger = mockLogger;
  });

  tearDown(() async {
    mockHttpClient.reset();
  });

  group('createArtistList', () {
    test('アーティストのリストを取得', () async {
      await mockSupabase.from(TableName.artists).insert({
        ColumnName.id: 1,
        ColumnName.name: 'test artist',
        ColumnName.imageUrl: 'https://example.com/test.jpg',
      });

      final artists = await createArtistList(supabase: mockSupabase);

      expect(artists, isA<List<Artist>>());
      expect(artists[0].name, 'test artist');
      verify(logger.i('${artists.length}件のアーティストデータをリストにしました')).called(1);
    });
    test('createArtistListの例外処理', () async {
      try {
        await createArtistList(supabase: errorSupabase);
      } catch (e) {
        verify(logger.e('アーティストリストの取得またはマッピング中にエラーが発生しました')).called(1);
      }
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
      final idolId = findDataIdByName(list: mockDataList, name: 'test idol');
      expect(idolId, 1);
    });
    test('指定された名前がない場合、例外をスローする', () {
      expect(
        () => findDataIdByName(
          list: mockDataList,
          name: 'test idol3',
        ),
        throwsStateError,
      );
    });
  });
}
