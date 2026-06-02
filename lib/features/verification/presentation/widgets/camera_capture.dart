import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

enum CaptureMode { frontId, backId, multiSelfie, livenessVideo }

class CameraCapture extends StatefulWidget {
  final CaptureMode captureMode;
  final Function(List<String> paths) onCaptureComplete;

  const CameraCapture({
    Key? key,
    required this.captureMode,
    required this.onCaptureComplete,
  }) : super(key: key);

  @override
  State<CameraCapture> createState() => _CameraCaptureState();
}

class _CameraCaptureState extends State<CameraCapture> with WidgetsBindingObserver {
  CameraController? _controller;
  List<CameraDescription>? _cameras;
  bool _isInitialized = false;
  bool _isRecording = false;
  bool _isProcessingAction = false; 
  
  int _selfieStep = 0; 
  final List<String> _capturedSelfiePaths = [];

  int _videoCountdown = 5;
  Timer? _countdownTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras == null || _cameras!.isEmpty) return;

      CameraDescription selectedCamera = _cameras!.first; 
      if (widget.captureMode == CaptureMode.multiSelfie || 
          widget.captureMode == CaptureMode.livenessVideo) {
        selectedCamera = _cameras!.firstWhere(
          (cam) => cam.lensDirection == CameraLensDirection.front,
          orElse: () => _cameras!.first,
        );
      }

      final controller = CameraController(
        selectedCamera,
        ResolutionPreset.high,
        enableAudio: widget.captureMode == CaptureMode.livenessVideo,
        imageFormatGroup: ImageFormatGroup.jpeg,
      );

      _controller = controller;
      await controller.initialize();
      
      if (!mounted) return;
      
      setState(() {
        _isInitialized = true;
      });
    } catch (e) {
      debugPrint("Camera initialization failed: $e");
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController = _controller;
    if (cameraController == null || !cameraController.value.isInitialized) return;

    if (state == AppLifecycleState.inactive) {
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initializeCamera();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _countdownTimer?.cancel();
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _capturePhoto() async {
    if (_controller == null || !_controller!.value.isInitialized || _isProcessingAction) return;
    setState(() => _isProcessingAction = true);

    try {
      final XFile photo = await _controller!.takePicture();
      
      if (widget.captureMode == CaptureMode.multiSelfie) {
        _capturedSelfiePaths.add(photo.path);
        if (_selfieStep < 2) {
          setState(() {
            _selfieStep++;
            _isProcessingAction = false;
          });
        } else {
          if (!mounted) return;
          widget.onCaptureComplete(_capturedSelfiePaths);
          Navigator.pop(context);
        }
      } else {
        if (!mounted) return;
        widget.onCaptureComplete([photo.path]);
        Navigator.pop(context);
      }
    } catch (e) {
      debugPrint("Error taking photo: $e");
      setState(() => _isProcessingAction = false);
    }
  }

  Future<void> _toggleVideoRecording() async {
    if (_controller == null || !_controller!.value.isInitialized || _isProcessingAction) return;
    if (_isRecording) {
      _stopVideo();
    } else {
      _startVideo();
    }
  }

  Future<void> _startVideo() async {
    try {
      await _controller!.startVideoRecording();
      setState(() {
        _isRecording = true;
        _videoCountdown = 5;
      });

      _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (!mounted) return;
        setState(() {
          if (_videoCountdown > 1) {
            _videoCountdown--;
          } else {
            _stopVideo();
          }
        });
      });
    } catch (e) {
      debugPrint("Error starting video: $e");
    }
  }

  Future<void> _stopVideo() async {
    _countdownTimer?.cancel();
    if (!_isRecording || _controller == null) return;

    try {
      setState(() => _isProcessingAction = true);
      final XFile video = await _controller!.stopVideoRecording();
      
      setState(() {
        _isRecording = false;
      });
      
      if (!mounted) return;
      widget.onCaptureComplete([video.path]);
      Navigator.pop(context);
    } catch (e) {
      debugPrint("Error stopping video: $e");
      setState(() {
        _isRecording = false;
        _isProcessingAction = false;
      });
    }
  }

  String _getInstructionText() {
    switch (widget.captureMode) {
      case CaptureMode.frontId:
        return "Align front side of your National ID or Passport";
      case CaptureMode.backId:
        return "Align back side of your National ID or Passport";
      case CaptureMode.multiSelfie:
        if (_selfieStep == 0) return "Look directly into the camera (Front View)";
        if (_selfieStep == 1) return "Turn your head slowly to your LEFT";
        return "Turn your head slowly to your RIGHT";
      case CaptureMode.livenessVideo:
        return _isRecording 
            ? "Blink and nod naturally! ($_videoCountdown s remaining)"
            : "Record a 5-second liveness check video";
    }
  }

  @override
