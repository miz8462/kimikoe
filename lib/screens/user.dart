import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:kimikoe_app/config/config.dart';
import 'package:kimikoe_app/main.dart';
import 'package:kimikoe_app/models/enums/tables.dart';
import 'package:kimikoe_app/models/user.dart';
import 'package:kimikoe_app/provider/current_user.dart';
import 'package:kimikoe_app/router/routing_path.dart';
import 'package:kimikoe_app/screens/appbar/top_bar.dart';
import 'package:kimikoe_app/screens/widgets/buttons/styled_button.dart';

class UserScreen extends ConsumerStatefulWidget {
  const UserScreen({super.key});

  @override
  ConsumerState<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends ConsumerState<UserScreen> {
  late AsyncValue<List<Map<String, dynamic>>> _currentUserInfo;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // ref.watchはbuildメソッドやdidChangeDependenciesメソッド内で使用する必要がある
    _currentUserInfo = ref.watch(userDataProvider);
  }

  String _getImageFromSupabase(String imageUrl) {
    return supabase.storage.from(TableName.images.name).getPublicUrl(imageUrl);
  }

  @override
  Widget build(context) {
    const String editButtonText = '編集する';
    const double buttonWidth = 180;
    final currentUserInfo =
        _currentUserInfo.value?.map((data) => data).toList()[0];
    final user = UserProfile(
      name: currentUserInfo?[ColumnName.name.colname] ?? 'タイトル未定',
      email: currentUserInfo?[ColumnName.email.colname],
      imageUrl: currentUserInfo?[ColumnName.imageUrl.colname],
      comment: currentUserInfo?[ColumnName.comment.colname] ?? '',
    );

    var userImageUrl = user.imageUrl;
    final isStartWithHTTP = user.imageUrl.startsWith('http');

    if (!isStartWithHTTP) {
      userImageUrl = _getImageFromSupabase(user.imageUrl);
    }
    var userImage = NetworkImage(userImageUrl);

    return Scaffold(
      appBar: TopBar(
        title: 'ユーザー情報',
      ),
      body: Padding(
        padding: screenPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Gap(spaceWidthS),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircleAvatar(
                  backgroundImage: userImage,
                  radius: avaterSizeL,
                ),
                // todo: 他のページに遷移したら編集を終了する
                StyledButton(
                  editButtonText,
                  onPressed: () {
                    context.push(
                        '${RoutingPath.userDetails}/${RoutingPath.editUser}',
                        extra: user);
                  },
                  textColor: textGray,
                  backgroundColor: backgroundWhite,
                  buttonSize: buttonM,
                  borderSide: BorderSide(
                      color: backgroundLightBlue, width: borderWidth),
                  width: buttonWidth,
                ),
              ],
            ),
            Gap(spaceWidthS),
            Text(
              user.name,
              style: TextStyle(
                fontSize: fontLL,
              ),
            ),
            Gap(spaceWidthS),
            Text(user.comment),
          ],
        ),
      ),
    );
  }
}
