import 'package:flutter/material.dart';
import 'package:kimikoe_app/providers/logger_provider.dart';

Widget handleMemberFetchError(Object? error) {
  logger.e('メンバーの取得に失敗しました', error: error);
  return const Center(
    child: Text('メンバー情報の取得に失敗しました。後でもう一度お試しください。'),
  );
}
