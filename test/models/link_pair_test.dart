import 'package:flutter_test/flutter_test.dart';
import 'package:kimikoe_app/models/link_pair.dart';

void main() {
  test('LinkPairクラス', () {
    final linkPair = LinkPair(
      webUrl: Uri.parse('https://example.com'),
      deepLinkUrl: Uri.parse('app://deep-link'),
    );

    expect(linkPair.webUrl, Uri.parse('https://example.com'));
    expect(linkPair.deepLinkUrl, Uri.parse('app://deep-link'));
  });
}
