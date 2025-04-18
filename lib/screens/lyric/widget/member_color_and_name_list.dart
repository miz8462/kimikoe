import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:kimikoe_app/config/config.dart';
import 'package:kimikoe_app/models/idol_group.dart';
import 'package:kimikoe_app/providers/group_members_provider.dart';
import 'package:kimikoe_app/router/routing_path.dart';
import 'package:kimikoe_app/utils/error_handling.dart';
import 'package:kimikoe_app/widgets/circle_color.dart';

class GroupColorAndNameList extends ConsumerWidget {
  const GroupColorAndNameList({
    required this.group,
    super.key,
  });
  final IdolGroup group;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final members = ref.watch(groupMembersProvider(group.id!));

    return members.when(
      data: (members) {
        return members.isEmpty
            ? const Center(child: Text('No members found'))
            : Wrap(
                key: Key(group.name),
                runSpacing: spaceS,
                children: members.map<Widget>((member) {
                  final color = member.color; // モデルに応じてアクセス
                  final name = member.name;
                  return GestureDetector(
                    key: Key(member.name),
                    onTap: () {
                      context.pushNamed(
                        RoutingPath.idolDetail,
                        extra: member,
                      );
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircleColor(color),
                        const Gap(spaceSS),
                        Text(name),
                        const Gap(spaceM),
                      ],
                    ),
                  );
                }).toList(),
              );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => handleMemberFetchError(error),
    );
  }
}
