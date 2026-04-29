import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../provider/verification_provider.dart';

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({super.key});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final ImagePicker _picker = ImagePicker();
  String? _frontId, _backId, _selfieFront, _selfieLeft, _selfieRight, _videoPath;

  Future<void> _pickImage(String type) async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        if (type == 'front') _frontId = image.path;
        if (type == 'back') _backId = image.path;
        if (type == 'sFront') _selfieFront = image.path;
        if (type == 'sLeft') _selfieLeft = image.path;
        if (type == 'sRight') _selfieRight = image.path;
      });
    }
  }

  Future<void> _recordVideo() async {
    final XFile? video = await _picker.pickVideo(
      source: ImageSource.camera,
      maxDuration: const Duration(seconds: 6),
    );
    if (video != null) setState(() => _videoPath = video.path);
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<VerificationProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Account Verification")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ListTile(title: const Text("Front ID"), trailing: _frontId != null ? const Icon(Icons.check) : null, onTap: () => _pickImage('front')),
            ListTile(title: const Text("Back ID"), trailing: _backId != null ? const Icon(Icons.check) : null, onTap: () => _pickImage('back')),
            const Divider(),
            ListTile(title: const Text("Selfie (Front)"), trailing: _selfieFront != null ? const Icon(Icons.check) : null, onTap: () => _pickImage('sFront')),
            ListTile(title: const Text("Selfie (Left)"), trailing: _selfieLeft != null ? const Icon(Icons.check) : null, onTap: () => _pickImage('sLeft')),
            ListTile(title: const Text("Selfie (Right)"), trailing: _selfieRight != null ? const Icon(Icons.check) : null, onTap: () => _pickImage('sRight')),
            const Divider(),
            ListTile(title: const Text("Liveness Video (6s)"), trailing: _videoPath != null ? const Icon(Icons.check) : null, onTap: _recordVideo),
            const SizedBox(height: 20),
            provider.isSubmitting
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: () async {
                      if (_frontId != null && _backId != null && _selfieFront != null && _videoPath != null) {
                        final success = await provider.submit(_frontId!, _backId!, [_selfieFront!, _selfieLeft!, _selfieRight!], _videoPath!);
                        if (success && mounted) Navigator.pop(context);
                      }
                    },
                    child: const Text("Submit for Verification"),
                  ),
          ],
        ),
      ),
    );
  }
}