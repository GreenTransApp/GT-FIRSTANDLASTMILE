import 'dart:convert';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:gtlmd/common/Utils.dart';
import 'package:gtlmd/common/colors.dart';
import 'package:gtlmd/common/environment.dart';
import 'package:gtlmd/design_system/size_config.dart';
import 'package:gtlmd/optionMenu/stickerPrinting/stickerProvider.dart';
import 'package:gtlmd/pages/login/loginPage.dart';
import 'package:gtlmd/pages/login/models/loginModel.dart';
import 'package:gtlmd/service/authenticationService.dart';
import 'package:gtlmd/service/locationService/locationService.dart';

import 'firebase_options.dart';

import 'package:provider/provider.dart';
import 'package:gtlmd/pages/login/viewModel/loginProvider.dart';
import 'package:gtlmd/pages/bookingList/bookingListProvider.dart';
import 'package:gtlmd/pages/bookingWithEWayBill/bookingProvider.dart';

final locationService = LocationService();
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await locationService.init();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginProvider()),
        ChangeNotifierProvider(create: (_) => BookingListProvider()),
        ChangeNotifierProvider(create: (_) => BookingProvider()),
        ChangeNotifierProvider(create: (_) => StickerPrintingProvider()),
      ],
      child: const MyApp(),
    ),
  );
  if (Platform.isIOS) {
    requestIosLocationPermission();
  }
}

Future<void> requestIosLocationPermission() async {
  bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    await Geolocator.openLocationSettings();
  }

  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
  }

  if (permission == LocationPermission.deniedForever) {
    await Geolocator.openAppSettings();
  }

  print('iOS Location Permission: $permission');
  // Optional: Start tracking after permission
  if (permission == LocationPermission.always ||
      permission == LocationPermission.whileInUse) {
    // call your LocationService().startService(...)
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const String _title = "First2Last Mile";

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return const GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: _title,
      home: MyStatefulWidget(),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({super.key});

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  // Removed local LoginViewModel

  _goToLogin() {
    debugPrint('go to login');
    Get.off(() => const LoginPage());
  }

  Future<void> userLogin(String user) async {
    Map<String, dynamic> valueMap = jsonDecode(user.trim());
    LoginModel userObj = LoginModel.fromJson(valueMap);
    savedLogin = userObj;
    String deviceId = await getDeviceId();
    Map<String, String> params = {
      "prmusername": userObj.username.toString(),
      "prmpassword": userObj.password.toString(),
      "prmappversion": ENV.appVersion,
      "prmappversiondt": ENV.appVersionDate,
      "prmdevicedt": ENV.deviceDate,
      // "prmdeviceid": getUuid()
      "prmdeviceid": deviceId
    };

    // Access provider and call login
    context.read<LoginProvider>().loginUser(params);
  }

  _goToHomeScreen() {
    AuthenticationService().login(context);
  }

  void setObserver() {
    // We can use the provider to observe state changes
    final loginProvider = context.read<LoginProvider>();

    loginProvider.addListener(_loginStateListener);
  }

  void _loginStateListener() {
    final loginProvider = context.read<LoginProvider>();

    if (loginProvider.status == LoginStatus.error) {
      _goToLogin();
    } else if (loginProvider.status == LoginStatus.success) {
      if (loginProvider.loginResponse?.commandstatus == 1) {
        debugPrint('Going to HomeScreen');
        getUserData();
        _goToHomeScreen();
      } else {
        debugPrint('Login failed but status success (re-check logic)');
        _goToHomeScreen(); // Following original flow
      }
    }
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setObserver();

      authService.storageGet(ENV.loginPrefTag).then((login) {
        ScreenDimension.width = MediaQuery.of(context).size.width;
        ScreenDimension.height = MediaQuery.of(context).size.height;
        if (login == null) {
          debugPrint('Login data is null');
          _goToLogin();
        } else {
          authService.storageGet(ENV.userPrefTag).then((user) {
            if (user == null) {
              debugPrint('User data is null');
              _goToLogin();
            } else {
              debugPrint('User login');
              userLogin(login);
            }
          });
        }
      });
    });
  }

  @override
  void dispose() {
    // Safely remove listener if context is still valid or use a different approach
    // In MyStatefulWidget (Splash screen basically), it might be destroyed soon.
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CommonColors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircularProgressIndicator(
              color: CommonColors.colorPrimary,
            )
          ],
        ),
      ),
    );
  }
}
