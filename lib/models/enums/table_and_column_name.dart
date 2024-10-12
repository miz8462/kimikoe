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
  cName('name'),
  title('title'),
  email('email'),
  imageUrl('image_url'),
  comment('comment'),
  createdAt('created_at'),
  color('color'),
  birthday('birthday'),
  birthYear('birth_year'),
  height('height'),
  hometown('hometown'),
  yearFormingGroups('year_forming_group'),
  debutYear('debut_year'),
  officialUrl('official_url'),
  twitterUrl('twitter_url'),
  instagramUrl('instagram_url'),
  groupId('group_id'),
  lyrics('lyrics'),
  lyricistId('lyricist_id'),
  composerId('composer_id'),
  releaseDate('release_date'),
  ;

  final String name;
  const ColumnName(this.name);
}
