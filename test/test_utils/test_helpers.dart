import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kimikoe_app/providers/logger_provider.dart';
import 'package:kimikoe_app/providers/supabase_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'mocks/logger_mock.dart';

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
  required MockLogger logger,
}) {
  final container = ProviderContainer(
    overrides: [
      loggerProvider.overrideWithValue(logger),
      supabaseProvider.overrideWithValue(supabaseClient),
    ],
  );

  addTearDown(container.dispose);

  return container;
}
