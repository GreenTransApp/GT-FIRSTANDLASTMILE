import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:gtlmd/pages/attendance/attendanceScreen.dart';
import 'package:get/get.dart';
class Imagecapture extends StatefulWidget {
  const Imagecapture({super.key, required this.camera});

  final CameraDescription camera;

  @override
  State<Imagecapture> createState() => _ImagecaptureState();
}

class _ImagecaptureState extends State<Imagecapture> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(widget.camera, ResolutionPreset.medium);

    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Take a picture')),
      // You must wait until the controller is initialized before displaying the
      // camera preview. Use a FutureBuilder to display a loading spinner until the
      // controller has finished initializing.
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the Future is complete, display the preview.
            return CameraPreview(_controller);
          } else {
            // Otherwise, display a loading indicator.
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        // Provide an onPressed callback.
        onPressed: () async {
          // Take the Picture in a try / catch block. If anything goes wrong,
          // catch the error.
          try {
            // Ensure that the camera is initialized.
            await _initializeControllerFuture;

            // Attempt to take a picture and get the file `image`
            // where it was saved.
            final image = await _controller.takePicture();

            if (!context.mounted) return;

            // If the picture was taken, display it on a new screen.
            String path = await /* Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => DisplayPictureScreen(
                  // Pass the automatically generated path to
                  // the DisplayPictureScreen widget.
                  imagePath: image.path,
                ),
              ),
            ); */ Get.to(DisplayPictureScreen(imagePath: image.path));

            debugPrint("Image Path screen 2: $path");
            // if(path != null && path != '') {
              // Navigator.pop(context, path);
              Get.back(result: path);
            /* } else {
            
            } */
          } catch (e) {
            // If an error occurs, log the error to the console.
            debugPrint(e.toString());
          }
        },
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}

class DisplayPictureScreen extends StatelessWidget {
  const DisplayPictureScreen({super.key, required this.imagePath});
  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Captured Image')),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.file(File(imagePath)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 40,
            children: [
              IconButton(
                onPressed: ()  {
                  Get.back(result: imagePath);
                  // Navigator.pop(context, imagePath);
                },
                icon: const Icon(
                  Icons.check,
                  size: 25,
                ),
                iconSize: 40,
                color: Colors.green,
              ),
              IconButton(
                onPressed: ()  { /* Navigator.pop(context); */ Get.back(); },
                icon: const Icon(
                  Icons.cancel_outlined,
                  size: 25,
                ),
                iconSize: 40,
                color: Colors.red,
              ),
            ],
          )
        ],
      ),
    );
  }
}
