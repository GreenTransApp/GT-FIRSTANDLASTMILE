import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:face_verification/face_verification.dart';
import 'package:gtlmd/common/Colors.dart';
import 'package:gtlmd/common/Environment.dart';
import 'package:gtlmd/common/Utils.dart';
import 'package:gtlmd/common/alertBox/loadingAlertWithCancel.dart';
import 'package:gtlmd/common/selectionBottomSheets/divisionSelection.dart';
import 'package:gtlmd/common/toast.dart';
import 'package:gtlmd/design_system/size_config.dart';
import 'package:gtlmd/pages/login/forgotPassword.dart';
import 'package:gtlmd/pages/login/models/LoginCredsModel.dart';
import 'package:gtlmd/pages/login/models/enums.dart';
import 'package:gtlmd/pages/login/models/loginModel.dart';
import 'package:gtlmd/pages/login/viewModel/loginProvider.dart';
import 'package:gtlmd/service/authenticationService.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

class FaceLogin extends StatefulWidget {
  @override
  _FaceLoginState createState() => _FaceLoginState();
}

class _FaceLoginState extends State<FaceLogin> {
  CameraController? _cameraController;
  late FaceDetector _faceDetector;
  final storage = FlutterSecureStorage();
  late LoadingAlertService loadingAlertService;
  bool isProcessing = false;
  List<Face> _faces = [];
  bool _eyesPreviouslyClosed = false;
  int _blinkCount = 0;
  final int requiredBlinks = 3;
  Timer? _timer;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadingAlertService = LoadingAlertService(context: context);
      _initAsync();
    });
  }

  Future<void> _initAsync() async {
    // Initialize face_verification
    await FaceVerification.instance.init();

    // Initialize ML Kit face detector
    _faceDetector = FaceDetector(
      options: FaceDetectorOptions(
        enableClassification: true,
        enableTracking: true,
        performanceMode: FaceDetectorMode.accurate,
      ),
    );

    // Initialize front camera
    final cameras = await availableCameras();
    final frontCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front);
    _cameraController = CameraController(frontCamera, ResolutionPreset.medium);
    await _cameraController?.initialize();

    // Start image stream
    await _cameraController?.startImageStream(_processCameraImage);

    setState(() {});
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
          await _verifyFace(face);
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
    double left = face.leftEyeOpenProbability ?? 1.0;
    double right = face.rightEyeOpenProbability ?? 1.0;

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

  Future<void> _verifyFace(Face face) async {
    try {
      // String? storedFaceId = await storage.read(key: ENV.faceLoginPrefTag);
      // String? storedFaceId =
      //     await AuthenticationService().storageGet(ENV.faceLoginPrefTag);
      LoginCredsModel creds = await getFaceLoginCreds();
      String? storedFaceId = creds.faceid;
      print(storedFaceId);
      if (storedFaceId == null) {
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text("No registered face. Please register first.")),
        // );
        failToast("No registered face. Please register first.");

        return;
      }

      final picture = await _cameraController?.takePicture();
      if (picture == null) return;

      // Verify face using face_verification
      String? matchedId = await FaceVerification.instance.verifyFromImagePath(
        imagePath: picture.path,
      );

      if (matchedId == storedFaceId) {
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text("Authorized User")),
        // );
        // successToast("Authorized User");
        _userLogin();
      } else {
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text("Not Authorized")),
        // );
        failToast("Not Authorized");
      }
    } catch (e) {
      print("Error during verification: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Verification failed")),
      );
    }
  }

  void _handleStateChange(
      LoginStatus status, String? error, LoginProvider provider) {
    if (status == LoginStatus.loading) {
      loadingAlertService.showLoading();
    } else {
      loadingAlertService.hideLoading();
    }

    if (status == LoginStatus.error && error != null) {
      failToast(error);
      provider.clearError();
    }

    if (status == LoginStatus.success) {
      if (provider.otpResponse != null) {
        // OTP received, already handled in extracting logic if needed or just wait for it
        // Original code logged: extractLoginOtp(validateotpModel.smstext!)
      } else if (provider.loginResponse != null) {
        final resp = provider.loginResponse!;
        LoginModel loginCredsModel =
            LoginModel(username: resp.username, password: resp.password);
        authService.storagePush(
            ENV.loginCredsPrefTag, jsonEncode(loginCredsModel));
        _validateUserLogin(resp.companyid.toString(), resp.username.toString());
      } else if (provider.userResponse != null) {
        if (provider.userResponse!.commandstatus == 1) {
          final userResp = provider.userResponse!;
          // Stop timer after successful validation
          _timer?.cancel();
          _timer = null;

          // _navigate();
          Map<String, String> params = {
            "prmcompanyid": savedLogin.companyid.toString(),
            "prmbranchcode": userResp.loginbranchcode.toString(),
            "prmusername": userResp.username.toString(),
          };
          provider
              .clearUserResponse(); // Clear to prevent repeated bottom sheet
          showDivisionSelectionBottomSheet(context, "Select Division",
              (division) {
            // authService.login(context);
            _validateDivision(
                savedLogin.companyid.toString(),
                userResp.usercode.toString(),
                userResp.loginbranchcode.toString(),
                division.accdivisionid.toString(),
                userResp.sessionid.toString());
            provider.selectedDivision = division;
          }, params);
        }
      } else if (provider.divisionResponse != null) {
        if (provider.divisionResponse!.commandstatus == 1) {
          authService.storagePush(
              ENV.divisionPrefTag, jsonEncode(provider.selectedDivision));
          savedUser.logindivisionid = provider.selectedDivision!.accdivisionid;
          savedUser.logindivisionname =
              provider.selectedDivision!.accdivisionname;
          // authService.login(context);
          provider
              .clearDivisionResponse(); // Clear to prevent repeated navigation
          _navigate();
        } else {
          failToast(provider.divisionResponse!.commandmessage ??
              "Division validation failed");
        }
      }
    }
  }

  void _navigate() {
    switch (authenticationFlow) {
      case AuthenticationFlow.forgotPassword:
        Get.off(() => const Forgotpassword());
        break;
      case AuthenticationFlow.loginWithOtp:
        authService.login(context);
        break;
    }
  }

  Future<void> _userLogin() async {
    String deviceId = await getDeviceId();
    LoginCredsModel creds = await getLoginCreds();
    Map<String, String> params = {
      "prmusername": creds.username.toString(),
      "prmpassword": creds.password.toString(),
      "prmappversion": ENV.appVersion,
      "prmappversiondt": ENV.appVersionDate,
      "prmdevicedt": ENV.appVersionDate,
      // "prmdeviceid": getUuid()
      "prmdeviceid": deviceId
    };
    context.read<LoginProvider>().loginUser(params);
  }

  Future<void> _validateUserLogin(
      String companyIdVal, String usernameVal) async {
    String deviceId = await getDeviceId();
    Map<String, String> params = {
      "prmconstring": companyIdVal,
      "prmusername": usernameVal,
      "prmappversion": ENV.appVersion,
      "prmappversiondt": ENV.appVersionDate,
      // "prmdeviceid": getUuid()
      "prmdeviceid": deviceId
    };
    context.read<LoginProvider>().validateUserForLogin(params);
  }

  Future<void> _validateDivision(String companyId, String usercode,
      String branchcode, String divisionid, String sessionid) async {
    Map<String, String> params = {
      "connstring": companyId,
      "prmusercode": usercode,
      "prmbranchcode": branchcode,
      "prmdivisionid": divisionid,
      // "prmdeviceid": getUuid()
      "prmsessionid": sessionid
    };
    context.read<LoginProvider>().validateDivision(params);
  }

  @override
  Widget build(BuildContext context) {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Consumer<LoginProvider>(
      builder: (context, provider, child) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _handleStateChange(provider.status, provider.errorMessage, provider);
        });
        return Scaffold(
          appBar: AppBar(
            backgroundColor: CommonColors.colorPrimary,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios, color: CommonColors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: Text(
              'Face Login',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: CommonColors.white,
              ),
            ),
          ),
          body: Stack(
            alignment: Alignment.center,
            children: [
              Center(
                  child: SizedBox(
                      height: SizeConfig.screenHeight,
                      width: SizeConfig.screenWidth,
                      child: CameraPreview(_cameraController!))),
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
//          CustomPaint(
//         painter: FacePainter(
//           _faces,
//           Size(
//             _cameraController!.value.previewSize!.height,
//             _cameraController!.value.previewSize!.width,
//           ),
//           isFrontCamera: true,
//         ),
//   child: Container(), // full overlay
// ),
              Positioned(
                bottom: 50,
                left: 50,
                right: 50,
                child: Column(
                  children: [
                    ClipRRect(
                        borderRadius:
                            BorderRadius.circular(SizeConfig.smallRadius),
                        child: LinearProgressIndicator(
                          value: _blinkCount /
                              requiredBlinks, // ensures the value is between 0 and 1
                          backgroundColor: CommonColors.white!
                              .withAlpha((0.2 * 255).toInt()),
                          valueColor:
                              AlwaysStoppedAnimation(CommonColors.colorPrimary),
                          minHeight: 6,
                        )),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "${_blinkCount}/${requiredBlinks}",
                        style: TextStyle(
                            color: CommonColors.White,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.start,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _faceDetector.close();
    super.dispose();
  }
}

class FacePainter extends CustomPainter {
  final List<Face> faces;
  final Size imageSize; // size of the camera image
  final bool isFrontCamera;

  FacePainter(this.faces, this.imageSize, {this.isFrontCamera = true});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.green
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    double scaleX = size.width / imageSize.width;
    double scaleY = size.height / imageSize.height;

    for (final face in faces) {
      double left = face.boundingBox.left * scaleX;
      double top = face.boundingBox.top * scaleY;
      double right = face.boundingBox.right * scaleX;
      double bottom = face.boundingBox.bottom * scaleY;

      // Mirror for front camera
      if (isFrontCamera) {
        double tempLeft = left;
        left = size.width - right;
        right = size.width - tempLeft;
      }

      canvas.drawRect(Rect.fromLTRB(left, top, right, bottom), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
