import 'dart:core';

import 'package:flutter/material.dart';
import 'package:kimikoe_app/models/artist.dart';
import 'package:kimikoe_app/models/idol_group.dart';
import 'package:kimikoe_app/models/table_and_column_name.dart';

class Idol extends Artist {
  const Idol({
    required super.name,
    required super.imageUrl,
    super.id,
    super.comment,
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
    this.otherUrl,
  });

  factory Idol.fromMap(Map<String, dynamic> map, {IdolGroup? group}) {
    return Idol(
      id: map[ColumnName.id],
      name: map[ColumnName.name]?.toString() ?? '',
      imageUrl: map[ColumnName.imageUrl],
      comment: map[ColumnName.comment],
      group: group,
      color: Color(int.parse(map[ColumnName.color])),
      birthDay: map[ColumnName.birthday]?.toString(),
      birthYear: map[ColumnName.birthYear] as int?,
      height: map[ColumnName.height] as int?,
      hometown: map[ColumnName.hometown]?.toString(),
      debutYear: map[ColumnName.debutYear] as int?,
      officialUrl: map[ColumnName.officialUrl]?.toString(),
      twitterUrl: map[ColumnName.twitterUrl]?.toString(),
      instagramUrl: map[ColumnName.instagramUrl]?.toString(),
      otherUrl: map[ColumnName.otherUrl]?.toString(),
    );
  }

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
  final String? otherUrl;
}
