import 'package:kimikoe_app/models/idol.dart';
import 'package:kimikoe_app/models/song.dart';

class IdolGroup {
  const IdolGroup({
    required this.name,
    this.members,
    this.songs,
    this.imageUrl,
    this.year,
    this.comment,
    this.officialUrl,
    this.twitterUrl,
    this.instagramUrl,
  });

  final String name;
  final List<Idol>? members;
  final List<Song>? songs;
  final String? imageUrl;
  final int? year;
  final String? comment;
  final String? officialUrl;
  final String? twitterUrl;
  final String? instagramUrl;
}
