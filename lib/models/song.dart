class Song {
  const Song({
    required this.title,
    required this.lyrics,
    this.id,
    this.groupId,
    this.imageUrl,
    this.lyricistId,
    this.composerId,
    this.releaseDate,
  });

  final String title;
  final String lyrics;
  final int? id;
  final int? groupId;
  final String? imageUrl;
  final int? lyricistId;
  final int? composerId;
  final DateTime? releaseDate;
}
