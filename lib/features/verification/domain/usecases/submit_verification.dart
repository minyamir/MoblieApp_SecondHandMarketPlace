import '../entities/verification.dart';
import '../repositories/verification_repository.dart';

class SubmitVerification {
  final VerificationRepository repository;

  SubmitVerification(this.repository);

  Future<Verification> call({
    required String userId,
    required String frontIdPath,
    required String backIdPath,
    required List<String> selfiePaths,
    required String livenessVideoPath,
  }) async {
    return await repository.submitVerification(
      userId: userId,
      frontIdPath: frontIdPath,
      backIdPath: backIdPath,
      selfiePaths: selfiePaths,
      livenessVideoPath: livenessVideoPath,
    );
  }
}