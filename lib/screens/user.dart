import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:kimikoe_app/config/config.dart';
import 'package:kimikoe_app/providers/user_provider.dart';
import 'package:kimikoe_app/router/routing_path.dart';
import 'package:kimikoe_app/screens/appbar/top_bar.dart';
import 'package:kimikoe_app/utils/crud_data.dart';

class UserScreen extends ConsumerWidget {
  const UserScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const isEditing = true;

    final user = ref.watch(userProfileProvider);
    final imageUrl = fetchPublicImageUrl(user!.imageUrl);
    var userImage = NetworkImage(imageUrl);

    final data = {
      'user': user,
      'isEditing': isEditing,
    };

    return Scaffold(
      appBar: TopBar(
        title: 'ユーザー情報',
        isEditing: isEditing,
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
