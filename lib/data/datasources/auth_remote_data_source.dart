import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import '../../core/utils/result.dart';
import '../models/user_model.dart';
import '../../domain/entities/user.dart';

class AuthRemoteDataSource {
  final firebase_auth.FirebaseAuth _firebaseAuth;

  AuthRemoteDataSource({
    firebase_auth.FirebaseAuth? firebaseAuth,
  }) : _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance;
  Future<UserModel?> getCurrentUser() async {
    final firebaseUser = _firebaseAuth.currentUser;
    if (firebaseUser != null) {
      return UserModel.fromFirebaseUser(firebaseUser);
    }
    return null;
  }
  Stream<User?> get authStateChanges {
    return _firebaseAuth.authStateChanges().map((firebaseUser) {
      if (firebaseUser != null) {
        return UserModel.fromFirebaseUser(firebaseUser).toEntity();
      }
      return null;
    });
  }
  Future<Result<UserModel>> signInWithEmailAndPassword(String email, String password) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      if (credential.user != null) {
        return Success(UserModel.fromFirebaseUser(credential.user!));
      }
      return const Failure('Erreur lors de la connexion');
    } on firebase_auth.FirebaseAuthException catch (e) {
      return Failure(_handleAuthException(e));
    } catch (e) {
      return Failure('Erreur inattendue: ${e.toString()}');
    }
  }
  Future<Result<UserModel>> signUpWithEmailAndPassword(String email, String password) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      if (credential.user != null) {
        return Success(UserModel.fromFirebaseUser(credential.user!));
      }
      return const Failure('Erreur lors de l\'inscription');
    } on firebase_auth.FirebaseAuthException catch (e) {
      return Failure(_handleAuthException(e));
    } catch (e) {
      return Failure('Erreur inattendue: ${e.toString()}');
    }
  }
  Future<Result<UserModel>> signInWithGoogle() async {
    try {
      final googleProvider = firebase_auth.GoogleAuthProvider();
      googleProvider.addScope('email');
      googleProvider.addScope('profile');
      final userCredential = await _firebaseAuth.signInWithPopup(googleProvider);
      
      if (userCredential.user != null) {
        return Success(UserModel.fromFirebaseUser(userCredential.user!));
      }
      return const Failure('Erreur lors de la connexion avec Google');
    } on firebase_auth.FirebaseAuthException catch (e) {
      return Failure(_handleAuthException(e));
    } catch (e) {
      return Failure('Erreur Google Sign-In: ${e.toString()}');
    }
  }
  Future<Result<void>> signOut() async {
    try {
      await _firebaseAuth.signOut();
      return const Success(null);
    } catch (e) {
      return Failure('Erreur lors de la déconnexion: ${e.toString()}');
    }
  }
  Future<Result<void>> resetPassword(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      return const Success(null);
    } on firebase_auth.FirebaseAuthException catch (e) {
      return Failure(_handleAuthException(e));
    } catch (e) {
      return Failure('Erreur inattendue: ${e.toString()}');
    }
  }
  String _handleAuthException(firebase_auth.FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'Aucun utilisateur trouvé avec cet email';
      case 'wrong-password':
        return 'Mot de passe incorrect';
      case 'email-already-in-use':
        return 'Cet email est déjà utilisé';
      case 'invalid-email':
        return 'Email invalide';
      case 'weak-password':
        return 'Le mot de passe doit contenir au moins 6 caractères';
      case 'user-disabled':
        return 'Ce compte a été désactivé';
      case 'too-many-requests':
        return 'Trop de tentatives. Réessayez plus tard';
      case 'operation-not-allowed':
        return 'Opération non autorisée';
      case 'invalid-credential':
        return 'Identifiants invalides';
      default:
        return 'Erreur d\'authentification: ${e.message}';
    }
  }
}
