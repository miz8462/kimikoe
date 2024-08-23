import 'package:kimikoe_app/model/artist.dart';
import 'package:kimikoe_app/model/idol_group.dart';

class Song {
  const Song({
    required this.title,
    required this.groupName,
    required this.lyrics,
    this.imageUrl,
    this.lyricist,
    this.composer,
    this.releaseDate,
  });

  final String title;
  final IdolGroup groupName;
  final String lyrics;
  final String? imageUrl;
  final Artist? lyricist;
  final Artist? composer;
  final DateTime? releaseDate;
}
