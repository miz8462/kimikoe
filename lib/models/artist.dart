class Artist {
  const Artist({
    required this.name,
    this.id,
    this.imageUrl,
    this.comment,
  });

  final String name;
  final int? id;
  final String? imageUrl;
  final String? comment;
}
