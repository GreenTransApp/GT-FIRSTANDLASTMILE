import 'dart:io';

abstract class ImageEditingRepository {
  Future<File?> captureImageFromCamera();
  Future<File?> pickImageFromGallery();
  Future<File?> cropImage({required String sourcePath});
}
