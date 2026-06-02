import 'package:dio/dio.dart';
import '../models/verification_model.dart';

abstract class VerificationRemoteDataSource {
  Future<VerificationModel> uploadVerificationFiles({
    required String userId,
    required String frontIdPath,
    required String backIdPath,
    required List<String> selfiePaths,
    required String livenessVideoPath,
  });
}

class VerificationRemoteDataSourceImpl implements VerificationRemoteDataSource {
  final Dio dio;

  VerificationRemoteDataSourceImpl({required this.dio});

  @override
  Future<VerificationModel> uploadVerificationFiles({
    required String userId,
    required String frontIdPath,
    required String backIdPath,
    required List<String> selfiePaths,
    required String livenessVideoPath,
  }) async {
    // 1. Prepare files to map into multipart form data
    final Map<String, dynamic> uploadMap = {
      'user_id': userId,
      'front_id': await MultipartFile.fromFile(frontIdPath, filename: 'front_id.jpg'),
      'back_id': await MultipartFile.fromFile(backIdPath, filename: 'back_id.jpg'),
      'liveness_video': await MultipartFile.fromFile(livenessVideoPath, filename: 'liveness.mp4'),
    };

    // 2. Loop and map out your multi-angle selfies list
    List<MultipartFile> selfieMultipartList = [];
    for (String path in selfiePaths) {
      selfieMultipartList.add(
        await MultipartFile.fromFile(path, filename: 'selfie_${path.split('/').last}'),
      );
    }
    uploadMap['selfies'] = selfieMultipartList;

    final formData = FormData.fromMap(uploadMap);

    // 3. Fire request to your network target
    final response = await dio.post(
      '/api/v1/verification/submit',
      data: formData,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return VerificationModel.fromJson(response.data);
    } else {
      throw Exception('Server failed to register biometric profile data packets.');
    }
  }
}