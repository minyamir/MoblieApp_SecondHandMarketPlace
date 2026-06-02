import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/verification.dart';
import '../../domain/usecases/submit_verification.dart';

// ==========================================
// 1. THE VERIFICATION STATES
// ==========================================
abstract class VerificationState {}

class VerificationInitial extends VerificationState {}

class VerificationFormUpdating extends VerificationState {
  final String? frontIdPath;
  final String? backIdPath;
  final List<String> selfiePaths; 
  final String? livenessVideoPath;

  VerificationFormUpdating({
    this.frontIdPath,
    this.backIdPath,
    this.selfiePaths = const [],
    this.livenessVideoPath,
  });

  VerificationFormUpdating copyWith({
    String? frontIdPath,
    String? backIdPath,
    List<String>? selfiePaths,
    String? livenessVideoPath,
  }) {
    return VerificationFormUpdating(
      frontIdPath: frontIdPath ?? this.frontIdPath,
      backIdPath: backIdPath ?? this.backIdPath,
      selfiePaths: selfiePaths ?? this.selfiePaths,
      livenessVideoPath: livenessVideoPath ?? this.livenessVideoPath,
    );
  }
}

class VerificationSubmitting extends VerificationState {}

class VerificationSuccess extends VerificationState {
  final Verification verification;
  VerificationSuccess(this.verification);
}

class VerificationFailure extends VerificationState {
  final String errorMessage;
  VerificationFailure(this.errorMessage);
}

// ==========================================
// 2. THE VERIFICATION CUBIT CONTROLLER
// ==========================================
class VerificationCubit extends Cubit<VerificationState> {
  final SubmitVerification submitVerification;

  VerificationCubit({required this.submitVerification}) : super(VerificationInitial());

  // --- LOCAL FORM TRACKING METHODS ---

  void updateFrontId(String path) {
    final currentState = state is VerificationFormUpdating 
        ? (state as VerificationFormUpdating) 
        : VerificationFormUpdating();
    emit(currentState.copyWith(frontIdPath: path));
  }

  void updateBackId(String path) {
    final currentState = state is VerificationFormUpdating 
        ? (state as VerificationFormUpdating) 
        : VerificationFormUpdating();
    emit(currentState.copyWith(backIdPath: path));
  }

  void addSelfie(String path) {
    final currentState = state is VerificationFormUpdating 
        ? (state as VerificationFormUpdating) 
        : VerificationFormUpdating();
    
    final updatedSelfies = List<String>.from(currentState.selfiePaths)..add(path);
    emit(currentState.copyWith(selfiePaths: updatedSelfies));
  }

  void updateLivenessVideo(String path) {
    final currentState = state is VerificationFormUpdating 
        ? (state as VerificationFormUpdating) 
        : VerificationFormUpdating();
    emit(currentState.copyWith(livenessVideoPath: path));
  }

  // --- BACKEND SUBMISSION PIPELINE ---

  Future<void> submitIdentityVerification(String userId) async {
    if (state is! VerificationFormUpdating) {
      emit(VerificationFailure("Form asset references are completely empty."));
      return;
    }

    final form = state as VerificationFormUpdating;

    if (form.frontIdPath == null || 
        form.backIdPath == null || 
        form.selfiePaths.length < 3 || 
        form.livenessVideoPath == null) {
      emit(VerificationFailure("Please ensure Front ID, Back ID, 3 Selfies, and Liveness video are captured."));
      return;
    }

    emit(VerificationSubmitting());

    try {
      final result = await submitVerification(
        userId: userId,
        frontIdPath: form.frontIdPath!,
        backIdPath: form.backIdPath!,
        selfiePaths: form.selfiePaths,
        livenessVideoPath: form.livenessVideoPath!,
      );
      emit(VerificationSuccess(result));
    } catch (error) {
      emit(VerificationFailure(error.toString()));
    }
  }
}