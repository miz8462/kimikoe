import 'package:kimikoe_app/config/config.dart';

class UserProfile {
  const UserProfile({
    required this.id,
    required this.name,
    required this.email,
    this.imageUrl = defaultPathNoImage,
    this.comment = '',
  });

  final String id;
  final String name;
  final String email;
  final String imageUrl;
  final String comment;
}
