import 'package:kimikoe_app/config/config.dart';

class Artist {
  const Artist({
    required this.name,
    this.imageUrl = noImage,
    this.id,
    this.comment,
  });

  final String name;
  final int? id;
  final String imageUrl;
  final String? comment;
}
