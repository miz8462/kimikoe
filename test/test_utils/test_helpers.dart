import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kimikoe_app/models/table_and_column_name.dart';
import 'package:kimikoe_app/providers/supabase_provider.dart';
import 'package:mock_supabase_http_client/mock_supabase_http_client.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// ProviderContainerを作成するユーティリティ（ボイラープレート）
ProviderContainer createContainer({
  ProviderContainer? parent,
  List<Override> overrides = const [],
  List<ProviderObserver>? observers,
}) {
  final container = ProviderContainer(
    parent: parent,
    overrides: overrides,
    observers: observers,
  );

  // テスト終了時にProviderContainerを破棄
  addTearDown(container.dispose);

  return container;
}

ProviderContainer supabaseContainer({
  required SupabaseClient supabaseClient,
}) {
  final container = createContainer(
    overrides: [
      supabaseProvider.overrideWithValue(supabaseClient),
    ],
  );

  addTearDown(container.dispose);

  return container;
}

Future<BuildContext> createMockContext(WidgetTester tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: Builder(
          builder: (BuildContext context) {
            return Container();
          },
        ),
      ),
    ),
  );
  return tester.element(find.byType(Container));
}

Future<List<Map<String, dynamic>>> mockFetchGroupMembers(
  int groupId, {
  required SupabaseClient supabase,
}) async {
  return [
    {
      ColumnName.id: 1,
      ColumnName.name: 'test idol',
      ColumnName.imageUrl: 'https://example.com/image.jpg',
    },
  ];
}

SupabaseClient createMockSupabaseClient() => SupabaseClient(
      'https://mock.supabase.co',
      'fakeAnonKey',
      httpClient: MockSupabaseHttpClient(),
    );
