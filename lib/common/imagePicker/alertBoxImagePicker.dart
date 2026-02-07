import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gtlmd/design_system/size_config.dart';
import 'package:image_picker/image_picker.dart';

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
    builder: (BuildContext context) {
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
                        Navigator.pop(context);
                        onPressed.call(await chooseGalleryImg());
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
                        onPressed.call(await chooseCameraImg());
                        // chooseCameraImg();
                        Navigator.pop(context);
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

Future<XFile?> chooseGalleryImg() async {
  var galleryImg = await _picker.pickImage(source: ImageSource.gallery);
  _image = galleryImg;
  return _image;
}

Future<XFile?> chooseCameraImg() async {
  var cameraImg = await _picker.pickImage(source: ImageSource.camera);
  _image = cameraImg;
  return _image;
}
