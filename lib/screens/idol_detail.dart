import 'package:flutter/material.dart';
import 'package:kimikoe_app/models/enums/table_and_column_name.dart';
import 'package:kimikoe_app/models/idol.dart';
import 'package:kimikoe_app/router/routing_path.dart';
import 'package:kimikoe_app/screens/appbar/top_bar.dart';
import 'package:kimikoe_app/screens/widgets/delete_alert_dialog.dart';
import 'package:kimikoe_app/utils/crud_data.dart';

class IdolDetailScreen extends StatefulWidget {
  const IdolDetailScreen({
    super.key,
    required this.idol,
  });

  final Idol idol;

  @override
  State<IdolDetailScreen> createState() => _IdolDetailScreenState();
}

class _IdolDetailScreenState extends State<IdolDetailScreen> {
  void _deleteIdol() {
    showDialog(
      context: context,
      builder: (context) {
        return DeleteAlertDialog(
          onDelete: () {
            deleteDataFromTable(
              TableName.idol.name,
              ColumnName.id.name,
              (widget.idol.id).toString(),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final data = {
      'idol': widget.idol,
      'isEditing': true,
    };
    return Scaffold(
      appBar: TopBar(
        title: widget.idol.name,
        hasEditingMode: true,
        delete: _deleteIdol,
        editRoute: RoutingPath.addIdol,
        data: data,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(widget.idol.name),
          ],
        ),
      ),
    );
  }
}
