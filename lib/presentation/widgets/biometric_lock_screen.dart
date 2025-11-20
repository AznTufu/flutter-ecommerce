import 'package:flutter/material.dart';
import '../../core/services/biometric_service.dart';
import '../../core/utils/platform_helper.dart';
class BiometricLockScreen extends StatefulWidget {
  final VoidCallback onAuthenticated;
  final VoidCallback? onSkip;

  const BiometricLockScreen({
    super.key,
    required this.onAuthenticated,
    this.onSkip,
  });

  @override
  State<BiometricLockScreen> createState() => _BiometricLockScreenState();
}

class _BiometricLockScreenState extends State<BiometricLockScreen> {
  String _biometricName = 'Biométrie';
  bool _isAuthenticating = false;

  @override
  void initState() {
    super.initState();
    _loadBiometricName();
    _authenticate();
  }

  Future<void> _loadBiometricName() async {
    final name = await BiometricService.getBiometricName();
    if (mounted) {
      setState(() {
        _biometricName = name;
      });
    }
  }

  Future<void> _authenticate() async {
    if (_isAuthenticating) return;
    
    setState(() {
      _isAuthenticating = true;
    });

    try {
      final authenticated = await BiometricService.authenticate(
        reason: 'Authentifiez-vous pour accéder à KeyboardShop',
      );

      if (mounted) {
        if (authenticated) {
          widget.onAuthenticated();
        } else {
          setState(() {
            _isAuthenticating = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isAuthenticating = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur d\'authentification: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!PlatformHelper.isMobile) {
      widget.onAuthenticated();
      return const SizedBox.shrink();
    }

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).primaryColor,
              Theme.of(context).primaryColor.withOpacity(0.7),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      PlatformHelper.isIOS 
                          ? Icons.face_outlined 
                          : Icons.fingerprint,
                      size: 60,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    'KeyboardShop',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Authentifiez-vous avec $_biometricName',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.9),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 48),
                  if (!_isAuthenticating)
                    ElevatedButton.icon(
                      onPressed: _authenticate,
                      icon: Icon(
                        PlatformHelper.isIOS 
                            ? Icons.face_outlined 
                            : Icons.fingerprint,
                      ),
                      label: Text('Utiliser $_biometricName'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Theme.of(context).primaryColor,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
                        ),
                      ),
                    )
                  else
                    const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  if (widget.onSkip != null) ...[
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: widget.onSkip,
                      child: const Text(
                        'Ignorer',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],

                  const SizedBox(height: 32),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '📱 ${PlatformHelper.platformName}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withOpacity(0.7),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
