import 'dart:io';

class AdHelper {
  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-1244048788776493/7246889843';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-1244048788776493/7246889843';
    }
    throw UnsupportedError("Unsupported platform");
  }

  static String get banner2AdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-1244048788776493/9037665420';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-1244048788776493/9037665420';
    }
    throw UnsupportedError("Unsupported platform");
  }
}
