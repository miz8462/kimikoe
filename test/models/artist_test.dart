import 'package:flutter_test/flutter_test.dart';
import 'package:kimikoe_app/models/artist.dart';

void main() {
  test('Artistクラス', () {
    const artist = Artist(
      name: 'test artist',
      imageUrl: 'https://example.com/test.jpg',
      id: 1,
      comment: 'test comment',
    );

    expect(artist.name, 'test artist');
    expect(artist.imageUrl, 'https://example.com/test.jpg');
    expect(artist.id, 1);
    expect(artist.comment, 'test comment');

    // オプションフィールドが未設定の場合
    const artistWithoutOptionalFields = Artist(
      name: 'another artist',
      imageUrl: 'https://example.com/another.jpg',
    );

    expect(artistWithoutOptionalFields.name, 'another artist');
    expect(
      artistWithoutOptionalFields.imageUrl,
      'https://example.com/another.jpg',
    );
    expect(artistWithoutOptionalFields.id, isNull);
    expect(artistWithoutOptionalFields.comment, isNull);
  });
}
