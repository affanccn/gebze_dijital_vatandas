import 'package:url_launcher/url_launcher.dart';

class LauncherUtils {
  static Future<void> openMap(String query) async {
    final url = Uri.parse('https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(query)}');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  static Future<void> callPhone(String number) async {
    final cleanNumber = number.replaceAll(RegExp(r'[^\d+]'), '');
    final url = Uri.parse('tel:$cleanNumber');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }
  
  static Future<void> openUrl(String urlString) async {
    try {
      var safeUrl = urlString.trim();
      if (safeUrl.startsWith('/')) {
        safeUrl = 'https://www.gebze.bel.tr$safeUrl';
      }
      final url = Uri.parse(safeUrl);
      // canLaunchUrl sometimes fails or returns false incorrectly on Android 11+ without manifest queries.
      // We will try to launch it directly, and catch the exception if it fails.
      await launchUrl(url, mode: LaunchMode.inAppWebView);
    } catch (e) {
      print('Could not launch URL $urlString: $e');
    }
  }
}
