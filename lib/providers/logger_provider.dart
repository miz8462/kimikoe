import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

final loggerProvider = Provider<Logger>((ref) {
  return logger;
});

final logger = Logger(
  printer: PrettyPrinter(
    lineLength: 70,
    methodCount: 0,
    errorMethodCount: 10,
  ),
);
