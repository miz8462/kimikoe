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

    // まず通常のタップを試みる
    try {
      await tester.tap(loginButtonFinder);
      await tester.pumpAndSettle();
      return;
    } catch (error) {
      // 通常のタップが失敗した場合（ボタンが画面外にある場合）は
      // スクロールしてからタップを試みる
      try {
        await tester.scrollUntilVisible(
          loginButtonFinder,
          200,
          scrollable: find
              .ancestor(
                of: loginButtonFinder,
                matching: find.byType(Scrollable),
              )
              .first,
        );
        await tester.pumpAndSettle();

        // ボタンの中心点をタップ
        final renderObject = tester.renderObject(loginButtonFinder);
        if (renderObject is RenderBox) {
          final tapPosition =
              renderObject.localToGlobal(renderObject.size.center(Offset.zero));
          await tester.tapAt(tapPosition);
          await tester.pumpAndSettle();
        } else {
          throw StateError('RenderObject is not a RenderBox');
        }
      } catch (scrollError) {
        print('スクロールまたはタップ中にエラーが発生しました: $scrollError');
        rethrow;
      }
    }
  }

  Future<void> tapLogoutButton() async {
    await tester.tap(find.byKey(Key('logoutButton')));
    await tester.pumpAndSettle();
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
