import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kimikoe_app/models/table_and_column_name.dart';
import 'package:kimikoe_app/services/supabase_services/supabase_delete.dart';
import 'package:mock_supabase_http_client/mock_supabase_http_client.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../test_utils/test_helpers.dart';

void main() {
  late final SupabaseClient errorSupabase;
  late final SupabaseClient mockSupabase;
  late final MockSupabaseHttpClient mockHttpClient;

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

      await deleteDataFromTable(
        table: TableName.artists,
        targetColumn: ColumnName.id,
        targetValue: '1',
        context: mockContext,
        supabase: mockSupabase,
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
        await deleteDataFromTable(
          table: TableName.artists,
          targetColumn: ColumnName.id,
          targetValue: '1',
          context: mockContext,
          supabase: errorSupabase,
        );

        expect(find.byType(SnackBar), findsOneWidget);
        expect(
          find.text('ータの削除中にエラーが発生しました。名前: 1'),
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