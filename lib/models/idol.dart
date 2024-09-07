import 'dart:core';

import 'package:flutter/material.dart';
import 'package:kimikoe_app/models/artist.dart';
import 'package:kimikoe_app/models/idol_group.dart';

class Idol extends Artist {
  const Idol({
    required super.name,
    super.imageUrl,
    super.comment,
    this.color,
    this.groupName,
    this.birthDay,
    this.height,
    this.hometown,
    this.debutYear,
    this.officialUrl,
    this.twitterUrl,
    this.instagramUrl,
  });

  final Color? color;
  final IdolGroup? groupName;
  final DateTime? birthDay;
  final double? height;
  final String? hometown;
  final DateTime? debutYear;
  final String? officialUrl;
  final String? twitterUrl;
  final String? instagramUrl;
}