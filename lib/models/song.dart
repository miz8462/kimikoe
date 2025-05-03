import 'package:kimikoe_app/models/artist.dart';
import 'package:kimikoe_app/models/idol_group.dart';
import 'package:kimikoe_app/models/table_and_column_name.dart';

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

  factory Song.fromMap(
    Map<String, dynamic> map, {
    IdolGroup? group,
    Artist? composer,
    Artist? lyricist,
  }) {
    return Song(
      title: map[ColumnName.title],
      lyrics: map[ColumnName.lyrics],
      imageUrl: map[ColumnName.imageUrl],
      id: map[ColumnName.id],
      group: group,
      movieUrl: map[ColumnName.movieUrl],
      composer: composer,
      lyricist: lyricist,
      releaseDate: map[ColumnName.releaseDate],
      comment: map[ColumnName.comment],
    );
  }

  final String title;
  final String lyrics;
  final int? id;
  final IdolGroup? group;
  final String imageUrl;
  final String? movieUrl;
  final Artist? composer;
  final Artist? lyricist;
  final String? releaseDate;
  final String? comment;
}
