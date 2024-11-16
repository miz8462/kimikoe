import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:kimikoe_app/config/config.dart';
import 'package:kimikoe_app/kimikoe_app.dart';
import 'package:kimikoe_app/models/enums/table_and_column_name.dart';
import 'package:kimikoe_app/models/idol_group.dart';
import 'package:kimikoe_app/router/routing_path.dart';
import 'package:kimikoe_app/screens/appbar/top_bar.dart';
import 'package:kimikoe_app/screens/group_detail/widget/group_info.dart';
import 'package:kimikoe_app/screens/group_detail/widget/group_members.dart';
import 'package:kimikoe_app/utils/crud_data.dart';
import 'package:kimikoe_app/widgets/delete_alert_dialog.dart';

class GroupDetailScreen extends StatefulWidget {
  const GroupDetailScreen({
    super.key,
    required this.group,
  });

  final IdolGroup group;

  @override
  State<GroupDetailScreen> createState() => _GroupDetailScreenState();
}

class _GroupDetailScreenState extends State<GroupDetailScreen> {
  final _isEditing = true;
  final _isGroup = true;

  void _deleteGroup() {
    showDialog(
      context: context,
      builder: (context) {
        return DeleteAlertDialog(
          onDelete: () {
            deleteDataFromTable(
              table: TableName.idolGroups.name,
              column: ColumnName.id.name,
              value: (widget.group.id).toString(),
            );
          },
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
