import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
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
    final emailFieldFinder = find.byKey(Key('emailField'));
    await tester.enterText(emailFieldFinder, email);
    await tester.pumpAndSettle();
  }

  Future<void> enterPassword(String password) async {
    final passwordFieldFinder = find.byKey(Key('passwordField'));
    await tester.enterText(passwordFieldFinder, password);
    await tester.pumpAndSettle();
  }

  Future<void> enterName(String name) async {
    final nameFieldFinder = find.byKey(Key('nameField'));
    await tester.enterText(nameFieldFinder, name);
    await tester.pumpAndSettle();
  }

  Future<void> tapToggleAuthButton() async {
    final signUpTextFinder = find.byKey(Key('switchButton'));
    await tester.tap(signUpTextFinder);
    await tester.pumpAndSettle();
  }

  Future<void> tapLoginOrSignUpButton() async {
    final loginButtonFinder = find.byKey(Key('loginButton'));
    expect(loginButtonFinder, findsOneWidget);

    // スクロールしてウィジェットを表示
    try {
      await tester.scrollUntilVisible(
        loginButtonFinder,
        200,
        scrollable: find
            .ancestor(of: loginButtonFinder, matching: find.byType(Scrollable))
            .first, // 特定のScrollableを指定
      );
      await tester.pumpAndSettle(); // スクロール後に画面を更新
    } catch (error) {
      print('スクロール中にエラーが発生しました: $error');
    }
    // ボタンの中心点をタップ
    final renderObject = tester.renderObject(loginButtonFinder);
    Offset tapPosition;
    if (renderObject is RenderBox) {
      tapPosition =
          renderObject.localToGlobal(renderObject.size.center(Offset.zero));
    } else {
      throw StateError('RenderObject is not a RenderBox');
    }

    await tester.tapAt(tapPosition);
    await waitForCondition(tester, find.byType(IdolGroupListScreen));
  }

  Future<void> tapGoogleLoginButton() async {
    final signUpTextFinder = find.byKey(Key('googleLoginButton'));
    await tester.tap(signUpTextFinder);
    await tester.pumpAndSettle();
  }

  Future<void> signOut() async {
    await supabase.auth.signOut();
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
      logger.d('テストユーザープロフィール削除完了');
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
      logger.d('テストユーザーアカウント削除完了');
    } catch (e) {
      logger.e('テストユーザー削除中にエラーが発生しました: $e');
    }
  }

  Future<void> expectHomeScreen() async {
    expect(find.byType(IdolGroupListScreen), findsOneWidget);
  }
}
