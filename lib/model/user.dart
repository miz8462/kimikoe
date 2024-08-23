import 'package:kimikoe_app/model/idol_group.dart';
import 'package:kimikoe_app/model/song.dart';

class User {
  const User({
    required this.name,
    this.favoriteGroups,
    this.favoriteSongs,
    this.imageUrl,
    this.email,
    this.comment,
  });

  final String name;
  final List<IdolGroup>? favoriteGroups;
  final List<Song>? favoriteSongs;
  final String? imageUrl;
  final String? email;
  final String? comment;
}
