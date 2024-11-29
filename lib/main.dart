import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kimikoe_app/kimikoe_app.dart';
import 'package:logger/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

bool isDebugMode = const bool.fromEnvironment('dart.vm.product') == false;

final sessionProvider = StateProvider<Session?>((ref) => null);
final providerContainer = ProviderContainer();
final logger = Logger(
  printer: PrettyPrinter(
    lineLength: 100,
    methodCount: 0,
    errorMethodCount: 10,
  ),
);

Future<void> main() async {
  // Flutterの初期化
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');

  // Supabaseの初期化
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );
  Supabase.instance.client.auth.onAuthStateChange.listen(
    (data) {
      providerContainer.read(sessionProvider.notifier).state = data.session;
    },
  );

  // スマホを横にしても画面が回転しない
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((fn) {
    runApp(const ProviderScope(child: KimikoeApp()));
  });
}

final supabase = Supabase.instance.client;

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
