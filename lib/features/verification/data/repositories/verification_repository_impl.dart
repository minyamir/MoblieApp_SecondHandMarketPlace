import '../../domain/entities/verification.dart';
import '../../domain/repositories/verification_repository.dart';
import '../datasources/verification_remote_datasource.dart';

class VerificationRepositoryImpl implements VerificationRepository {
  final VerificationRemoteDataSource remoteDataSource;

  VerificationRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Verification> submitVerification({
    required String userId,
    required String frontIdPath,
    required String backIdPath,
    required List<String> selfiePaths,
    required String livenessVideoPath,
  }) async {
    try {
      return await remoteDataSource.uploadVerificationFiles(
        userId: userId,
        frontIdPath: frontIdPath,
        backIdPath: backIdPath,
        selfiePaths: selfiePaths,
        livenessVideoPath: livenessVideoPath,
      );
    } catch (e) {
      throw Exception('Repository structural submission exception: $e');
    }
  }
}