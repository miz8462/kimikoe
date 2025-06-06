import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kimikoe_app/main.dart' as app;
import 'package:kimikoe_app/models/environment_keys.dart';
import 'package:kimikoe_app/models/table_and_column_name.dart';
import 'package:kimikoe_app/models/widget_keys.dart';
import 'package:kimikoe_app/providers/logger_provider.dart';
import 'package:kimikoe_app/providers/supabase/supabase_provider.dart';
import 'package:kimikoe_app/providers/supabase/supabase_services_provider.dart';
import 'package:kimikoe_app/screens/idol_group_list.dart';
import 'package:kimikoe_app/screens/sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'custom_robot.dart';

class AuthRobot extends CustomRobot<SignInScreen> {
  AuthRobot(super.tester, this.container);

  final ProviderContainer container;

  late String email;
  late String password;
  late String name;

  static const String testEmail = 'doskoi@doskoi.com';
  static const String testPassword = 'doskoidoskoi';

  Future<void> launchApp() async {
    await app.main();

    final client = container.read(supabaseProvider);
    if (client.auth.currentSession != null) {
      await client.auth.signOut();
    }

    await waitForWidget(SignInScreen);
  }

  Future<void> enterEmail(String email) async {
    await enterTextByKey(keyValue: WidgetKeys.email, enterValue: email);
  }

  Future<void> enterPassword(String password) async {
    await enterTextByKey(keyValue: WidgetKeys.password, enterValue: password);
  }

  Future<void> enterName(String name) async {
    await enterTextByKey(keyValue: WidgetKeys.name, enterValue: name);
  }

  Future<void> tapToggleAuthButton() async {
    await tapWidget(WidgetKeys.switchButton);
  }

  Future<void> tapLoginButton() async {
    await ensureVisibleWidget(WidgetKeys.loginButton);
    await tester.pumpAndSettle();
    await tapWidget(WidgetKeys.loginButton);
  }

  Future<void> login() async {
    await enterEmail(testEmail);
    await enterPassword(testPassword);
    await tester.pumpAndSettle();

    await tapLoginButton();
    await tester.pumpAndSettle();
  }

  Future<void> signUp(String email, String password, String name) async {
    await tapToggleAuthButton();

    await enterEmail(email);
    await enterPassword(password);
    await enterName(name);
    await tapLoginButton();
  }

  Future<void> initializeAndLogin() async {
    await launchApp();

    await login();
  }

  Future<void> deleteUser() async {
    final context = tester.element(find.byType(IdolGroupListScreen));
    try {
      final client = container.read(supabaseProvider);
      final service = container.read(supabaseServicesProvider);
      await service.delete.deleteDataById(
        table: TableName.profiles,
        id: client.auth.currentUser!.id,
        context: context,
      );
    } catch (e) {
      logger.e('テストユーザープロフィール削除中にエラーが発生しました: $e');
    }
  }

  Future<void> deleteUserAdmin() async {
    await dotenv.load();
    final supabaseAdmin = SupabaseClient(
      dotenv.env[EnvironmentKeys.supabaseUrl]!,
      dotenv.env[EnvironmentKeys.serviceRoleKey]!,
    );
    try {
      final client = container.read(supabaseProvider);
      await supabaseAdmin.auth.admin.deleteUser(client.auth.currentUser!.id);
      logger.i('テストユーザーを削除しました');
    } catch (e) {
      logger.e('テストユーザー削除中にエラーが発生しました: $e');
    }
  }

  void expectEmailErrorMessage() {
    expect(find.text('正しいメールアドレスを入力してください'), findsOneWidget);
  }

  void expectPasswordErrorMessage() {
    expect(find.text('正しいパスワードを入力してください'), findsOneWidget);
  }

  void expectPasswordLengthErrorMessage() {
    expect(find.text('パスワードは8文字以上入力してください'), findsOneWidget);
  }

  void expectNameErrorMessage() {
    expect(find.text('名前は2文字以上入力してください'), findsOneWidget);
  }
}
