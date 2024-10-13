import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kimikoe_app/router/routing_path.dart';

class DeleteAlertDialog extends StatelessWidget {
  const DeleteAlertDialog({
    super.key,
    required this.onDelete,
  });
  final void Function() onDelete;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('本当に削除しますか？'),
      content: const Text('削除したデータは復元できません。\nそれでも削除しますか？'),
      actions: [
        TextButton(
            onPressed: () {
              onDelete();
              Navigator.of(context).pop();
              context.goNamed(RoutingPath.groupList);
            },
            child: Text(
              'はい',
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            )),
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
