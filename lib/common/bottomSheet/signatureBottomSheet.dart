import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:gtlmd/common/Toast.dart';
import 'package:gtlmd/common/Utils.dart';
import 'package:gtlmd/common/colors.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:signature/signature.dart';
import 'package:get/get.dart';
// import 'package:image_gallery_saver/image_gallery_saver.dart';

class SignatureBottomSheet extends StatefulWidget {
  final void Function(String, String) callBack;
  const SignatureBottomSheet({Key? key, required this.callBack})
      : super(key: key);

  @override
  State<SignatureBottomSheet> createState() => _SignatureBottomSheetState();
}

class _SignatureBottomSheetState extends State<SignatureBottomSheet> {
  // You can manage your internal state here
  final signatureController = SignatureController(
      penColor: CommonColors.appBarColor,
      penStrokeWidth: 3,
      exportPenColor: CommonColors.appBarColor,
      exportBackgroundColor: CommonColors.white);

  Uint8List? signature;

  @override
  void dispose() {
    signatureController.dispose();
    super.dispose();
  }

  // Future<String?> saveImageToExternalStorage(
  //     Uint8List imageBytes, String fileName) async {
  //   // Request storage permission
  //   var status = await Permission.storage.request();
  //   if (!status.isGranted) {
  //     return null;
  //   }

  //   Directory? externalDir;

  //   // Get external storage directory (usually /storage/emulated/0/)
  //   if (Platform.isAndroid) {
  //     externalDir =
  //         Directory('/storage/emulated/0/MyAppImages'); // Custom folder
  //     if (!await externalDir.exists()) {
  //       await externalDir.create(recursive: true);
  //     }
  //   } else {
  //     // iOS doesn't allow writing to external storage like this
  //     return null;
  //   }

  //   final filePath = '${externalDir.path}/$fileName';
  //   File file = File(filePath);
  //   await file.writeAsBytes(imageBytes);

  //   return filePath;
  // }

  Future<String> saveImageToLocal(Uint8List imageBytes, String fileName) async {
    // Get the app's document directory
    try {
      final directory = await getApplicationDocumentsDirectory();

      // Create the full path
      final imagePath = '${directory.path}/$fileName';

      // Create the file and write the image bytes
      final imageFile = File(imagePath);
      await imageFile.writeAsBytes(imageBytes);
      return imagePath;
    } catch (err) {
      failToast('Error: $err');
    }
    return "";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // Optional drag handle
            Container(
              width: 40,
              height: 5,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const Text(
              'Signature',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            // Your stateful content here
            Expanded(
              child: Center(
                  child: Signature(
                controller: signatureController,
                width: double.infinity,
                height: 400,
                backgroundColor: CommonColors.white!,
              )),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                    onPressed: () async {
                      signatureController.undo();
                    },
                    icon: const Icon(Icons.undo),
                    label: const Text("Undo")),
                ElevatedButton.icon(
                    onPressed: () async {
                      signatureController.clear();
                    },
                    icon: const Icon(Icons.clear),
                    label: const Text("Clear"))
              ],
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                    onPressed: () async {
                      signatureController.redo();
                    },
                    icon: const Icon(Icons.redo),
                    label: const Text("Redo")),
                ElevatedButton(
                  onPressed: () async {
                    signature = await signatureController.toPngBytes();

                    if (signature != null) {
                      final status = await Permission.storage.status;
                      if (!status.isGranted ||
                          status.isDenied ||
                          status.isPermanentlyDenied) {
                        await Permission.storage.request();
                      }
                      final time =
                          DateTime.now().toIso8601String().replaceAll('.', ':');

                      // final result = await ImageGallerySaver.saveImage(
                      //   signature!,
                      //   name: 'signature$time',
                      // );

                      String path = await saveImageToLocal(
                          signature!, 'signature$time.png');

                      if (path.isNotEmpty) {
                        // successToast("File Saved");
                        signatureController.clear();
                        widget.callBack(path, convertFilePathToBase64(path));
                        Get.back();
                        // Navigator.pop(context, path);
                      } else {
                        failToast("Something went wrong. Please try again");
                      }

                      // if (result['isSuccess']) {
                      //   if (!context.mounted) return;
                      //   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      //       content: Text(
                      //     'Signature Saved',
                      //     style: TextStyle(fontSize: 24),
                      //   )));
                      //   signatureController.clear();
                      // }
                    } else {
                      failToast("Please enter your signature");
                    }

                    setState(() {});
                  },
                  child: const Text("Save"),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

Future<void> showSignatureBottomSheet(
    BuildContext context, void Function(String, String) callbackFun) async {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      final height = MediaQuery.of(context).size.height * 0.7;

      return SizedBox(
        height: height,
        child: SignatureBottomSheet(
          callBack: callbackFun,
        ),
      );
    },
  );
}
