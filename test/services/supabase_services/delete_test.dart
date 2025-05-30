import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kimikoe_app/models/table_and_column_name.dart';
import 'package:kimikoe_app/providers/logger_provider.dart';
import 'package:kimikoe_app/services/supabase_services/delete.dart';
import 'package:mock_supabase_http_client/mock_supabase_http_client.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../test_utils/mocks/logger.mocks.dart';
import '../../test_utils/test_helpers.dart';

void main() {
  late final SupabaseClient errorSupabase;
  late final SupabaseClient mockSupabase;
  late final MockSupabaseHttpClient mockHttpClient;
  late final Delete supabaseDelete;

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
    logger = MockLogger();
    supabaseDelete = Delete(mockSupabase);
  });

  tearDown(() async {
    mockHttpClient.reset();
  });
  group('deleteDataFromTable', () {
    testWidgets('deleteDataFromTableの正常動作', (WidgetTester tester) async {
      final mockContext = await createMockContext(tester);

      // 削除するデータの登録と、登録されてることの確認
      await mockSupabase.from(TableName.artists).insert({
        ColumnName.id: 1,
        ColumnName.name: 'delete artist',
      });
      final artists = await mockSupabase.from(TableName.artists).select();
      expect(artists.last[ColumnName.name], 'delete artist');

      await supabaseDelete.deleteDataById(
        table: TableName.artists,
        id: '1',
        context: mockContext,
      );

      // 削除後のデータ
      final artistsAfterDeletion =
          await mockSupabase.from(TableName.artists).select();

      // 削除したデータがリストに含まれていないことの確認
      final containsDeletedArtist = artistsAfterDeletion.any(
        (artist) => artist[ColumnName.name] == 'delete artist',
      );
      expect(containsDeletedArtist, isFalse);
    });
    testWidgets('deleteDataFromTableの例外処理', (WidgetTester tester) async {
      final mockContext = await createMockContext(tester);
      var didThrowError = false;

      // 削除するデータの登録と、登録されてることの確認
      await mockSupabase.from(TableName.artists).insert({
        ColumnName.id: 1,
        ColumnName.name: 'cannot delete artist',
      });
      final artists = await mockSupabase.from(TableName.artists).select();
      expect(artists.last[ColumnName.name], 'cannot delete artist');
      try {
        await Delete(errorSupabase).deleteDataById(
          table: TableName.artists,
          id: '1',
          context: mockContext,
        );

        expect(find.byType(SnackBar), findsOneWidget);
        expect(
          find.text('データの削除中にエラーが発生しました。ID: 1'),
          findsOneWidget,
        );
      } catch (e) {
        didThrowError = true;
      }

      expect(didThrowError, isTrue);

      // 削除に失敗していることの確認
      final artistsAfterDeletion =
          await mockSupabase.from(TableName.artists).select();
      expect(
        artistsAfterDeletion.last[ColumnName.name],
        'cannot delete artist',
      );
    });
  });
}
