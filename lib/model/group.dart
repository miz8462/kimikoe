import 'dart:io';

class Group {
  Group({
    required this.name,
    this.image,
    this.year = 0,
    this.remarks = '',
  });

  String name;
  File? image;
  int? year;
  String? remarks;
}
