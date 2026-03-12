import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:camera/camera.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:face_verification/face_verification.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gtlmd/common/Colors.dart';
import 'package:gtlmd/common/Environment.dart';
import 'package:gtlmd/common/Utils.dart';
import 'package:gtlmd/common/toast.dart';
import 'package:gtlmd/design_system/size_config.dart';
import 'package:gtlmd/pages/login/models/loginModel.dart';
import 'package:permission_handler/permission_handler.dart';

class FaceRegistration extends StatefulWidget {
  @override
  _FaceRegistrationState createState() => _FaceRegistrationState();
}

class _FaceRegistrationState extends State<FaceRegistration> {
  CameraController? _cameraController;
  late FaceDetector _faceDetector;
  final storage = FlutterSecureStorage();
//  final storageService = StorageService();
  bool isProcessing = false;
  List<Face> _faces = [];
  bool _eyesPreviouslyClosed = false;
  int _blinkCount = 0;
  final int requiredBlinks = 3;

  @override
  void initState() {
    super.initState();
    FaceVerification.instance.init().then((_) {
      print("FaceVerification initialized successfully!");
    }).catchError((e) {
      print("Error initializing FaceVerification: $e");
    });

    _faceDetector = FaceDetector(
      options: FaceDetectorOptions(
        enableClassification: true,
        enableTracking: true,
        performanceMode: FaceDetectorMode.accurate,
      ),
    );

    _initialize();
  }

  Future<void> _initialize() async {
    if (!(await _requestCameraPermission())) return;
    await _initializeCamera();
  }

  Future<bool> _requestCameraPermission() async {
    var status = await Permission.camera.status;
    if (!status.isGranted) {
      status = await Permission.camera.request();
    }
    return status.isGranted;
  }

  @override
  void dispose() {
    _cameraController?.stopImageStream();
    _cameraController?.dispose();
    _faceDetector.close();
    super.dispose();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final frontCamera = cameras.firstWhere(
      (camera) => camera.lensDirection == CameraLensDirection.front,
    );
    _cameraController = CameraController(frontCamera, ResolutionPreset.medium);

    await _cameraController!.initialize();
    await _cameraController!.startImageStream(_processCameraImage);
    setState(() {});
  }

  Uint8List convertCameraImage(Map<String, dynamic> params) {
    List<List<int>> planes = params['planes'];
    List<int> bytes = planes.expand((p) => p).toList();
    return Uint8List.fromList(bytes);
  }

  void _processCameraImage(CameraImage image) async {
    if (isProcessing) return;
    isProcessing = true;

    try {
      final inputImage = InputImage.fromBytes(
        bytes: Uint8List.fromList(image.planes.expand((p) => p.bytes).toList()),
        metadata: InputImageMetadata(
          size: Size(image.width.toDouble(), image.height.toDouble()),
          rotation: InputImageRotation.rotation0deg,
          format: InputImageFormat.nv21,
          bytesPerRow: image.planes[0].bytesPerRow,
        ),
      );

      final faces = await _faceDetector.processImage(inputImage);
      _faces = faces;

      if (faces.isNotEmpty) {
        Face face = faces.first;
        _checkBlink(face);

        if (_blinkCount >= requiredBlinks) {
          // await storageService.deleteFaceRegistered();
          await _registerFace();
          _blinkCount = 0;
        }
      }

      setState(() {});
    } catch (e) {
      print("Error processing frame: $e");
    }

    isProcessing = false;
  }

  void _checkBlink(Face face) {
    double left = face.leftEyeOpenProbability ?? 1;
    double right = face.rightEyeOpenProbability ?? 1;

    bool eyesClosed = left < 0.3 && right < 0.3;
    bool eyesOpen = left > 0.7 && right > 0.7;

    if (eyesClosed) _eyesPreviouslyClosed = true;

    if (_eyesPreviouslyClosed && eyesOpen) {
      _eyesPreviouslyClosed = false;
      _blinkCount++;
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text("Blink detected: $_blinkCount/$requiredBlinks")),
      // );
      setState(() {});
    }
  }

  Future<void> _registerFace() async {
    try {
      await FaceVerification.instance.init();

      final picture = await _cameraController?.takePicture();
      if (picture == null) return;

      String registeredId =
          await FaceVerification.instance.registerFromImagePath(
        id: savedUser.username.toString(),
        imagePath: picture.path,
        imageId: 'face',
        replace: true,
      );

      // await storage.write(
      //   key: "face_registered",
      //   value: registeredId,
      // );
      // authService.storagePush(ENV.faceLoginPrefTag, registeredId!);

      LoginModel faceLoginCredsModel = LoginModel(
          username: savedLogin.username,
          password: savedLogin.password,
          faceid: registeredId);
      authService.storagePush(
          ENV.faceLoginPrefTag, jsonEncode(faceLoginCredsModel));
      print("Face registered successfully with ID: $registeredId");

      if (!mounted) return;
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text("Face Registered Successfully")),
      // );
      successToast("Face Registered Successfully");
      Get.back();
    } catch (e) {
      print("Error registering face: $e");
      if (!mounted) return;
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text("Face registration failed")),
      // );
      failToast("Face registration failed");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: CommonColors.colorPrimary,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: CommonColors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Face Registration',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: CommonColors.white,
          ),
        ),
      ),
      body: Stack(
        children: [
          Center(child: CameraPreview(_cameraController!)),
          Positioned.fill(
            child: Center(
              child: Container(
                width: SizeConfig.screenWidth * 0.7,
                height: SizeConfig.screenHeight * 0.4,
                decoration: BoxDecoration(
                  border: Border.all(color: CommonColors.white!, width: 3),
                  borderRadius: BorderRadius.all(Radius.circular(40)),
                ),
              ),
            ),
          ),
          // CustomPaint(painter: FacePainter(_faces)),
          Positioned(
            bottom: 50,
            left: 50,
            right: 50,
            child: Column(
              children: [
                ClipRRect(
                    borderRadius: BorderRadius.circular(SizeConfig.smallRadius),
                    child: LinearProgressIndicator(
                      value: _blinkCount /
                          requiredBlinks, // ensures the value is between 0 and 1
                      backgroundColor:
                          CommonColors.white!.withAlpha((0.2 * 255).toInt()),
                      valueColor:
                          AlwaysStoppedAnimation(CommonColors.colorPrimary),
                      minHeight: 6,
                    )),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "${_blinkCount}/${requiredBlinks}",
                    style: TextStyle(
                        color: CommonColors.White, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.start,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class FacePainter extends CustomPainter {
  final List<Face> faces;
  FacePainter(this.faces);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.green
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    for (final face in faces) {
      canvas.drawRect(face.boundingBox, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
