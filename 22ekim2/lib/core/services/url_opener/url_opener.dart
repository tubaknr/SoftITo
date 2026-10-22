import 'url_opener_stub.dart'
    if (dart.library.html) 'url_opener_web.dart' as platform;

/// Utility to open external browser windows
class UrlOpener {
  const UrlOpener._();

  static void open(String url) {
    platform.openUrlInBrowser(url);
  }
}
