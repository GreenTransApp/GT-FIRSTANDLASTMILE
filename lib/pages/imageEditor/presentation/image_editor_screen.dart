import 'package:flutter/material.dart';
import 'package:gtlmd/pages/imageEditor/presentation/image_editor_controller.dart';

class ImageEditorScreen extends StatefulWidget {
  final ImageEditorController controller;
  const ImageEditorScreen({super.key, required this.controller});

  @override
  State<ImageEditorScreen> createState() => _ImageEditorScreenState();
}

class _ImageEditorScreenState extends State<ImageEditorScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.controller.cropCurrentImage();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Image'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () =>
                Navigator.pop(context, widget.controller.currentImage),
          ),
        ],
      ),
      body: Center(
        child: ListenableBuilder(
          listenable: widget.controller,
          builder: (context, _) {
            if (widget.controller.isLoading) {
              return const CircularProgressIndicator();
            }
            if (widget.controller.currentImage == null) {
              return const Text('No image selected.');
            }
            return Image.file(widget.controller.currentImage!);
          },
        ),
      ),
    );
  }
}
