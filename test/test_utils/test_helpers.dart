import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kimikoe_app/providers/supabase_provider.dart';
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
