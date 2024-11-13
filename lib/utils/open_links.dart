import 'package:url_launcher/url_launcher.dart';

Future<void> openTwitter(Uri twitterDeepLinkUrl, Uri twitterWebUrl) async {
  if (await canLaunchUrl(twitterDeepLinkUrl)) {
    print('アプリ');
    await launchUrl(
      twitterDeepLinkUrl,
      mode: LaunchMode.externalApplication,
    );
  } else if (await canLaunchUrl(twitterWebUrl)) {
    print('ブラウザ');
    await launchUrl(
      twitterWebUrl,
      mode: LaunchMode.platformDefault,
    );
  } else {
    throw 'どちらのURLも開くことができません: $twitterDeepLinkUrl, $twitterWebUrl';
  }
}

Future<void> openInstagram(
    Uri instagramDeepLinkUrl, Uri instagramWebUrl) async {
  if (await canLaunchUrl(instagramDeepLinkUrl)) {
    print('アプリ');

    await launchUrl(
      instagramDeepLinkUrl,
      mode: LaunchMode.externalApplication,
    );
  } else if (await canLaunchUrl(instagramWebUrl)) {
    print('ブラウザ');

    await launchUrl(
      instagramWebUrl,
      mode: LaunchMode.platformDefault,
    );
  } else {
    throw 'どちらのURLも開くことができません: $instagramDeepLinkUrl, $instagramWebUrl';
  }
}

Future<void> openOfficialSite(Uri url) async {
  if (await canLaunchUrl(url)) {
    print('ブラウザ');
    await launchUrl(
      url,
      mode: LaunchMode.platformDefault,
    );
  } else {
    throw '開くことができません: $url';
  }
}
