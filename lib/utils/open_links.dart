import 'package:http/http.dart' as http;
import 'package:kimikoe_app/main.dart';
import 'package:kimikoe_app/models/link_pair.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> openAppOrWeb(Uri deepLinkUrl, Uri webUrl) async {
  if (await canLaunchUrl(deepLinkUrl)) {
    await launchUrl(
      deepLinkUrl,
      mode: LaunchMode.externalApplication,
    );
  } else if (await canLaunchUrl(webUrl)) {
    await launchUrl(
      webUrl,
    );
  } else {
    throw Exception('どちらのURLも開くことができません: $deepLinkUrl, $webUrl');
  }
}

Future<void> openWebSite(Uri url) async {
  if (await canLaunchUrl(url)) {
    await launchUrl(
      url,
    );
  } else {
    throw Exception('開くことができません: $url');
  }
}

Future<bool> isUrlExists(String? url, {http.Client? client}) async {
  client ??= http.Client();
  if (url != null && url.isNotEmpty) {
    try {
      final headResponse = await client.head(
        Uri.parse(url),
      );

      logger.i('HEAD request status code: ${headResponse.statusCode}');
      if (headResponse.statusCode == 200) {
        return true;
      }
      final getResponse = await client.get(
        Uri.parse(url),
      );
      logger.i('GET request status code: ${getResponse.statusCode}');
      if (getResponse.statusCode == 200) {
        return true;
      }
      return false;
    } catch (e, stackTrace) {
      logger.e('Error: $e', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }
  return false;
}

Future<Uri?> convertUrlStringToUri(String? url, {http.Client? client}) async {
  client ??= http.Client();
  try {
    if (await isUrlExists(url, client: client)) {
      return Uri.parse(url!);
    }
  } catch (e, stackTrace) {
    logger.e('Error: $e', error: e, stackTrace: stackTrace);
  }
  return null;
}

Uri? createDeepLinkFromWebUrl(Uri? webUrl, String? scheme) {
  if (webUrl != null && scheme != null) {
    final userName = webUrl.pathSegments.last;
    return Uri.parse('$scheme$userName');
  }
  return null;
}

Future<LinkPair> fetchWebUrlAndDeepLinkUrl(
  String? url, {
  String? scheme,
}) async {
  final webUrl = await convertUrlStringToUri(url);
  if (scheme == null) {
    return LinkPair(webUrl: webUrl);
  }
  final deepLinkUrl = createDeepLinkFromWebUrl(webUrl, scheme);
  return LinkPair(webUrl: webUrl, deepLinkUrl: deepLinkUrl);
}
