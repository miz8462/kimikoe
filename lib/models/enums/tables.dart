enum TableName {
  artists('artists'),
  idol('idol'),
  idolGroups('idol-groups'),
  profiles('profiles'),
  songs('songs'),
  images('images'), // storage名
  ;

  final String name;
  const TableName(this.name);
}

enum ColumnName {
  id('id'),
  name('name'),
  title('title'),
  email('email'),
  imageUrl('image_url'),
  comment('comment'),
  createdAt('created_at'),
  color('color'),
  birthday('birthday'),
  height('height'),
  hometown('hometown'),
  yearFormingGroups('year_forming_groups'),
  debutYear('debut_year'),
  officialUrl('official_url'),
  twitterUrl('twitter_url'),
  instagramUrl('instagram_url'),
  groupId('group_id'),
  lyrics('lyrics'),
  lyricist('lyricist'),
  composer('composer'),
  releaseDate('release_date'),
  ;

  final String colname;
  const ColumnName(this.colname);
}
