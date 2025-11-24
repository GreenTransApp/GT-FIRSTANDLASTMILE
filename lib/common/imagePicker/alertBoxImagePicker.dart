import 'dart:io';

import 'package:flutter/material.dart';
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
        title: const Text('Select Image'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              const Divider(
                thickness: 0.5,
                color: Colors.grey,
              ),
              const SizedBox(
                height: 20,
              ),

              InkWell(
                onTap: () async {
                  // onPressed.call("Other Testing");
                  Navigator.pop(context);
                  onPressed.call(await chooseGalleryImg());
                  // chooseGalleryImg();
                },
                child: const Row(children: [
                  Icon(Icons.image),
                  SizedBox(
                    width: 20,
                  ),
                  Text("Select image from gallery")
                ]),
              ),
              const SizedBox(
                height: 40,
              ),

              InkWell(
                onTap: () async {
                  // onPressed.call("Testing");
                  onPressed.call(await chooseCameraImg());
                  // chooseCameraImg();
                  Navigator.pop(context);
                },
                child: const Row(children: [
                  Icon(Icons.camera_alt),
                  SizedBox(
                    width: 20,
                  ),
                  Text("Click image from camera")
                ]),
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
