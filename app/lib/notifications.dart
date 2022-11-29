import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationService {
  final FirebaseMessaging _fcm;
  PushNotificationService(this._fcm);

  Future initialize() async {
    if (Platform.isIOS) {
      _fcm.requestNotificationPermissions(IosNotificationSettings());
    }

    String token = await _fcm.getToken();
    print("FirebaseMessaging token: $token");

    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("_fcm.onMessage: ${message}");
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("_fcm.onLaunch: ${message}");
      },
      onResume: (Map<String, dynamic> message) async {
        print("_fcm.onResume: ${message}");
      },
    );
  }
}
