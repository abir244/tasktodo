
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/document_verification_state.dart';
import '../viewmodel/document_verification_notifier.dart';
import 'confirm_identity_screen.dart';

class ScanIdCardScreen extends ConsumerStatefulWidget {
  const ScanIdCardScreen({super.key});

  @override
  ConsumerState<ScanIdCardScreen> createState() => _ScanIdCardScreenState();
}

class _ScanIdCardScreenState extends ConsumerState<ScanIdCardScreen>
    with WidgetsBindingObserver {
  CameraController? _controller;
  List<CameraDescription> _cameras = [];
  bool _initializing = true;
  bool _flashOn = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initCamera();
  }

  Future<void> _initCamera() async {
    try {
      _cameras = await availableCameras();
      final rear = _cameras.firstWhere(
            (c) => c.lensDirection == CameraLensDirection.back,
        orElse: () => _cameras.isNotEmpty ? _cameras.first : throw 'No camera',
      );

      final controller = CameraController(
        rear,
        ResolutionPreset.high,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.yuv420,
      );

      await controller.initialize();
      await controller.setFlashMode(FlashMode.off);

      if (!mounted) return;
      setState(() {
        _controller = controller;
        _initializing = false;
        _flashOn = false;
      });
    } catch (e) {
      setState(() {
        _initializing = false;
      });
      debugPrint('Camera init error: $e');
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState stateLifecycle) {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) return;

    if (stateLifecycle == AppLifecycleState.inactive ||
        stateLifecycle == AppLifecycleState.paused) {
      controller.pausePreview();
    } else if (stateLifecycle == AppLifecycleState.resumed) {
      controller.resumePreview();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _toggleFlash() async {
    if (_controller == null) return;
    try {
      _flashOn = !_flashOn;
      await _controller!.setFlashMode(_flashOn ? FlashMode.torch : FlashMode.off);
      if (mounted) setState(() {});
    } catch (e) {
      debugPrint('Flash toggle error: $e');
    }
  }

  Future<void> _capture() async {
    final notifier = ref.read(documentVerificationProvider.notifier);
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) return;

    try {
      final file = await controller.takePicture();
      await notifier.captureFrontFromPath(file.path);
      await controller.pausePreview();
    } catch (e) {
      debugPrint('Capture error: $e');
      notifier.markInvalidPhoto();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(documentVerificationProvider);
    final notifier = ref.read(documentVerificationProvider.notifier);

    Color frameColor;
    String helperText;
    List<Widget> actionButtons = [];

    switch (state.status) {
      case ScanStatus.invalidPhoto:
        frameColor = const Color(0xFFFF5252); // red
        helperText = 'The photo is invalid. Please try again.';
        actionButtons = [
          _secondaryBtn('Retake', onPressed: () async {
            notifier.retake();
            await _controller?.resumePreview();
          }),
        ];
        break;
      case ScanStatus.ageFail:
        frameColor = const Color(0xFFFF9800); // orange
        helperText = "Your age is below the required minimum.";
        actionButtons = [
          _secondaryBtn('Close', onPressed: () => Navigator.pop(context)),
        ];
        break;
      case ScanStatus.success:
        frameColor = const Color(0xFF00C853); // green
        helperText = 'Great! The photo looks good.';
        actionButtons = [
          _secondaryBtn('Retake', onPressed: () async {
            notifier.retake();
            await _controller?.resumePreview();
          }),
          const SizedBox(width: 12),
          _primaryBtn('Confirm', onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ConfirmIdentityScreen()),
            );
          }),
        ];
        break;
      case ScanStatus.analyzing:
        frameColor = const Color(0xFFFFC107); // amber
        helperText = 'Analyzing the photo...';
        actionButtons = [];
        break;
      case ScanStatus.idle:
      default:
        frameColor = const Color(0xFF3A3A3A); // neutral
        helperText = 'Place your ID card in the frame below.';
        actionButtons = [];
        break;
    }

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D12),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
            children: [
              Row(
                children: const [
                  Text(
                    'Scan ID Card',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Spacer(),
                ],
              ),
              const SizedBox(height: 12),

              const Text(
                'Take a photo of the front of your ID card',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                helperText,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 20),

              // Camera area / captured image
              Expanded(
                child: Center(
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 320, maxHeight: 220),
                    decoration: BoxDecoration(
                      color: const Color(0xFF131318),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: frameColor, width: 3),
                    ),
                    clipBehavior: Clip.hardEdge,
                    child: _buildCaptureArea(state),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Bottom actions
              if (state.status == ScanStatus.idle) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _roundIcon(
                      _flashOn ? Icons.flash_on : Icons.flash_off,
                      onTap: _toggleFlash,
                    ),
                    const SizedBox(width: 24),
                    _captureButton(onTap: _capture),
                    const SizedBox(width: 24),
                    _roundIcon(Icons.photo_library_outlined, onTap: () {
                      // Optional: gallery import (image_picker)
                    }),
                  ],
                ),
              ] else if (state.status == ScanStatus.analyzing) ...[
                const SizedBox(
                  height: 50,
                  child: Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFFFFC107),
                      strokeWidth: 2,
                    ),
                  ),
                ),
              ] else ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: actionButtons,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCaptureArea(DocumentVerificationState state) {
    final showPreview = state.status == ScanStatus.idle ||
        state.status == ScanStatus.analyzing;

    if (showPreview) {
      if (_initializing || _controller == null || !_controller!.value.isInitialized) {
        return const Center(
          child: CircularProgressIndicator(color: Colors.white24, strokeWidth: 1.5),
        );
      }
      return CameraPreview(_controller!);
    }

    if (state.capturedImagePath.isNotEmpty) {
      final file = File(state.capturedImagePath);
      return Image.file(file, fit: BoxFit.cover);
    }

    return const Center(
      child: Icon(Icons.credit_card, color: Colors.white24, size: 72),
    );
  }

  Widget _roundIcon(IconData icon, {required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(28),
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: const Color(0xFF131318),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: const Color(0xFF3A3A3A)),
        ),
        child: Icon(icon, color: Colors.white60),
      ),
    );
  }

  Widget _captureButton({required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: const Color(0xFFFFC107),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 6),
          ],
        ),
        child: const Icon(Icons.camera_alt, color: Colors.black),
      ),
    );
  }

  // ======= FIX: add the missing helper buttons =======

  Widget _primaryBtn(String label, {required VoidCallback onPressed}) {
    return SizedBox(
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFFC107),
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 0,
        ),
        onPressed: onPressed,
        child: Text(label),
      ),
    );
  }

  Widget _secondaryBtn(String label, {required VoidCallback onPressed}) {
    return SizedBox(
      height: 50,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.white,
          side: const BorderSide(color: Color(0xFF3A3A3A)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onPressed: onPressed,
        child: Text(label),
      ),
    );
  }
}

