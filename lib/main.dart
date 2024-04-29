import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kimikoe_app/ui/auth/view/sign_in_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  // Flutterの初期化
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');

  // Supabaseの初期化
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );
  // Riverpodでラップ
  runApp(const ProviderScope(child: KimikoeApp()));
}
// Supabaseクライアントを取得
final supabase = Supabase.instance.client;

class KimikoeApp extends StatelessWidget {
  const KimikoeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'キミコエ',
      home: SignInPage(),
    );
  }
}