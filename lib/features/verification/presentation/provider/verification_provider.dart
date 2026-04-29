import 'package:flutter/material.dart';
import '../../data/datasources/verification_remote_datasource.dart';

class VerificationProvider extends ChangeNotifier {
  final VerificationRemoteDataSource remoteDataSource;
  bool _isSubmitting = false;

  VerificationProvider(this.remoteDataSource);

  bool get isSubmitting => _isSubmitting;

  Future<bool> submit(String frontId, String backId, List<String> selfies, String videoPath) async {
    _isSubmitting = true;
    notifyListeners();

    try {
      await remoteDataSource.submitVerification(
        frontId: frontId,
        backId: backId,
        selfies: selfies,
        videoPath: videoPath,
      );
      _isSubmitting = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isSubmitting = false;
      notifyListeners();
      return false;
    }
  }
}