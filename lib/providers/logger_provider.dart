import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

final loggerProvider = Provider<Logger>((ref) {
  return logger;
});

late Logger logger;

void initializeLogger() {
  logger = Logger(
    printer: PrettyPrinter(
      lineLength: 40,
      methodCount: 0,
      errorMethodCount: 10,
    ),
  );
}
