import 'package:http/http.dart' as http;
import 'package:kimikoe_app/models/link_pair.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> openTwitter(Uri twitterDeepLinkUrl, Uri twitterWebUrl) async {
  if (await canLaunchUrl(twitterDeepLinkUrl)) {
    await launchUrl(
      twitterDeepLinkUrl,
      mode: LaunchMode.externalApplication,
    );
  } else if (await canLaunchUrl(twitterWebUrl)) {
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
    await launchUrl(
      instagramDeepLinkUrl,
      mode: LaunchMode.externalApplication,
    );
  } else if (await canLaunchUrl(instagramWebUrl)) {
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
    await launchUrl(
      url,
      mode: LaunchMode.platformDefault,
    );
  } else {
    throw '開くことができません: $url';
  }
}

Future<bool> isUrlExists(String? url) async {
  if (url != null && url.isNotEmpty) {
    try {
      final headResponse = await http.head(
        Uri.parse(url),
      );
      if (headResponse.statusCode == 200) {
        return true;
      }
      final getResponse = await http.get(
        Uri.parse(url),
      );
      if (getResponse.statusCode == 200) {
        return true;
      }
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }
  return false;
}

Future<Uri?> convertUrlStringToUri(String? url) async {
  if (await isUrlExists(url)) {
    return Uri.parse(url!);
  }
  return null;
}

Uri? createDeepLinkFromWebUrl(Uri? webUrl, String scheme) {
  if (webUrl != null) {
    final userName = webUrl.pathSegments.last;
    return Uri.parse('$scheme$userName');
  }
  return null;
}

Future<LinkPair> fetchWebUrlAndDeepLinkUrl(
    String? url, String scheme) async {
  Uri? webUrl = await convertUrlStringToUri(url);
  Uri? deepLinkUrl = createDeepLinkFromWebUrl(webUrl, scheme);
  return LinkPair(webUrl: webUrl, deepLinkUrl: deepLinkUrl);
}
