import 'dart:core';

import 'package:flutter/material.dart';
import 'package:kimikoe_app/models/artist.dart';
import 'package:kimikoe_app/models/idol_group.dart';

class Idol extends Artist {
  const Idol({
    required super.name,
    super.imageUrl,
    super.comment,
    this.id,
    this.color,
    this.group,
    this.birthYear,
    this.birthDay,
    this.height,
    this.hometown,
    this.debutYear,
    this.officialUrl,
    this.twitterUrl,
    this.instagramUrl,
  });

  final int? id;
  final Color? color;
  final IdolGroup? group;
  final int? birthYear;
  final String? birthDay;
  final int? height;
  final String? hometown;
  final int? debutYear;
  final String? officialUrl;
  final String? twitterUrl;
  final String? instagramUrl;
}
