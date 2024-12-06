import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:kimikoe_app/config/config.dart';
import 'package:kimikoe_app/kimikoe_app.dart';
import 'package:kimikoe_app/models/idol_group.dart';
import 'package:kimikoe_app/models/table_and_column_name.dart';
import 'package:kimikoe_app/router/routing_path.dart';
import 'package:kimikoe_app/screens/appbar/top_bar.dart';
import 'package:kimikoe_app/screens/group_detail/widget/group_info.dart';
import 'package:kimikoe_app/screens/group_detail/widget/group_members.dart';
import 'package:kimikoe_app/utils/supabase_service.dart';
import 'package:kimikoe_app/widgets/delete_alert_dialog.dart';

class GroupDetailScreen extends StatefulWidget {
  const GroupDetailScreen({
    required this.group, super.key,
  });

  final IdolGroup group;

  @override
  State<GroupDetailScreen> createState() => _GroupDetailScreenState();
}

class _GroupDetailScreenState extends State<GroupDetailScreen> {
  final _isEditing = true;
  final _isGroup = true;

  void _deleteGroup() {
    showDialog<Widget>(
      context: context,
      builder: (context) {
        return DeleteAlertDialog(
          onDelete: () async {
            await deleteDataFromTable(
              table: TableName.idolGroups,
              column: ColumnName.id,
              value: widget.group.id.toString(),
              context: context,
            );
          },
          successMessage: '${widget.group.name}のデータが削除されました',
          errorMessage: '${widget.group.name}のデータの削除に失敗しました',
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final group = widget.group;
    final data = {
      'group': group,
      'isEditing': _isEditing,
    };

    return Scaffold(
      appBar: TopBar(
        pageTitle: group.name,
        isEditing: _isEditing,
        isGroup: _isGroup,
        editRoute: RoutingPath.addGroup,
        delete: _deleteGroup,
        data: data,
      ),
      body: Padding(
        padding: screenPadding,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Gap(spaceS),
              GroupInfo(
                group: group,
              ),
              Divider(
                color: mainColor.withOpacity(0.3),
                thickness: 2,
              ),
              GroupMembers(group: group),
            ],
          ),
        ),
      ),
    );
  }
}
