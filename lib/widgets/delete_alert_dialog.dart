import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kimikoe_app/models/widget_keys.dart';
import 'package:kimikoe_app/providers/logger_provider.dart';
import 'package:kimikoe_app/router/routing_path.dart';

class DeleteAlertDialog extends StatelessWidget {
  const DeleteAlertDialog({
    required this.onDelete,
    required this.successMessage,
    required this.errorMessage,
    super.key,
  });
  final Future<void> Function() onDelete;
  final String successMessage;
  final String errorMessage;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('本当に削除しますか？'),
      content: const Text('削除したデータは復元できません。\nそれでも削除しますか？'),
      actions: [
        TextButton(
          key: Key(WidgetKeys.deleteYes),
          onPressed: () async {
            try {
              await onDelete();
              if (!context.mounted) return;
              context.pop();
              context.pushReplacement(RoutingPath.groupList);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(successMessage)),
              );
              logger.i(successMessage);
            } catch (e) {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(errorMessage)),
              );
              logger.e(errorMessage, error: e);
            }
          },
          child: Text(
            'はい',
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text(
            'いいえ',
          ),
        ),
      ],
    );
  }
}
