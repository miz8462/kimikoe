import 'package:kimikoe_app/models/artist.dart';
import 'package:kimikoe_app/models/idol_group.dart';

class Song {
  const Song({
    required this.title,
    this.groupId,
    required this.lyrics,
    this.imageUrl,
    this.lyricistId,
    this.composerId,
    this.releaseDate,
  });

  final String title;
  final int? groupId;
  final String lyrics;
  final String? imageUrl;
  final int? lyricistId;
  final int? composerId;
  final DateTime? releaseDate;
}
