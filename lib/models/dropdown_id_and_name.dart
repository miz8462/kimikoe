import 'package:flutter/foundation.dart';

class DropdownIdAndName {
  const DropdownIdAndName({
    required this.id,
    required this.name,
    this.key,
  });
  final int id;
  final String name;
  final Key? key;
}
