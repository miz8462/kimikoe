// グループリストページを開く際、ネットに繋がっていない場合
// エラーメッセージを表示する。connectivity_plus

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final connectivityProvider =
    StateNotifierProvider<ConnectivityNotifier, ConnectivityResult>(
  (ref) => ConnectivityNotifier(),
);

class ConnectivityNotifier extends StateNotifier<ConnectivityResult> {
  ConnectivityNotifier() : super(ConnectivityResult.none) {
    _init();
  }

  void _init() {
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      state = result;
    });
  }
}
