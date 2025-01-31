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

  Future<void> show() async {
    await tester.pumpWidget(
      MaterialApp(
        home: ScaffoldMessenger(
          child: Scaffold(body: SignInScreen()),
        ),
      ),
    );
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

  Future<void> tapLoginOrSignUpButton() async {
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

  Future<void> login() async {
    await enterEmail(testEmail);
    await enterPassword(testPassword);
    await tester.pumpAndSettle();
    
    await tapLoginOrSignUpButton();
    await tester.pumpAndSettle();
  }

  Future<void> initializeAndLogin() async {
    await app.main();
    await tester.pumpAndSettle();

    if (supabase.auth.currentSession != null) {
      await supabase.auth.signOut();
    }

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

  Future<void> expectEmailErrorMessage() async {
    expect(find.text('正しいメールアドレスを入力してください'), findsOneWidget);
  }

  Future<void> expectPasswordErrorMessage() async {
    expect(find.text('正しいパスワードを入力してください'), findsOneWidget);
  }

  Future<void> expectPasswordLengthErrorMessage() async {
    expect(find.text('パスワードは8文字以上入力してください'), findsOneWidget);
  }

  Future<void> expectNameErrorMessage() async {
    expect(find.text('名前は2文字以上入力してください'), findsOneWidget);
  }

  Future<void> expectHomeScreen() async {
    await waitForCondition(tester, find.byType(IdolGroupListScreen));
    expect(find.byType(IdolGroupListScreen), findsOneWidget);
  }

  Future<void> expectSignInScreen() async {
    await waitForCondition(tester, find.byType(SignInScreen));
    expect(find.byType(SignInScreen), findsOneWidget);
  }
}
