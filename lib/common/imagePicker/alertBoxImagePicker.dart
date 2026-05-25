import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gtlmd/design_system/size_config.dart';
import 'package:gtlmd/pages/imageEditor/data/image_editing_repository_impl.dart';
import 'package:gtlmd/pages/imageEditor/presentation/image_editor_controller.dart';
import 'package:gtlmd/pages/imageEditor/presentation/image_editor_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

final ImagePicker _picker = ImagePicker();
XFile? _image;

//
// XFile? getImage(){
//   if(_image != null) {
//     return _image;
//   }
//   return null;
// }
// void fun(){
//   if(_isLoading==true){
//
//   }
//   else{
//     CircularProgressIndicator();
//   }
// }

Future<void> showImagePickerDialog(
    BuildContext context, void Function(XFile?) onPressed) async {
  // _isLoading=true;
  showDialog<void>(
    context: context,
    barrierDismissible: true, // user must tap button!
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        title: Text(
          'SELECT IMAGE',
          style: TextStyle(fontSize: SizeConfig.largeTextSize),
          textAlign: TextAlign.center,
        ),
        content: SingleChildScrollView(
          child: Column(
            children: [
              const Divider(
                thickness: 0.5,
                color: Colors.grey,
              ),
              SizedBox(
                height: SizeConfig.mediumVerticalSpacing,
              ),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () async {
                        // onPressed.call("Other Testing");
                        Navigator.pop(dialogContext);
                        onPressed.call(await chooseGalleryImg(context));
                        // chooseGalleryImg();
                      },
                      child: Column(children: [
                        Icon(
                          Icons.photo_library,
                          size: SizeConfig.extraLargeIconSize,
                        ),
                        SizedBox(
                          height: SizeConfig.mediumVerticalSpacing,
                        ),
                        Text(
                          "GALLERY",
                          style: TextStyle(fontSize: SizeConfig.smallTextSize),
                        )
                      ]),
                    ),
                  ),
                  SizedBox(
                    width: SizeConfig.largeVerticalSpacing,
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () async {
                        // onPressed.call("Testing");
                        Navigator.pop(dialogContext);
                        onPressed.call(await chooseCameraImg(context));
                        // chooseCameraImg();
                      },
                      child: Column(children: [
                        Icon(
                          Icons.camera_alt,
                          size: SizeConfig.extraLargeIconSize,
                        ),
                        SizedBox(
                          height: SizeConfig.mediumVerticalSpacing,
                        ),
                        Text(
                          "CAMERA",
                          style: TextStyle(fontSize: SizeConfig.smallTextSize),
                        )
                      ]),
                    ),
                  ),
                ],
              ),

              //   _image==null ?Container():Image.file(File(_image!.path))
              //
            ],
          ),
        ),
      );
    },
  );
}

Future<XFile?> chooseGalleryImg(BuildContext context) async {
  var galleryImg = await _picker.pickImage(source: ImageSource.gallery);
  _image = galleryImg;
  return askForEdit(context, _image);
}

Future<XFile?> askForEdit(BuildContext context, XFile? path) async {
  if (path == null) return null;

  XFile? result = await showDialog<XFile?>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Do you want to edit image?"),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end, // Better alignment
              children: [
                TextButton(
                  child: const Text("Yes"),
                  onPressed: () async {
                    final ImageEditorController ctrl = ImageEditorController(
                        repository: ImageEditingRepositoryImpl(),
                        initialImage: File(path.path));
                    final File? editedFile =
                        await Get.to(() => ChangeNotifierProvider.value(
                              value: ctrl,
                              child: ImageEditorScreen(controller: ctrl),
                            ));

                    if (context.mounted) {
                      Navigator.pop(context,
                          editedFile != null ? XFile(editedFile.path) : path);
                    }
                  },
                ),
                const SizedBox(
                  width: 8,
                ),
                TextButton(
                  child: const Text("No"),
                  onPressed: () {
                    Navigator.pop(context, path);
                  },
                )
              ],
            )
          ],
        );
      });
  return result ?? path;
}

Future<XFile?> chooseCameraImg(BuildContext context) async {
  var cameraImg = await _picker.pickImage(source: ImageSource.camera);
  _image = cameraImg;
  return askForEdit(context, _image);
}
