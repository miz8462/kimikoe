import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:kimikoe_app/config/config.dart';
import 'package:kimikoe_app/main.dart';
import 'package:kimikoe_app/models/user.dart';
import 'package:kimikoe_app/router/routing_path.dart';
import 'package:kimikoe_app/screens/appbar/top_bar.dart';
import 'package:kimikoe_app/utils/fetch_data.dart';
import 'package:kimikoe_app/widgets/buttons/styled_button.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  late Future _currentUserInfo;

  @override
  void initState() {
    super.initState();
    _currentUserInfo = fetchCurrentUserInfo();
  }

  String _getImageFromSupabase(String imageUrl) {
    return supabase.storage.from('images').getPublicUrl(imageUrl);
  }

  @override
  Widget build(context) {
    const String editButtonText = '編集する';
    const double buttonWidth = 180;

    return Scaffold(
      appBar: TopBar(
        title: 'ユーザー情報',
      ),
      body: FutureBuilder(
        future: _currentUserInfo,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }
          final userDataInList = List.of(snapshot.data);
          final userData = userDataInList[0];
          final user = UserProfile(
            name: userData['username'] ?? 'タイトル未定',
            email: userData['email'],
            imageUrl: userData['image_url'],
            comment: userData['comment'] ?? '',
          );

          var userImageUrl = user.imageUrl;
          final isStartWithHTTP = user.imageUrl.startsWith('http');

          if (!isStartWithHTTP) {
            userImageUrl = _getImageFromSupabase(user.imageUrl);
          }
          var userImage = NetworkImage(userImageUrl);

          return Padding(
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
                      radius: 30,
                    ),
                    // 編集
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
          );
        },
      ),
    );
  }
}
