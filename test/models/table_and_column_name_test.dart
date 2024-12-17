import 'package:flutter_test/flutter_test.dart';
import 'package:kimikoe_app/models/table_and_column_name.dart';

void main() {
  test('TableName定数のテスト', () {
    expect(TableName.artists, 'artists');
    expect(TableName.idols, 'idols');
    expect(TableName.idolGroups, 'idol-groups');
    expect(TableName.profiles, 'profiles');
    expect(TableName.songs, 'songs');
    expect(TableName.images, 'images');
  });

  test('ColumnName定数のテスト', () {
    expect(ColumnName.id, 'id');
    expect(ColumnName.name, 'name');
    expect(ColumnName.title, 'title');
    expect(ColumnName.email, 'email');
    expect(ColumnName.imageUrl, 'image_url');
    expect(ColumnName.comment, 'comment');
    expect(ColumnName.createdAt, 'created_at');
    expect(ColumnName.color, 'color');
    expect(ColumnName.birthday, 'birthday');
    expect(ColumnName.birthYear, 'birth_year');
    expect(ColumnName.height, 'height');
    expect(ColumnName.hometown, 'hometown');
    expect(ColumnName.yearFormingGroups, 'year_forming_group');
    expect(ColumnName.debutYear, 'debut_year');
    expect(ColumnName.officialUrl, 'official_url');
    expect(ColumnName.twitterUrl, 'twitter_url');
    expect(ColumnName.instagramUrl, 'instagram_url');
    expect(ColumnName.scheduleUrl, 'schedule_url');
    expect(ColumnName.otherUrl, 'other_url');
    expect(ColumnName.groupId, 'group_id');
    expect(ColumnName.lyrics, 'lyrics');
    expect(ColumnName.lyricistId, 'lyricist_id');
    expect(ColumnName.composerId, 'composer_id');
    expect(ColumnName.releaseDate, 'release_date');
  });
}
