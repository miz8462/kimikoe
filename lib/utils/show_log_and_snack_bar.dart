import 'package:flutter/material.dart';
import 'package:kimikoe_app/providers/logger_provider.dart';

void showLogAndSnackBar({
  required BuildContext context,
  required String message,
  bool isError = false,
}) {
  if (isError) {
    logger.e(message);
  } else {
    logger.i(message);
  }

  if (context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
