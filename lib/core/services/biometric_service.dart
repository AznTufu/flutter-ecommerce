import 'package:local_auth/local_auth.dart';
import 'package:flutter/services.dart';
import '../utils/platform_helper.dart';
class BiometricService {
  static final LocalAuthentication _auth = LocalAuthentication();
  static Future<bool> isAvailable() async {
    if (!PlatformHelper.isMobile) return false;

    try {
      return await _auth.canCheckBiometrics && await _auth.isDeviceSupported();
    } catch (e) {
      print('Erreur lors de la vérification de la biométrie: $e');
      return false;
    }
  }
  static Future<List<BiometricType>> getAvailableBiometrics() async {
    if (!PlatformHelper.isMobile) return [];

    try {
      return await _auth.getAvailableBiometrics();
    } catch (e) {
      print('Erreur lors de la récupération des types de biométrie: $e');
      return [];
    }
  }
  static Future<bool> authenticate({
    required String reason,
    bool useErrorDialogs = true,
    bool stickyAuth = true,
  }) async {
    if (!PlatformHelper.isMobile) return false;

    try {
      final isAvailable = await BiometricService.isAvailable();
      if (!isAvailable) return false;

      return await _auth.authenticate(
        localizedReason: reason,
        options: AuthenticationOptions(
          useErrorDialogs: useErrorDialogs,
          stickyAuth: stickyAuth,
          biometricOnly: true,
        ),
      );
    } on PlatformException catch (e) {
      print('Erreur d\'authentification biométrique: ${e.message}');
      return false;
    } catch (e) {
      print('Erreur lors de l\'authentification: $e');
      return false;
    }
  }
  static Future<String> getBiometricName() async {
    if (!PlatformHelper.isMobile) return 'Biométrie';

    final biometrics = await getAvailableBiometrics();

    if (biometrics.contains(BiometricType.face)) {
      return PlatformHelper.isIOS ? 'Face ID' : 'Reconnaissance faciale';
    } else if (biometrics.contains(BiometricType.fingerprint)) {
      return PlatformHelper.isIOS ? 'Touch ID' : 'Empreinte digitale';
    } else if (biometrics.contains(BiometricType.iris)) {
      return 'Reconnaissance de l\'iris';
    } else if (biometrics.contains(BiometricType.strong)) {
      return 'Authentification forte';
    } else if (biometrics.contains(BiometricType.weak)) {
      return 'Authentification biométrique';
    }

    return 'Biométrie';
  }
}