@override
Widget build(BuildContext context) {
  const primaryColor = Color(0xFF030712); 
  const accentGold = Color(0xFFFFB703);   
  const cardDark = Color(0xFF1F2937);    

  if (!_isInitialized || _controller == null) {
    return const Scaffold(
      backgroundColor: primaryColor,
      body: Center(child: CircularProgressIndicator(color: accentGold)),
    );
  }

  // ==================== NEW FULL SCREEN LOADING STATE ====================
  if (_isProcessingAction) {
    return const Scaffold(
      backgroundColor: primaryColor, // Matches your dark theme color scheme
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: accentGold,
              strokeWidth: 4.0,
            ),
            SizedBox(height: 20),
            Text(
              "Verifying identity...",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
                letterSpacing: -0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
  // ========================================================================

  final mediaSize = MediaQuery.of(context).size;
  final screenWidth = mediaSize.width;
  final previewAspectRatio = _controller!.value.aspectRatio;

  return Scaffold(
    backgroundColor: primaryColor,
    appBar: AppBar(
      backgroundColor: primaryColor,
      elevation: 0,
      title: const Text(
        "Identity Verification",
        style: TextStyle(
          color: Colors.white, 
          fontSize: 17, 
          fontWeight: FontWeight.w600, 
          letterSpacing: -0.3
        ),
      ),
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 18),
        onPressed: () => Navigator.pop(context),
      ),
    ),
    body: SafeArea(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: cardDark.withOpacity(0.8),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withOpacity(0.06)),
            ),
            child: Text(
              _getInstructionText(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white, 
                fontSize: 14, 
                fontWeight: FontWeight.w500, 
                height: 1.45,
                letterSpacing: -0.1
              ),
            ),
          ),
          
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(28),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return Stack(
                      fit: StackFit.expand,
                      alignment: Alignment.center,
                      children: [
                        FittedBox(
                          fit: BoxFit.cover,
                          child: SizedBox(
                            width: screenWidth,
                            height: screenWidth * previewAspectRatio,
                            child: CameraPreview(_controller!),
                          ),
                        ),

                        // Clean structural geometry punch-hole overlay mask
                        Positioned.fill(
                          child: ClipPath(
                            clipper: InvertedCutoutClipper(
                              captureMode: widget.captureMode,
                            ),
                            child: Container(
                              color: primaryColor.withOpacity(0.75),
                            ),
                          ),
                        ),

                        Center(
                          child: _buildFramingLines(widget.captureMode, _isRecording, accentGold, mediaSize),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
          
          Container(
            padding: const EdgeInsets.symmetric(vertical: 28.0),
            child: Center(
              child: widget.captureMode == CaptureMode.livenessVideo
                  ? InkWell(
                      onTap: _toggleVideoRecording,
                      borderRadius: BorderRadius.circular(100),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: _isRecording ? Colors.redAccent : accentGold, 
                            width: 3.5
                          ),
                        ),
                        child: CircleAvatar(
                          radius: 26,
                          backgroundColor: _isRecording ? Colors.redAccent : accentGold,
                          child: Icon(
                            _isRecording ? Icons.stop_rounded : Icons.videocam_rounded, 
                            color: primaryColor, 
                            size: 26
                          ),
                        ),
                      ),
                    )
                  : InkWell(
                      onTap: _capturePhoto,
                      borderRadius: BorderRadius.circular(100),
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: accentGold, width: 3.5),
                        ),
                        child: const CircleAvatar(
                          radius: 26,
                          backgroundColor: accentGold,
                          child: Icon(
                            Icons.camera_alt_rounded, 
                            color: primaryColor, 
                            size: 24
                          ),
                        ),
                      ),
                    ),
            ),
          ),
        ],
      ),
    ),
  );
}
  Widget _buildFramingLines(CaptureMode mode, bool recording, Color gold, Size mediaSize) {
    if (mode == CaptureMode.frontId || mode == CaptureMode.backId) {
      return Container(
        width: mediaSize.width * 0.82,
        height: mediaSize.width * 0.82 * 0.63,
        decoration: BoxDecoration(
          border: Border.all(color: gold.withOpacity(0.9), width: 2),
          borderRadius: BorderRadius.circular(16),
        ),
      );
    } else {
      return Container(
        width: mediaSize.width * 0.64,
        height: mediaSize.height * 0.36,
        decoration: BoxDecoration(
          border: Border.all(
            color: recording ? Colors.redAccent.withOpacity(0.9) : gold.withOpacity(0.9), 
            width: 2
          ),
          borderRadius: BorderRadius.all(
            Radius.elliptical(mediaSize.width * 0.64, mediaSize.height * 0.36),
          ),
        ),
      );
    }
  }
}

// Fixed geometry layout clipper that operates independently of GPU BlendModes
class InvertedCutoutClipper extends CustomClipper<Path> {
  final CaptureMode captureMode;

  InvertedCutoutClipper({required this.captureMode});

  @override
  Path getClip(Size size) {
    final path = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height));

    final cutoutPath = Path();

    if (captureMode == CaptureMode.frontId || captureMode == CaptureMode.backId) {
      final cardWidth = size.width * 0.82;
      final cardHeight = size.width * 0.82 * 0.63;
      final rect = Rect.fromCenter(
        center: Offset(size.width / 2, size.height / 2),
        width: cardWidth,
        height: cardHeight,
      );
      cutoutPath.addRRect(RRect.fromRectAndRadius(rect, const Radius.circular(16)));
    } else {
      // Both dimensions are now perfectly proportional to the local bounding container size
      final ovalWidth = size.width * 0.70;   
      final ovalHeight = size.height * 0.52; // FIXED: Changed from 0.57 to 0.42
      final rect = Rect.fromCenter(
        center: Offset(size.width / 2, size.height / 2),
        width: ovalWidth,
        height: ovalHeight,
      );
      cutoutPath.addOval(rect);
    }

    // This operation cuts out the shape completely inside Flutter's widget tree
    return Path.combine(PathOperation.difference, path, cutoutPath);
  }

  @override
  bool shouldReclip(covariant InvertedCutoutClipper oldClipper) {
    return oldClipper.captureMode != captureMode;
  }
}