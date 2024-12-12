import 'package:flutter_test/flutter_test.dart';

void main() {
  test('IdolGroupクラス', () {
    const idolGroup = IdolGroup(
      name: 'test name',
      imageUrl: 'https://example.com/test.jpg',
      id: 1,
      year: 2022,
      comment: 'test comment',
      officialUrl: 'https://example.com',
      twitterUrl: 'https://twitter.com',
      instagramUrl: 'https://instagram.com',
      scheduleUrl: 'https://example.com/schedule',
    );

    expect(idolGroup.name, 'test name');
    expect(idolGroup.imageUrl, 'https://example.com/test.jpg');
    expect(idolGroup.id, 1);
    expect(idolGroup.year, 2022);
    expect(idolGroup.comment, 'test comment');
    expect(idolGroup.officialUrl, 'https://example.com');
    expect(idolGroup.twitterUrl, 'https://twitter.com');
    expect(idolGroup.instagramUrl, 'https://instagram.com');
    expect(idolGroup.scheduleUrl, 'https://example.com/schedule');

    // オプションフィールドが未設定の場合
    const idolGroupWithoutOptionalFields = IdolGroup(
      name: 'another name',
      imageUrl: 'https://example.com/another.jpg',
    );
    expect(idolGroupWithoutOptionalFields.name, 'another name');
    expect(
      idolGroupWithoutOptionalFields.imageUrl,
      'https://example.com/another.jpg',
    );
    expect(idolGroupWithoutOptionalFields.id, isNull);
    expect(idolGroupWithoutOptionalFields.year, isNull);
    expect(idolGroupWithoutOptionalFields.comment, isNull);
    expect(idolGroupWithoutOptionalFields.officialUrl, isNull);
    expect(idolGroupWithoutOptionalFields.twitterUrl, isNull);
    expect(idolGroupWithoutOptionalFields.instagramUrl, isNull);
  });
}

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
