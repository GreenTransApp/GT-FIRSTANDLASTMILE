import 'dart:io';

import 'package:gtlmd/pages/imageEditor/domain/repositories/image_editing_repo.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ImageEditingRepositoryImpl implements ImageEditingRepository {
  final ImagePicker _picker = ImagePicker();
  final ImageCropper _cropper = ImageCropper();
  @override
  Future<File?> captureImageFromCamera() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.camera, imageQuality: 85);
    return pickedFile != null ? File(pickedFile.path) : null;
  }

  @override
  Future<File?> cropImage({required String sourcePath}) async {
    final CroppedFile? croppedFile = await _cropper
        .cropImage(sourcePath: sourcePath, compressQuality: 90, uiSettings: [
      AndroidUiSettings(toolbarTitle: "Crop Image", lockAspectRatio: false),
      IOSUiSettings(title: "Crop Image", aspectRatioLockEnabled: false)
    ]);
    return croppedFile != null ? File(croppedFile.path) : null;
  }

  @override
  Future<File?> pickImageFromGallery() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 85);
    return pickedFile != null ? File(pickedFile.path) : null;
  }
}
