import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<User> login(String email, String password) async {
    final response = await remoteDataSource.login(email, password);
    // Assuming response contains a 'user' object as defined in your model
    final userModel = UserModel.fromJson(response['user']);
    
    return User(
      id: userModel.id,
      fullName: userModel.fullName,
      email: userModel.email,
      isVerified: userModel.isVerified,
    );
  }

  @override
  Future<void> register(String fullName, String email, String password) async {
    await remoteDataSource.register(fullName, email, password);
  }

  @override
  Future<void> logout() async {
    // Logic to clear tokens from local storage
  }
}