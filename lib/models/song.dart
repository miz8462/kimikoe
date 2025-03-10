import 'package:kimikoe_app/models/artist.dart';
import 'package:kimikoe_app/models/idol_group.dart';

class Song {
  const Song({
    required this.title,
    required this.lyrics,
    required this.imageUrl,
    this.id,
    this.group,
    this.movieUrl,
    this.lyricist,
    this.composer,
    this.releaseDate,
    this.comment,
  });

  final String title;
  final String lyrics;
  final int? id;
  final IdolGroup? group;
  final String imageUrl;
  final String? movieUrl;
  final Artist? lyricist;
  final Artist? composer;
  final String? releaseDate;
  final String? comment;
}
