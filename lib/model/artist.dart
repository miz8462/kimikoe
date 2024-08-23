class Artist {
  const Artist({
    required this.name,
    this.imageUrl,
    this.comment,
  });

  final String name;
  final String? imageUrl;
  final String? comment;
}
