import 'dart:core';

import 'package:flutter/material.dart';
import 'package:kimikoe_app/models/artist.dart';

class Idol extends Artist {
  const Idol({
    required super.name,
    super.imageUrl,
    super.comment,
    this.color,
    this.groupId,
    this.birthDay,
    this.height,
    this.hometown,
    this.debutYear,
    this.officialUrl,
    this.twitterUrl,
    this.instagramUrl,
  });

  final Color? color;
  final int? groupId;
  final String? birthDay;
  final int? height;
  final String? hometown;
  final int? debutYear;
  final String? officialUrl;
  final String? twitterUrl;
  final String? instagramUrl;
}
