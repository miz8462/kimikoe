import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

void showLogAndSnackBar({
  required BuildContext context,
  required Logger logger,
  required String message,
  bool isError = false,
}) {
  if (isError) {
    logger.e(message);
  } else {
    logger.i(message);
  }
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(message)),
  );
}
