import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:kimikoe_app/config/config.dart';
import 'package:kimikoe_app/models/idol_group.dart';
import 'package:kimikoe_app/providers/group_members_provider.dart';
import 'package:kimikoe_app/router/routing_path.dart';
import 'package:kimikoe_app/widgets/circle_color.dart';

class GroupMembers extends ConsumerWidget {
  const GroupMembers({
    required this.group,
    super.key,
  });
  final IdolGroup group;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final members = ref.watch(groupMembersProvider(group.id!));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'メンバー',
          style: TextStyle(fontSize: fontM),
        ),
        const Gap(spaceS),
        members.when(
          data: (members) {
            return members.isEmpty
                ? const Center(
                    child: Text('登録データはありません'),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: members.length,
                    itemBuilder: (ctx, index) {
                      final member = members[index];
                      return Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              context.pushNamed(
                                RoutingPath.idolDetail,
                                extra: member,
                              );
                            },
                            child: Row(
                              children: [
                                CircleColor(member.color),
                                const Gap(spaceS),
                                Text(
                                  key: Key('members'),
                                  member.name,
                                  style: const TextStyle(fontSize: fontS),
                                ),
                              ],
                            ),
                          ),
                          const Gap(spaceSS),
                        ],
                      );
                    },
                  );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(child: Text('Error: $error')),
        ),
      ],
    );
  }
}
