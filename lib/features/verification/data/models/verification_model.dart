import '../../domain/entities/verification.dart';

class VerificationModel extends Verification {
  VerificationModel({
    required super.userId,
    required super.frontIdPath,
    required super.backIdPath,
    required super.selfiePaths,
    required super.livenessVideoPath,
  });

  factory VerificationModel.fromJson(Map<String, dynamic> json) {
    return VerificationModel(
      userId: json['user_id'] ?? '',
      frontIdPath: json['front_id_path'] ?? '',
      backIdPath: json['back_id_path'] ?? '',
      selfiePaths: List<String>.from(json['selfie_paths'] ?? []),
      livenessVideoPath: json['liveness_video_path'] ?? '',
    );
  }
}