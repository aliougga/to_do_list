import 'dart:io';

class AdHelper {
  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      ///test return 'ca-app-pub-3940256099942544/6300978111';
      ///final retutn ca-app-pub-1244048788776493/7246889843
      return "ca-app-pub-3940256099942544/6300978111";
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/6300978111';
    }
    throw UnsupportedError("Unsupported platform");
  }

  static String get banner2AdUnitId {
    if (Platform.isAndroid) {
      ///final_id ca-app-pub-1244048788776493/9037665420
      ///test id ca-app-pub-3940256099942544/6300978111
      return "ca-app-pub-3940256099942544/6300978111";
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/6300978111';
    }
    throw UnsupportedError("Unsupported platform");
  }
}
