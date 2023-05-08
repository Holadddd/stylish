import 'dart:io';

class DeviceInfo {
  static String get label {
    return 'Non-web platform';
  }

  static String get userAgent {
    return 'flutter-webrtc/non-web-plugin 0.0.1';
  }
}
