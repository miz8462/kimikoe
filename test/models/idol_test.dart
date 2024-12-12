import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kimikoe_app/models/idol.dart';
import 'package:kimikoe_app/models/idol_group.dart';

void main() {
  test('Idolクラス', () {
    const idolGroup = IdolGroup(
      name: 'test group',
      imageUrl: 'https://example.com/test-group.jpg',
    );
    const idol = Idol(
      name: 'test idol',
      imageUrl: 'https://example.com/test-idol.jpg',
      id: 1,
      comment: 'test comment',
      group: idolGroup,
      birthDay: '01-22',
      birthYear: 2000,
      debutYear: 2023,
      color: Colors.red,
      height: 158,
      hometown: 'Sapporo',
      officialUrl: 'https://example.com/official',
      twitterUrl: 'https://twitter.com/test_idol',
      instagramUrl: 'https://instagram.com/test_idol',
      otherUrl: 'https://example.com/other',
    );

    expect(idol.name, 'test idol');
    expect(idol.imageUrl, 'https://example.com/test-idol.jpg');
    expect(idol.id, 1);
    expect(idol.comment, 'test comment');
    expect(idol.group, idolGroup);
    expect(idol.birthDay, '01-22');
    expect(idol.birthYear, 2000);
    expect(idol.debutYear, 2023);
    expect(idol.color, Colors.red);
    expect(idol.height, 158);
    expect(idol.hometown, 'Sapporo');
    expect(idol.officialUrl, 'https://example.com/official');
    expect(idol.twitterUrl, 'https://twitter.com/test_idol');
    expect(idol.instagramUrl, 'https://instagram.com/test_idol');
    expect(idol.otherUrl, 'https://example.com/other');

    // オプションフィールドが未設定の場合
    const idolWithoutOptionalFields = Idol(
      name: 'another idol',
      imageUrl: 'https://example.com/another-idol.jpg',
    );
    expect(idolWithoutOptionalFields.name, 'another idol');
    expect(idolWithoutOptionalFields.imageUrl, 'https://example.com/another-idol.jpg');
    expect(idolWithoutOptionalFields.id, isNull);
    expect(idolWithoutOptionalFields.comment, isNull);
    expect(idolWithoutOptionalFields.group, isNull);
    expect(idolWithoutOptionalFields.birthDay, isNull);
    expect(idolWithoutOptionalFields.birthYear, isNull);
    expect(idolWithoutOptionalFields.debutYear, isNull);
    expect(idolWithoutOptionalFields.color, isNull);
    expect(idolWithoutOptionalFields.height, isNull);
    expect(idolWithoutOptionalFields.hometown, isNull);
    expect(idolWithoutOptionalFields.officialUrl, isNull);
    expect(idolWithoutOptionalFields.twitterUrl, isNull);
    expect(idolWithoutOptionalFields.instagramUrl, isNull);
    expect(idolWithoutOptionalFields.otherUrl, isNull);
  });
}
