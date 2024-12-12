import 'package:flutter_test/flutter_test.dart';

class LinkPair {
  const LinkPair({this.webUrl, this.deepLinkUrl});

  final Uri? webUrl;
  final Uri? deepLinkUrl;
}

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
