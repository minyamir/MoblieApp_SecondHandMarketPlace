import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../provider/verification_provider.dart';
import '../widgets/camera_capture.dart';

class VerificationScreen extends StatelessWidget {
  final String userId;

  const VerificationScreen({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Shared consistent premium palette tokens.
    const Color bgCanvas = Color(0xFF0B0C0E);       // Match dark deep home background
    const Color cardSurface = Color(0xFF14161A);    // Secondary container panel 
    const Color brandGold = Color(0xFFF3C02B);      // Bybit Premium Dynamic Accent Gold
    const Color textMuted = Color(0xFF707A8A);      // Clean readable secondary typography

    return Scaffold(
      backgroundColor: bgCanvas,
      appBar: AppBar(
        backgroundColor: bgCanvas,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Identity Verification',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: BlocConsumer<VerificationCubit, VerificationState>(
        listener: (context, state) {
          if (state is VerificationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Verification materials securely routed.'),
                backgroundColor: Colors.green,
                behavior: SnackBarBehavior.floating,
              ),
            );
            Navigator.pop(context);
          } else if (state is VerificationFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage),
                backgroundColor: Colors.redAccent,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        builder: (context, state) {
          String? frontId;
          String? backId;
          List<String> selfies = [];
          String? videoPath;

          if (state is VerificationFormUpdating) {
            frontId = state.frontIdPath;
            backId = state.backIdPath;
            selfies = state.selfiePaths;
            videoPath = state.livenessVideoPath;
          }

          // Evaluate actual active state matrix step
          int currentStep = 1;
          if (frontId != null) currentStep = 2;
          if (frontId != null && backId != null) currentStep = 3;
          if (frontId != null && backId != null && selfies.length >= 3) currentStep = 4;
          
          bool allClear = frontId != null && backId != null && selfies.length >= 3 && videoPath != null;

          return Stack(
            children: [
              Column(
                children: [
                  // --- BYBIT STYLE ALL-IN-ONE STEP TRACKER HEADER ---
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                    color: cardSurface,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildHeaderStepNode(1, "ID Front", currentStep >= 1, currentStep == 1, brandGold),
                        _buildStepLineConnector(currentStep > 1, brandGold),
                        _buildHeaderStepNode(2, "ID Back", currentStep >= 2, currentStep == 2, brandGold),
                        _buildStepLineConnector(currentStep > 2, brandGold),
                        _buildHeaderStepNode(3, "Selfie (3)", currentStep >= 3, currentStep == 3, brandGold),
                        _buildStepLineConnector(currentStep > 3, brandGold),
                        _buildHeaderStepNode(4, "Liveness", currentStep >= 4, currentStep == 4, brandGold),
                      ],
                    ),
                  ),

                  // --- CENTRAL SYSTEM DISPLAY PLATFORM ---
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "KYC Security Framework",
                            style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold, letterSpacing: 1),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Complete the required localized escrow merchant verification protocol steps below to unlock your trade volume nodes.",
                            style: TextStyle(color: textMuted, fontSize: 13, height: 1.4),
                          ),
                          const SizedBox(height: 28),

                          // Target Viewport Box depending on active step
                          _buildActiveStepWorkspace(
                            context: context,
                            currentStep: currentStep,
                            frontId: frontId,
                            backId: backId,
                            selfies: selfies,
                            videoPath: videoPath,
                            brandGold: brandGold,
                            cardSurface: cardSurface,
                            textMuted: textMuted,
                          ),
                        ],
                      ),
                    ),
                  ),

                  // --- PERSISTENT DYNAMIC SUBMIT SECTION ---
                  Container(
                    padding: const EdgeInsets.only(left: 24, right: 24, top: 16, bottom: 36),
                    decoration: BoxDecoration(
                      color: cardSurface,
                      borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: brandGold,
                          foregroundColor: Colors.black,
                          elevation: allClear ? 2 : 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          disabledBackgroundColor: const Color(0xFF22252C),
                        ),
                        onPressed: (allClear && state is! VerificationSubmitting)
                            ? () => context.read<VerificationCubit>().submitIdentityVerification(userId)
                            : null,
                        child: Text(
                          allClear ? 'Submit Authentication Payload' : 'Complete All Verification Steps Above',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: allClear ? Colors.black : textMuted,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              // --- GLOBAL SECURITY ENCRYPTION OVERLAY SHEET ---
              if (state is VerificationSubmitting)
                Container(
                  color: Colors.black.withOpacity(0.9),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 48,
                          height: 48,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(brandGold),
                            strokeWidth: 3.5,
                          ),
                        ),
                        const SizedBox(height: 28),
                        const Text(
                          'ENCRYPTING BIOMETRIC PAYLOAD',
                          style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 1.5),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Streaming data layers securely to HaHu Core Node infrastructure...',
                          style: TextStyle(color: textMuted, fontSize: 12),
                        )
                      ],
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  // --- WIDGET HELPER ARCHITECTURE BLOCK ---

  static Widget _buildHeaderStepNode(int index, String label, bool isCleared, bool isActive, Color gold) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isCleared ? (isActive ? gold : gold.withOpacity(0.15)) : const Color(0xFF22252C),
            border: Border.all(
              color: isActive ? gold : (isCleared ? gold.withOpacity(0.4) : Colors.transparent),
              width: 1.5,
            ),
          ),
          child: Center(
            child: isCleared && !isActive
                ? Icon(Icons.check_rounded, color: gold, size: 16)
                : Text(
                    index.toString(),
                    style: TextStyle(
                      color: isActive ? Colors.black : (isCleared ? gold : const Color(0xFF5F6975)),
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.white : (isCleared ? gold.withOpacity(0.8) : const Color(0xFF5F6975)),
            fontSize: 11,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        )
      ],
    );
  }

  static Widget _buildStepLineConnector(bool active, Color gold) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(bottom: 16, left: 4, right: 4),
        height: 1.5,
        color: active ? gold.withOpacity(0.5) : const Color(0xFF22252C),
      ),
    );
  }

  static Widget _buildActiveStepWorkspace({
    required BuildContext context,
    required int currentStep,
    String? frontId,
    String? backId,
    required List<String> selfies,
    String? videoPath,
    required Color brandGold,
    required Color cardSurface,
    required Color textMuted,
  }) {
    // Logic selector showing specific task options inside the central dashboard window
    switch (currentStep) {
      case 1:
        return _buildWorkspacePanel(
          context: context,
          title: "National ID / Passport Profile (Front)",
          desc: "Position the front face of your documentary credentials inside the window metrics. Keep text strings legible.",
          path: frontId,
          icon: Icons.badge_outlined,
          gold: brandGold,
          surface: cardSurface,
          muted: textMuted,
          onAction: () => _navigateToCamera(context, CaptureMode.frontId, (paths) {
            context.read<VerificationCubit>().updateFrontId(paths.first);
          }),
        );
      case 2:
        return _buildWorkspacePanel(
          context: context,
          title: "National ID / Passport Profile (Back)",
          desc: "Flip your documentation over to reveal signature data and verification strip zones clearly.",
          path: backId,
          icon: Icons.vignette_outlined,
          gold: brandGold,
          surface: cardSurface,
          muted: textMuted,
          onAction: () => _navigateToCamera(context, CaptureMode.backId, (paths) {
            context.read<VerificationCubit>().updateBackId(paths.first);
          }),
        );
      case 3:
        return _buildWorkspacePanel(
          context: context,
          title: "Multi-Angle Biometric Arrays",
          desc: "Secure sequential structural frames. Captured target depth metrics: (${selfies.length} / 3)",
          fileList: selfies,
          icon: Icons.face_retouching_natural_rounded,
          gold: brandGold,
          surface: cardSurface,
          muted: textMuted,
          onAction: selfies.length >= 3 ? null : () => _navigateToCamera(context, CaptureMode.multiSelfie, (paths) {
            for (String path in paths) {
              context.read<VerificationCubit>().addSelfie(path);
            }
          }),
        );
      case 4:
      default:
        return _buildWorkspacePanel(
          context: context,
          title: "Liveness Biometric Matrix",
          desc: videoPath != null ? "Liveness profile compiled successfully." : "Execute on-screen real-time physical indicators (blink, turn head, nod).",
          path: videoPath,
          isVideo: true,
          icon: Icons.videocam_outlined,
          gold: brandGold,
          surface: cardSurface,
          muted: textMuted,
          onAction: () => _navigateToCamera(context, CaptureMode.livenessVideo, (paths) {
            context.read<VerificationCubit>().updateLivenessVideo(paths.first);
          }),
        );
    }
  }

  static Widget _buildWorkspacePanel({
    required BuildContext context,
    required String title,
    required String desc,
    String? path,
    List<String>? fileList,
    bool isVideo = false,
    required IconData icon,
    required Color gold,
    required Color surface,
    required Color muted,
    required VoidCallback? onAction,
  }) {
    bool assetLoaded = (path != null) || (fileList != null && fileList.isNotEmpty);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF1E222A), width: 1),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Icon(icon, color: assetLoaded ? Colors.green : gold, size: 44),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            desc,
            style: TextStyle(color: muted, fontSize: 12, height: 1.4),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 28),
          
          // Render Dynamic Asset Box inside dashboard window
          if (assetLoaded) ...[
            Container(
              height: 160,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.green.withOpacity(0.3)),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(11),
                child: isVideo
                    ? const Center(child: Icon(Icons.check_circle, color: Colors.green, size: 48))
                    : (fileList != null
                        ? ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: fileList.length,
                            itemBuilder: (_, i) => Container(
                              width: 120,
                              margin: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                image: DecorationImage(image: FileImage(File(fileList[i])), fit: BoxFit.cover),
                              ),
                            ),
                          )
                        : Image.file(File(path!), fit: BoxFit.cover)),
              ),
            ),
            const SizedBox(height: 16),
            TextButton.icon(
              icon: Icon(Icons.refresh_rounded, color: gold, size: 16),
              label: Text("Retake Frame Asset", style: TextStyle(color: gold, fontSize: 13, fontWeight: FontWeight.bold)),
              onPressed: onAction,
            )
          ] else
            SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: gold.withOpacity(0.4)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                icon: Icon(Icons.photo_camera_rounded, color: gold, size: 18),
                label: Text("Initiate Digital Capture", style: TextStyle(color: gold, fontWeight: FontWeight.bold, fontSize: 14)),
                onPressed: onAction,
              ),
            ),
        ],
      ),
    );
  }

  static void _navigateToCamera(BuildContext context, CaptureMode mode, Function(List<String> paths) callback) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CameraCapture(
          captureMode: mode,
          onCaptureComplete: callback,
        ),
      ),
    );
  }
}
