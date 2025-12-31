import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gtlmd/common/Toast.dart';
import 'package:url_launcher/url_launcher.dart';

class UpdateVersionScreen extends StatefulWidget {
  const UpdateVersionScreen({super.key});

  @override
  State<UpdateVersionScreen> createState() => _UpdateVersionScreenState();
}

class _UpdateVersionScreenState extends State<UpdateVersionScreen> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            "New Version Available",
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 25),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "New Version Available On PlayStore Please Update For Better Experiance Thanks",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
              textAlign: TextAlign.center,
            ),
          ),
          InkWell(
            onTap: () => {successToast("Work in progress")},
            // onTap: () => launchUrl(Uri.parse('https://play.google.com/store/apps/details?id=com.greensoft.greentranserp')),
            // // launch('https://play.google.com/store/apps/details?id=com.greensoft.greentranserp'),
            // onTap: () => launchUrl(Uri.parse('https://play.google.com/store/apps/details?id=com.greensoft.gthr')),
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 20),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 2),
                  borderRadius: const BorderRadius.all(Radius.circular(15))),
              child: Text(
                "Update Now",
                style: TextStyle(color: Colors.white),
              ),
            ),
          )
        ],
      )),
    );
  }
}
