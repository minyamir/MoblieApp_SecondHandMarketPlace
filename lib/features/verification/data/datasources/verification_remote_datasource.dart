import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';

class VerificationRemoteDataSource {
  final ApiClient apiClient;

  VerificationRemoteDataSource(this.apiClient);

  Future<void> submitVerification({
    required String frontId,
    required String backId,
    required List<String> selfies,
    required String videoPath,
  }) async {
    final formData = FormData.fromMap({
      'frontId': await MultipartFile.fromFile(frontId),
      'backId': await MultipartFile.fromFile(backId),
      'selfie_front': await MultipartFile.fromFile(selfies[0]),
      'selfie_left': await MultipartFile.fromFile(selfies[1]),
      'selfie_right': await MultipartFile.fromFile(selfies[2]),
      'livenessVideo': await MultipartFile.fromFile(videoPath),
    });

    await apiClient.dio.post('/verification/submit', data: formData);
  }
}