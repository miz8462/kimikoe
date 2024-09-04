class User {
  const User({
    required this.name,
    this.email,
    this.imageUrl='d',
    this.comment,
  });

  final String name;
  final String? email;
  final String imageUrl;
  final String? comment;
}
