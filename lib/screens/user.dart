import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:kimikoe_app/config/config.dart';
import 'package:kimikoe_app/models/enums/table_and_column_name.dart';
import 'package:kimikoe_app/models/user.dart';
import 'package:kimikoe_app/providers/current_user.dart';
import 'package:kimikoe_app/router/routing_path.dart';
import 'package:kimikoe_app/screens/appbar/top_bar.dart';
import 'package:kimikoe_app/utils/crud_data.dart';

class UserScreen extends ConsumerStatefulWidget {
  const UserScreen({super.key});

  @override
  ConsumerState<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends ConsumerState<UserScreen> {
  late AsyncValue<List<Map<String, dynamic>>> _currentUserInfo;
  final _isEditing = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // ref.watchはbuildメソッドやdidChangeDependenciesメソッド内で使用する必要がある
    _currentUserInfo = ref.watch(userDataProvider);
  }

  @override
  Widget build(context) {
    final currentUserInfo =
        _currentUserInfo.value?.map((data) => data).toList()[0];
    final user = UserProfile(
      id: currentUserInfo![ColumnName.id.name].toString(),
      name: currentUserInfo[ColumnName.cName.name],
      email: currentUserInfo[ColumnName.email.name],
      imageUrl: currentUserInfo[ColumnName.imageUrl.name],
      comment: currentUserInfo[ColumnName.comment.name] ?? '',
    );

    var userImageUrl = user.imageUrl;
    final isStartWithHTTP = user.imageUrl.startsWith('http');

    if (!isStartWithHTTP) {
      userImageUrl = fetchPublicImageUrl(user.imageUrl);
    }
    var userImage = NetworkImage(userImageUrl);

    final data = {
      'user': user,
      'isEditing': _isEditing,
    };

    return Scaffold(
      appBar: TopBar(
        title: 'ユーザー情報',
        isEditing: _isEditing,
        editRoute: RoutingPath.editUser,
        isUser: true,
        data: data,
      ),
      body: Padding(
        padding: screenPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Gap(spaceS),
            CircleAvatar(
              backgroundImage: userImage,
              radius: avaterSizeL,
            ),
            const Gap(spaceS),
            Text(
              user.name,
              style: const TextStyle(
                fontSize: fontLL,
              ),
            ),
            const Gap(spaceS),
            Text(user.comment),
          ],
        ),
      ),
    );
  }
}
