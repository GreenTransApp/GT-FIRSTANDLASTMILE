import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gtlmd/common/Utils.dart';
import 'package:gtlmd/common/colors.dart';
import 'package:gtlmd/common/environment.dart';
import 'package:gtlmd/pages/login/loginPage.dart';
import 'package:gtlmd/pages/login/models/loginModel.dart';
import 'package:gtlmd/pages/login/viewModel/loginViewModel.dart';
import 'package:gtlmd/service/authenticationService.dart';
import 'package:gtlmd/service/locationService/locationService.dart';

import 'firebase_options.dart';

final locationService = LocationService();
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await locationService.init();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const String _title = "First2Last Mile";

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
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
  final LoginViewModel loginViewModel = LoginViewModel();
  // final authService  = AuthenticationService();
  _goToLogin() {
    /* Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
      (route) => false
      );
 */
    debugPrint('go to login');
    Get.off(LoginPage());
    // Get.off(HomeScreen());
  }

  Future<void> userLogin(String user) async {
    Map<String, dynamic> valueMap = jsonDecode(user.trim());
    LoginModel userObj = LoginModel.fromJson(valueMap);
    savedLogin = userObj;

    Map<String, String> params = {
      "prmusername": userObj.username.toString(),
      "prmpassword": userObj.password.toString(),
      "prmappversion": ENV.appVersion,
      "prmappversiondt": ENV.appVersionDate,
      "prmdevicedt": ENV.deviceDate,
      "prmdeviceid": getUuid()
    };
    loginViewModel.loginUserAtStart(params);
  }

  _goToHomeScreen() {
/*     Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => BottomNavigator()),
        (Route<dynamic> route) => false);*/

    // Get.off(HomeScreen());
    AuthenticationService().login(context);
  }

  void setObserver() {
    loginViewModel.isErrorLiveData.stream.listen((err) {
      // if (err.toString().contains("ineternet connection")) {
      _goToLogin();
      // }
    });
  }

  @override
  void initState() {
    super.initState();

    setObserver();

    authService.storageGet(ENV.loginPrefTag).then((login) => {
          ScreenDimension.width = MediaQuery.of(context).size.width,
          ScreenDimension.height = MediaQuery.of(context).size.height,
          if (login == null)
            {
              // navigate to login screen
              debugPrint('Login data is null'),
              _goToLogin()
            }
          else
            {
              // todo Later
              authService.storageGet(ENV.userPrefTag).then((user) => {
                    if (user == null)
                      {debugPrint('User data is null'), _goToLogin()}
                    else
                      {
                        loginViewModel.loginResponseLiveData.stream
                            .listen((resp) {
                          if (resp.commandstatus == 1) {
                            debugPrint('Going to HomeScreen');
                            getUserData();
                            _goToHomeScreen();
                          } else {
                            debugPrint('Going to HomeScreen');
                            _goToHomeScreen();
                          }
                        }),
                        debugPrint('User login'),
                        userLogin(login)
                      }
                  })
            }
        });
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
