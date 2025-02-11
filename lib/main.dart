import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kimikoe_app/kimikoe_app.dart';
import 'package:kimikoe_app/models/environment_keys.dart';
import 'package:kimikoe_app/providers/logger_provider.dart';
import 'package:kimikoe_app/providers/supabase_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final providerContainer = ProviderContainer();
final sessionProvider = StateProvider<Session?>((ref) => null);

Future<void> main() async {
  // Flutterの初期化
  WidgetsFlutterBinding.ensureInitialized();
  initializeLogger();
  await dotenv.load();

  // Supabaseの初期化
  try {
    await Supabase.initialize(
      url: dotenv.env[EnvironmentKeys.supabaseUrl]!,
      anonKey: dotenv.env[EnvironmentKeys.supabaseAnonKey]!,
    );
    initializeSupabaseClient();
  } catch (e) {
    // すでに初期化されている場合は無視
    if (e.toString().contains('already initialized')) {
      logger.i('Supabaseは既に初期化されています');
    } else {
      // その他のエラーは再スロー
      rethrow;
    }
  }

  final supabase = providerContainer.read(supabaseProvider);
  supabase.auth.onAuthStateChange.listen(
    (data) {
      providerContainer.read(sessionProvider.notifier).state = data.session;
    },
  );

  // スマホを横にしても画面が回転しない
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(
    ProviderScope(
      overrides: [loggerProvider.overrideWith((ref) => logger)],
      child: const KimikoeApp(),
    ),
  );
}
