import 'package:flutter_test/flutter_test.dart';
import 'package:kimikoe_app/models/artist.dart';
import 'package:kimikoe_app/models/idol_group.dart';
import 'package:kimikoe_app/models/song.dart';

void main() {
  test('Songクラス', () {
    const idolGroup = IdolGroup(
      name: 'test group',
      imageUrl: 'https://example.com/test-group.jpg',
    );
    const artist = Artist(
      name: 'test artist',
      imageUrl: 'https://example.com/test-artist.jpg',
    );
    const song = Song(
      title: 'test title',
      lyrics: 'test lyrics',
      imageUrl: 'https://example.com/test-song.jpg',
      id: 1,
      group: idolGroup,
      composer: artist,
      lyricist: artist,
      releaseDate: '2023-01-22',
      comment: 'test comment',
    );

    expect(song.title, 'test title');
    expect(song.lyrics, 'test lyrics');
    expect(song.imageUrl, 'https://example.com/test-song.jpg');
    expect(song.id, 1);
    expect(song.group, idolGroup);
    expect(song.composer, artist);
    expect(song.lyricist, artist);
    expect(song.releaseDate, '2023-01-22');
    expect(song.comment, 'test comment');

    // オプションフィールドが未設定の場合
    const songWithoutOptionalFields = Song(
      title: 'another title',
      lyrics: 'another lyrics',
      imageUrl: 'https://example.com/another-song.jpg',
    );
    expect(songWithoutOptionalFields.title, 'another title');
    expect(songWithoutOptionalFields.lyrics, 'another lyrics');
    expect(
      songWithoutOptionalFields.imageUrl,
      'https://example.com/another-song.jpg',
    );
    expect(songWithoutOptionalFields.id, isNull);
    expect(songWithoutOptionalFields.group, isNull);
    expect(songWithoutOptionalFields.composer, isNull);
    expect(songWithoutOptionalFields.lyricist, isNull);
    expect(songWithoutOptionalFields.releaseDate, isNull);
    expect(songWithoutOptionalFields.comment, isNull);
  });
}
