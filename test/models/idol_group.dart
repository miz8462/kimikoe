class IdolGroup {
  const IdolGroup({
    required this.name,
    required this.imageUrl,
    this.id,
    this.year,
    this.comment,
    this.officialUrl,
    this.twitterUrl,
    this.instagramUrl,
    this.scheduleUrl,
  });

  final String name;
  final int? id;
  final String imageUrl;
  final int? year;
  final String? comment;
  final String? officialUrl;
  final String? twitterUrl;
  final String? instagramUrl;
  final String? scheduleUrl;
}
