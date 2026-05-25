import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gtlmd/pages/imageEditor/domain/repositories/image_editing_repo.dart';

class ImageEditorController extends ChangeNotifier {
  final ImageEditingRepository _repository;

  ImageEditorController(
      {required ImageEditingRepository repository, File? initialImage})
      : _repository = repository,
        _currentImage = initialImage;

  File? _currentImage;
  bool _isLoading = false;

  File? get currentImage => _currentImage;
  bool get isLoading => _isLoading;

  void _setLoading(bool val) {
    _isLoading = val;
    notifyListeners();
  }

  Future<void> cropCurrentImage() async {
    if (_currentImage == null) return;
    _setLoading(true);
    try {
      final File? cropped =
          await _repository.cropImage(sourcePath: _currentImage!.path);
      if (cropped != null) {
        _currentImage = cropped;
        notifyListeners();
      }
    } catch (error) {
      debugPrint("Error in cropCurrentImage: $error");
    } finally {
      _setLoading(false);
    }
  }

  Future<void> selectAndEditImage() async {
    _setLoading(true);
    try {
      final File? picked = await _repository.pickImageFromGallery();
      if (picked == null) return;

      _currentImage = picked;
      notifyListeners();

      final File? cropped =
          await _repository.cropImage(sourcePath: picked.path);
      if (cropped != null) {
        _currentImage = cropped;
        notifyListeners();
      }
    } catch (error) {
      _setLoading(false);
      debugPrint("Error in selectAndEditImage: $error");
    } finally {
      _setLoading(false);
    }
  }
}
