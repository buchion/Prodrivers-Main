import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:prodrivers/components/notification.dart';

import '../main.dart';

class Biometric {

  static final LocalAuthentication auth = LocalAuthentication();

  Future<bool> checkAvailableBiometrics() async {
    try {
      bool canCheckBiometrics = await auth.canCheckBiometrics;
      
      print('$canCheckBiometrics cancheckher4e');
      return canCheckBiometrics;
    } on PlatformException catch (e) {
      // print(e);
      notifySuccess(
          content: 'Go to Settings and setup your Biometrics credential');
    }
    return false;
  }

  Future<void> authenticate(dynamic callback, dynamic callback2) async {
    bool? authenticated;

    try {
      
      authenticated = await auth.authenticate(
          localizedReason: 'Scan your fingerprint to authenticate',
          options: const AuthenticationOptions(biometricOnly: true),
          // useErrorDialogs: true,
          // stickyAuth: true
          );
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print(e);
      }
      notifySuccess(
          content: 'Go to Settings and setup your Biometrics credential');
    }

    if (authenticated == true) {
      callback();
    } else {
      callback2();
    }
  }

  Future<void> validateFingerprint(dynamic callback, dynamic callback2) async {
    var check = await checkAvailableBiometrics();
    if (check == true) {
      await authenticate(callback, callback2);
    }
  }
}
