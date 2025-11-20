import '../../core/utils/result.dart';
import '../entities/user.dart';

abstract class AuthRepository {
  Future<User?> getCurrentUser();
  Stream<User?> get authStateChanges;
  Future<Result<User>> signInWithEmailAndPassword(String email, String password);
  Future<Result<User>> signUpWithEmailAndPassword(String email, String password);
  Future<Result<User>> signInWithGoogle();
  Future<Result<void>> signOut();
  Future<Result<void>> resetPassword(String email);
}
