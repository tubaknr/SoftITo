// ignore: avoid_web_libraries_in_flutter, deprecated_member_use
import 'dart:html' as html;

void openUrlInBrowser(String url) {
  try {
    html.window.open(url, '_blank');
  } catch (_) {}
}
