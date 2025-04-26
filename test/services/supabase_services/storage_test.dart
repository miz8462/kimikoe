// HACK: Supabase CLIでのローカル環境でテストができるらしいよ。よくわからなかった
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kimikoe_app/services/supabase_services/storage.dart';
import 'package:mock_supabase_http_client/mock_supabase_http_client.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../test_utils/test_helpers.dart';

void main() {
  late final SupabaseClient mockSupabase;
  late final MockSupabaseHttpClient mockHttpClient;
  late final Storage supabaseStorage;

  setUpAll(() async {
    mockHttpClient = MockSupabaseHttpClient();
    mockSupabase = SupabaseClient(
      'https://mock.supabase.co',
      'fakeAnonKey',
      httpClient: MockSupabaseHttpClient(),
    );

    supabaseStorage = Storage(mockSupabase);
  });

  tearDown(() async {
    mockHttpClient.reset();
  });

  // HACK: Supabase CLIでのローカル環境でテストができるらしいよ。よくわからなかった
  group('uploadImageToStorage', () {
    // TODO: 実装時テスト名要変更
    testWidgets('画像をストレージにアップロード', (WidgetTester tester) async {});
    testWidgets('uploadImageToStorageの例外処理', (WidgetTester tester) async {
      final mockContext = await createMockContext(tester);
      var didThrowError = false;
      try {
        await supabaseStorage.uploadImageToStorage(
          file: File('error'),
          path: 'error',
          context: mockContext,
        );
        expect(find.byType(SnackBar), findsOneWidget);
        expect(
          find.text('画像をストレージにアップロード中にエラーが発生しました'),
          findsOneWidget,
        );
      } catch (e) {
        didThrowError = true;
      }

      expect(didThrowError, isTrue);
    });
  });

  // HACK: Supabase CLI でできるらしいよ
  group('fetchImageUrl', () {
    testWidgets('fetchImageUrlの正常動作', (WidgetTester tester) async {});
    testWidgets('fetchImageUrlの例外処理', (WidgetTester tester) async {});
  });
}
