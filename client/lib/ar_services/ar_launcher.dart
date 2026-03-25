import 'package:url_launcher/url_launcher.dart';

Future<void> launchAR(String modelUrl) async {
  final uri = Uri.parse(
    "https://arvr.google.com/scene-viewer/1.0"
    "?file=$modelUrl"
    "&mode=ar_preferred"
  );

  if (!await launchUrl(
    uri,
    mode: LaunchMode.externalApplication,
  )) {
    throw 'Could not launch AR';
  }
}
