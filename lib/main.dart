import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kimikoe_app/kimikoe_app.dart';
import 'package:kimikoe_app/providers/logger_provider.dart';
import 'package:kimikoe_app/providers/supabase_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// `dart.vm.product` フラグは、Dartの仮想マシンがプロダクションモードで実行されているかを示す。
// プロダクションモード (リリースモード) では true、デバッグモードでは false。
bool isDebugMode = const bool.fromEnvironment('dart.vm.product') == false;
final providerContainer = ProviderContainer();
final sessionProvider = StateProvider<Session?>((ref) => null);

Future<void> main() async {
  // Flutterの初期化
  WidgetsFlutterBinding.ensureInitialized();
  initializeLogger();
  await dotenv.load();

  // Supabaseの初期化
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );
  supabase.auth.onAuthStateChange.listen(
    (data) {
      providerContainer.read(sessionProvider.notifier).state = data.session;
    },
  );

  // スマホを横にしても画面が回転しない
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // アプリの実行
  runApp(
    ProviderScope(
      overrides: [loggerProvider.overrideWith((ref) => logger)],
      child: const KimikoeApp(),
    ),
  );

  providerContainer.dispose();
}

extension ContextExtension on BuildContext {
  void showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError
            ? Theme.of(this).colorScheme.error
            : Theme.of(this).snackBarTheme.backgroundColor,
      ),
    );
  }
}
