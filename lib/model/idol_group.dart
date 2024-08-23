import 'package:kimikoe_app/model/idol.dart';
import 'package:kimikoe_app/model/song.dart';

class IdolGroup {
  const IdolGroup({
    required this.name,
    this.members,
    this.songs,
    this.imageUrl,
    this.year,
    this.comment,
  });

  final String name;
  final List<Idol>? members;
  final List<Song>? songs;
  final String? imageUrl;
  final int? year;
  final String? comment;
}
