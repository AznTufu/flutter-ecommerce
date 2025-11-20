import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/user.dart';
import '../../core/utils/result.dart';
import 'repository_providers.dart';
class AuthState {
  final User? user;
  final bool isLoading;
  final String? errorMessage;

  const AuthState({
    this.user,
    this.isLoading = false,
    this.errorMessage,
  });

  AuthState copyWith({
    User? user,
    bool? isLoading,
    String? errorMessage,
  }) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}
class AuthNotifier extends StateNotifier<AuthState> {
  final Ref ref;

  AuthNotifier(this.ref) : super(const AuthState()) {
    _init();
  }

  void _init() {
    final authRepo = ref.read(authRepositoryProvider);
    authRepo.authStateChanges.listen((user) {
      state = state.copyWith(user: user, errorMessage: null);
    });
  }

  Future<void> signIn(String email, String password) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    
    final authRepo = ref.read(authRepositoryProvider);
    final result = await authRepo.signInWithEmailAndPassword(email, password);
    
    result.when(
      success: (user) {
        state = state.copyWith(user: user, isLoading: false);
      },
      failure: (message) {
        state = state.copyWith(isLoading: false, errorMessage: message);
      },
    );
  }

  Future<void> signUp(String email, String password) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    
    final authRepo = ref.read(authRepositoryProvider);
    final result = await authRepo.signUpWithEmailAndPassword(email, password);
    
    result.when(
      success: (user) {
        state = state.copyWith(user: user, isLoading: false);
      },
      failure: (message) {
        state = state.copyWith(isLoading: false, errorMessage: message);
      },
    );
  }

  Future<void> signInWithGoogle() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    
    final authRepo = ref.read(authRepositoryProvider);
    final result = await authRepo.signInWithGoogle();
    
    result.when(
      success: (user) {
        state = state.copyWith(user: user, isLoading: false);
      },
      failure: (message) {
        state = state.copyWith(isLoading: false, errorMessage: message);
      },
    );
  }

  Future<void> signOut() async {
    final authRepo = ref.read(authRepositoryProvider);
    await authRepo.signOut();
    state = const AuthState();
  }

  Future<void> resetPassword(String email) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    
    final authRepo = ref.read(authRepositoryProvider);
    final result = await authRepo.resetPassword(email);
    
    result.when(
      success: (_) {
        state = state.copyWith(isLoading: false);
      },
      failure: (message) {
        state = state.copyWith(isLoading: false, errorMessage: message);
      },
    );
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref);
});
final isAuthenticatedProvider = Provider<bool>((ref) {
  final authState = ref.watch(authProvider);
  return authState.user != null;
});
