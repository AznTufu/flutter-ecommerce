import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/services/biometric_service.dart';
import '../../core/utils/platform_helper.dart';
class BiometricState {
  final bool isAuthenticated;
  final bool isAvailable;
  final bool isLoading;

  const BiometricState({
    this.isAuthenticated = false,
    this.isAvailable = false,
    this.isLoading = true,
  });

  BiometricState copyWith({
    bool? isAuthenticated,
    bool? isAvailable,
    bool? isLoading,
  }) {
    return BiometricState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isAvailable: isAvailable ?? this.isAvailable,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
class BiometricNotifier extends StateNotifier<BiometricState> {
  BiometricNotifier() : super(const BiometricState()) {
    _checkAvailability();
  }
  Future<void> _checkAvailability() async {
    if (!PlatformHelper.isMobile) {
      state = state.copyWith(
        isAuthenticated: true,
        isAvailable: false,
        isLoading: false,
      );
      return;
    }

    final isAvailable = await BiometricService.isAvailable();
    state = state.copyWith(
      isAvailable: isAvailable,
      isLoading: false,
      isAuthenticated: !isAvailable,
    );
  }
  Future<void> authenticate() async {
    if (!state.isAvailable) {
      state = state.copyWith(isAuthenticated: true);
      return;
    }

    final success = await BiometricService.authenticate(
      reason: 'Authentifiez-vous pour accéder à KeyboardShop',
    );

    state = state.copyWith(isAuthenticated: success);
  }
  void reset() {
    state = state.copyWith(isAuthenticated: false);
  }
  void skip() {
    state = state.copyWith(isAuthenticated: true);
  }
}
final biometricProvider = StateNotifierProvider<BiometricNotifier, BiometricState>(
  (ref) => BiometricNotifier(),
);
final isBiometricAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(biometricProvider).isAuthenticated;
});
final isBiometricAvailableProvider = Provider<bool>((ref) {
  return ref.watch(biometricProvider).isAvailable;
});
