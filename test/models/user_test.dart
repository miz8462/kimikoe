import 'package:flutter_test/flutter_test.dart';
import 'package:kimikoe_app/config/config.dart';
import 'package:kimikoe_app/models/user.dart';

void main() {
  test('UserProfileクラス', () {
    const userProfile = UserProfile(
      id: '1',
      name: 'test name',
      email: 'sample@sample.com',
      imageUrl: 'https://example.com/test.jpg',
      comment: 'test comment',
    );

    expect(userProfile.id, '1');
    expect(userProfile.name, 'test name');
    expect(userProfile.email, 'sample@sample.com');
    expect(userProfile.imageUrl, 'https://example.com/test.jpg');
    expect(userProfile.comment, 'test comment');

    // オプションフィールドが未設定の場合
    const userProfileWithoutOptionalFields = UserProfile(
      id: '2',
      name: 'another name',
      email: 'sample@sample.com',
    );
    expect(userProfileWithoutOptionalFields.id, '2');
    expect(userProfileWithoutOptionalFields.name, 'another name');
    expect(userProfileWithoutOptionalFields.email, 'sample@sample.com');
    expect(userProfileWithoutOptionalFields.imageUrl, noImage);
    expect(userProfileWithoutOptionalFields.comment, '');
  });
}
