import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kimikoe_app/models/table_and_column_name.dart';
import 'package:kimikoe_app/providers/logger_provider.dart';
import 'package:kimikoe_app/services/supabase_services/supabase_services.dart';
import 'package:mock_supabase_http_client/mock_supabase_http_client.dart';
import 'package:mockito/mockito.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../test_utils/mocks/logger_mock.dart';
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
    logger = MockLogger();
  });

  tearDown(() async {
    mockHttpClient.reset();
  });
  group('updateIdolGroup', () {
    testWidgets('updateIdolGroup', (WidgetTester tester) async {
      final mockContext = await createMockContext(tester);

      // アップデート用のデータを登録。
      // SupabaseのIDは自動生成のためインサート関数にはIDがない。
      // なので、ID付きのモックデータが必要。
      await mockSupabase.from(TableName.idolGroups).insert({
        ColumnName.id: 1,
        ColumnName.name: 'test group',
        ColumnName.comment: 'test comment',
      });

      await SupabaseServices.update.updateIdolGroup(
        id: '1',
        name: 'updated group',
        context: mockContext,
        supabase: mockSupabase,
        imageUrl: 'https://example.com/updated.jpg',
        year: '2024',
        officialUrl: 'https://example.com/updated',
        twitterUrl: 'https://twitter.com/updated',
        instagramUrl: 'https://instagram.com/updated',
        scheduleUrl: 'https://example.com/updated/schedule',
        comment: 'updated comment',
      );

      final updatedGroup = await mockSupabase
          .from(TableName.idolGroups)
          .select()
          .eq(ColumnName.id, 1)
          .single();

      expect(
        updatedGroup[ColumnName.name],
        'updated group',
      );
      expect(
        updatedGroup[ColumnName.comment],
        'updated comment',
      );
      expect(
        updatedGroup[ColumnName.imageUrl],
        'https://example.com/updated.jpg',
      );
      expect(
        updatedGroup[ColumnName.yearFormingGroups],
        2024,
      );
      expect(
        updatedGroup[ColumnName.officialUrl],
        'https://example.com/updated',
      );
      expect(
        updatedGroup[ColumnName.twitterUrl],
        'https://twitter.com/updated',
      );
      expect(
        updatedGroup[ColumnName.instagramUrl],
        'https://instagram.com/updated',
      );
      expect(
        updatedGroup[ColumnName.scheduleUrl],
        'https://example.com/updated/schedule',
      );
    });
    testWidgets('updateIdolGroup', (WidgetTester tester) async {
      final mockContext = await createMockContext(tester);
      var didThrowError = false;

      // アップデート用のデータを登録。
      // SupabaseのIDは自動生成のためインサート関数にはIDがない。
      // なので、ID付きのモックデータが必要。
      await mockSupabase.from(TableName.idolGroups).insert({
        ColumnName.id: 1,
        ColumnName.name: 'test group',
        ColumnName.comment: 'test comment',
      });

      try {
        await SupabaseServices.update.updateIdolGroup(
          id: '1',
          name: 'error',
          context: mockContext,
          supabase: errorSupabase,
        );
        verify(logger.i('グループの更新中にエラーが発生しました。グループ名: error')).called(1);
      } catch (e) {
        didThrowError = true;
      }

      expect(didThrowError, isTrue);
    });
  });

  group('updateIdol', () {
    testWidgets('updateIdolの正常動作', (WidgetTester tester) async {
      final mockContext = await createMockContext(tester);

      // アップデート用のデータを登録。
      // SupabaseのIDは自動生成のためインサート関数にはIDがない。
      // なので、ID付きのモックデータが必要。
      await mockSupabase.from(TableName.idols).insert({
        ColumnName.id: 1,
        ColumnName.name: 'test song',
      });

      await SupabaseServices.update.updateIdol(
        id: 1,
        name: 'updated idol',
        context: mockContext,
        supabase: mockSupabase,
        groupId: 1,
        color: 'white',
        imageUrl: 'https://example.com/updated.jpg',
        birthday: '01-22',
        birthYear: 2002,
        height: 158,
        hometown: 'Sapporo',
        debutYear: 2019,
        comment: 'updated comment',
      );

      final updatedIdol = await mockSupabase
          .from(TableName.idols)
          .select()
          .eq(ColumnName.id, 1)
          .single();

      expect(
        updatedIdol[ColumnName.name],
        'updated idol',
      );
      expect(
        updatedIdol[ColumnName.groupId],
        1,
      );
      expect(
        updatedIdol[ColumnName.color],
        'white',
      );

      expect(
        updatedIdol[ColumnName.imageUrl],
        'https://example.com/updated.jpg',
      );
      expect(
        updatedIdol[ColumnName.birthday],
        '01-22',
      );
      expect(
        updatedIdol[ColumnName.birthYear],
        2002,
      );
      expect(
        updatedIdol[ColumnName.height],
        158,
      );
      expect(
        updatedIdol[ColumnName.hometown],
        'Sapporo',
      );
      expect(
        updatedIdol[ColumnName.debutYear],
        2019,
      );
      expect(
        updatedIdol[ColumnName.comment],
        'updated comment',
      );
    });

    testWidgets('updateIdolの例外処理', (WidgetTester tester) async {
      final mockContext = await createMockContext(tester);
      var didThrowError = false;

      // アップデート用のデータを登録。
      // SupabaseのIDは自動生成のためインサート関数にはIDがない。
      // なので、ID付きのモックデータが必要。
      await mockSupabase.from(TableName.idols).insert({
        ColumnName.id: 1,
        ColumnName.name: 'test song',
      });

      try {
        await SupabaseServices.update.updateIdol(
          id: 1,
          name: 'error idol',
          context: mockContext,
          supabase: errorSupabase,
          groupId: 1,
          color: 'white',
          imageUrl: 'https://example.com/updated.jpg',
          birthday: '01-22',
          birthYear: 2002,
          height: 158,
          hometown: 'Sapporo',
          debutYear: 2019,
          comment: 'updated comment',
        );
        expect(find.byType(SnackBar), findsOneWidget);
        expect(
          find.text('アイドルデータの更新中にエラーが発生しました。アイドル名: error idol'),
          findsOneWidget,
        );
      } catch (e) {
        didThrowError = true;
      }

      expect(didThrowError, isTrue);
    });
  });
  group('updateSong', () {
    testWidgets('updateSong', (WidgetTester tester) async {
      final mockContext = await createMockContext(tester);

      // アップデート用のデータを登録。
      // SupabaseのIDは自動生成のためインサート関数にはIDがない。
      // なので、ID付きのモックデータが必要。
      await mockSupabase.from(TableName.songs).insert({
        ColumnName.id: 1,
        ColumnName.title: 'test song',
        ColumnName.lyrics: 'test lyrics',
      });

      await SupabaseServices.update.updateSong(
        id: 1,
        title: 'updated title',
        lyric: 'updated lyrics',
        context: mockContext,
        supabase: mockSupabase,
        groupId: 1,
        imageUrl: 'https://example.com/updated.jpg',
        releaseDate: '2024-01-22',
        lyricistId: 13,
        composerId: 13,
        comment: 'updated comment',
      );

      final updatedsong = await mockSupabase
          .from(TableName.songs)
          .select()
          .eq(ColumnName.id, 1)
          .single();

      expect(
        updatedsong[ColumnName.title],
        'updated title',
      );
      expect(
        updatedsong[ColumnName.lyrics],
        'updated lyrics',
      );
      expect(
        updatedsong[ColumnName.groupId],
        1,
      );
      expect(
        updatedsong[ColumnName.imageUrl],
        'https://example.com/updated.jpg',
      );
      expect(
        updatedsong[ColumnName.releaseDate],
        '2024-01-22',
      );
      expect(
        updatedsong[ColumnName.lyricistId],
        13,
      );
      expect(
        updatedsong[ColumnName.composerId],
        13,
      );
      expect(
        updatedsong[ColumnName.comment],
        'updated comment',
      );
    });
    testWidgets('updateSong', (WidgetTester tester) async {
      final mockContext = await createMockContext(tester);
      var didThrowError = false;

      // アップデート用のデータを登録。
      // SupabaseのIDは自動生成のためインサート関数にはIDがない。
      // なので、ID付きのモックデータが必要。
      await mockSupabase.from(TableName.songs).insert({
        ColumnName.id: 1,
        ColumnName.title: 'test song',
        ColumnName.lyrics: 'test lyrics',
      });
      try {
        await SupabaseServices.update.updateSong(
          id: 1,
          title: 'error title',
          lyric: 'error lyrics',
          context: mockContext,
          supabase: errorSupabase,
          groupId: 1,
          imageUrl: 'https://example.com/updated.jpg',
          releaseDate: '2024-01-22',
          lyricistId: 13,
          composerId: 13,
          comment: 'updated comment',
        );

        expect(find.byType(SnackBar), findsOneWidget);
        expect(
          find.text('曲データの更新中にエラーが発生しました。曲名: error title'),
          findsOneWidget,
        );
      } catch (e) {
        didThrowError = true;
      }

      expect(didThrowError, isTrue);
    });
  });
  group('updateUser', () {
    testWidgets('updateUserの正常動作', (WidgetTester tester) async {
      final mockContext = await createMockContext(tester);

      await mockSupabase.from(TableName.profiles).insert({
        ColumnName.id: 1,
        ColumnName.name: 'test user',
        ColumnName.lyrics: 'test lyrics',
      });

      await SupabaseServices.update.updateUser(
        id: '1',
        name: 'updated user',
        email: 'updated@example.com',
        imageUrl: 'https://example.com/updated.jpg',
        comment: 'updated comment',
        context: mockContext,
        supabase: mockSupabase,
      );

      final updateduser = await mockSupabase
          .from(TableName.profiles)
          .select()
          .eq(ColumnName.id, '1')
          .single();

      expect(
        updateduser[ColumnName.name],
        'updated user',
      );
      expect(
        updateduser[ColumnName.email],
        'updated@example.com',
      );
      expect(
        updateduser[ColumnName.imageUrl],
        'https://example.com/updated.jpg',
      );
      expect(
        updateduser[ColumnName.comment],
        'updated comment',
      );
    });
    testWidgets('updateUserの例外処理', (WidgetTester tester) async {
      final mockContext = await createMockContext(tester);
      var didThrowError = false;

      // アップデート用のデータを登録。
      // SupabaseのIDは自動生成のためインサート関数にはIDがない。
      // なので、ID付きのモックデータが必要。
      await mockSupabase.from(TableName.profiles).insert({
        ColumnName.id: '1',
        ColumnName.name: 'test user',
      });
      try {
        await SupabaseServices.update.updateUser(
          id: '1',
          name: 'error user',
          email: 'error@example.com',
          imageUrl: 'https://example.com/updated.jpg',
          comment: 'updated comment',
          context: mockContext,
          supabase: errorSupabase,
        );

        expect(find.byType(SnackBar), findsOneWidget);
        expect(
          find.text('ユーザーの更新中にエラーが発生しました。ユーザー名: error user'),
          findsOneWidget,
        );
      } catch (e) {
        didThrowError = true;
      }

      expect(didThrowError, isTrue);
    });
  });
}
