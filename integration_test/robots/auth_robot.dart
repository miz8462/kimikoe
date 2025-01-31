import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kimikoe_app/main.dart' as app;
import 'package:kimikoe_app/models/table_and_column_name.dart';
import 'package:kimikoe_app/providers/logger_provider.dart';
import 'package:kimikoe_app/providers/supabase_provider.dart';
import 'package:kimikoe_app/screens/idol_group_list.dart';
import 'package:kimikoe_app/screens/sign_in.dart';
import 'package:kimikoe_app/services/supabase_services/supabase_delete.dart';
import 'package:robot/robot.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../integration_test_utils/wait_for_condition.dart';

class AuthRobot extends Robot<SignInScreen> {
  AuthRobot(super.tester);

  late String email;
  late String password;
  late String name;

  static const String testEmail = 'doskoi@doskoi.com';
  static const String testPassword = 'doskoidoskoi';

  Future<void> launchApp() async {
    await app.main();

    if (supabase.auth.currentSession != null) {
      await supabase.auth.signOut();
    }

    await waitForScreen(SignInScreen);
  }

  Future<void> enterEmail(String email) async {
    await tester.enterText(find.byKey(Key('emailField')), email);
    await tester.pumpAndSettle();
  }

  Future<void> enterPassword(String password) async {
    await tester.enterText(find.byKey(Key('passwordField')), password);
    await tester.pumpAndSettle();
  }

  Future<void> enterName(String name) async {
    await tester.enterText(find.byKey(Key('nameField')), name);
    await tester.pumpAndSettle();
  }

  Future<void> tapToggleAuthButton() async {
    await tester.tap(find.byKey(Key('switchButton')));
    await tester.pumpAndSettle();
  }

  Future<void> tapLoginButton() async {
    final loginButtonFinder = find.byKey(Key('loginButton'));
    expect(loginButtonFinder, findsOneWidget);

    // スクロール可能なウィジェットを探す
    final scrollable = find.byType(Scrollable).first;

    // ボタンが見えるようにスクロール
    await tester.scrollUntilVisible(
      loginButtonFinder,
      500,
      scrollable: scrollable,
    );
    await tester.pumpAndSettle();

    // ensureVisibleを使用してボタンが確実に表示されるようにする
    await tester.ensureVisible(loginButtonFinder);
    await tester.pumpAndSettle();

    // タップを実行
    await tester.tap(loginButtonFinder, warnIfMissed: false);
    await tester.pumpAndSettle();
  }

  Future<void> tapLogoutButton() async {
    await tester.tap(find.byKey(Key('logoutButton')));
    await tester.pumpAndSettle();
  }

  Future<void> waitForScreen(Type screenType) async {
    await waitForCondition(tester, find.byType(screenType));
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
      await deleteDataById(
        table: TableName.profiles,
        id: supabase.auth.currentUser!.id,
        context: context,
        supabase: supabase,
      );
    } catch (e) {
      logger.e('テストユーザープロフィール削除中にエラーが発生しました: $e');
    }
  }

  Future<void> deleteUserAdmin() async {
    await dotenv.load();
    final supabaseAdmin = SupabaseClient(
      dotenv.env['SUPABASE_URL']!,
      dotenv.env['SERVICE_ROLE_KEY']!,
    );
    try {
      await supabaseAdmin.auth.admin.deleteUser(supabase.auth.currentUser!.id);
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

  Future<void> expectHomeScreen() async {
    await waitForScreen(IdolGroupListScreen);
    expect(find.byType(IdolGroupListScreen), findsOneWidget);
  }

  Future<void> expectSignInScreen() async {
    await waitForScreen(SignInScreen);
    expect(find.byType(SignInScreen), findsOneWidget);
  }
}
