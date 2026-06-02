import '../entities/verification.dart';

abstract class VerificationRepository {
  Future<Verification> submitVerification({
    required String userId,
    required String frontIdPath,
    required String backIdPath,
    required List<String> selfiePaths,
    required String livenessVideoPath,
  });
}