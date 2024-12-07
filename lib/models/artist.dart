class Artist {
  const Artist({
    required this.name,
    required this.imageUrl,
    this.id,
    this.comment,
  });

  final String name;
  final int? id;
  final String imageUrl;
  final String? comment;
}
