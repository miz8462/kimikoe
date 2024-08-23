import 'dart:core';

import 'package:flutter/material.dart';
import 'package:kimikoe_app/model/artist.dart';
import 'package:kimikoe_app/model/idol_group.dart';

class Idol extends Artist {
  const Idol({
    required super.name,
    super.imageUrl,
    super.comment,
    required this.groupName,
    required this.imageColor,
    this.birthDay,
    this.height,
    this.hometown,
    this.debutYear,
  });

  final IdolGroup groupName;
  final Color imageColor;
  final DateTime? birthDay;
  final double? height;
  final String? hometown;
  final DateTime? debutYear;
}
