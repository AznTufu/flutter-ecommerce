import '../../core/utils/result.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<User?> getCurrentUser() async {
    final userModel = await remoteDataSource.getCurrentUser();
    return userModel?.toEntity();
  }

  @override
  Stream<User?> get authStateChanges => remoteDataSource.authStateChanges;

  @override
  Future<Result<User>> signInWithEmailAndPassword(String email, String password) async {
    final result = await remoteDataSource.signInWithEmailAndPassword(email, password);
    return result.when(
      success: (userModel) => Success(userModel.toEntity()),
      failure: (message) => Failure(message),
    );
  }

  @override
  Future<Result<User>> signUpWithEmailAndPassword(String email, String password) async {
    final result = await remoteDataSource.signUpWithEmailAndPassword(email, password);
    return result.when(
      success: (userModel) => Success(userModel.toEntity()),
      failure: (message) => Failure(message),
    );
  }

  @override
  Future<Result<User>> signInWithGoogle() async {
    final result = await remoteDataSource.signInWithGoogle();
    return result.when(
      success: (userModel) => Success(userModel.toEntity()),
      failure: (message) => Failure(message),
    );
  }

  @override
  Future<Result<void>> signOut() async {
    return await remoteDataSource.signOut();
  }

  @override
  Future<Result<void>> resetPassword(String email) async {
    return await remoteDataSource.resetPassword(email);
  }
}
