import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:gtlmd/common/Utils.dart';
import 'package:gtlmd/common/colors.dart';
import 'package:gtlmd/common/imagePicker/alertBoxImagePicker.dart';
import 'package:gtlmd/common/toast.dart';

class MultiImageBottomSheet extends StatefulWidget {
  final List<String> initialImageUrls;
  MultiImageBottomSheet({super.key, required this.initialImageUrls});

  @override
  State<MultiImageBottomSheet> createState() => _MultiImageBottomSheetState();
}

class _MultiImageBottomSheetState extends State<MultiImageBottomSheet> {
  late List<String> imageUrls;
  bool isSelectionMode = false;
  Set<int> selectedIndexes = {};

  @override
  void initState() {
    super.initState();
    imageUrls = List<String>.from(widget.initialImageUrls);
  }

  void _onLongPress(int index) {
    setState(() {
      isSelectionMode = true;
      selectedIndexes.add(index);
    });
  }

  void _onImageTap(int index) {
    if (isSelectionMode) {
      setState(() {
        if (selectedIndexes.contains(index)) {
          selectedIndexes.remove(index);
          if (selectedIndexes.isEmpty) isSelectionMode = false;
        } else {
          selectedIndexes.add(index);
        }
      });
    } else {
      showDialogWithImage(context, imageUrls[index], isLocal: true);
    }
  }

  void _deleteSelected() {
    setState(() {
      // Remove images in reverse order to avoid index issues
      final toRemove = selectedIndexes.toList()..sort((a, b) => b.compareTo(a));
      for (var idx in toRemove) {
        imageUrls.removeAt(idx);
      }
      selectedIndexes.clear();
      isSelectionMode = false;
    });
  }

  void _cancelSelection() {
    setState(() {
      selectedIndexes.clear();
      isSelectionMode = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: isSelectionMode
          ? AppBar(
              leading: IconButton(
                icon: const Icon(Icons.close_outlined),
                onPressed: _cancelSelection,
              ),
              title: Text('${selectedIndexes.length} selected'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed:
                      selectedIndexes.isNotEmpty ? _deleteSelected : null,
                ),
              ],
            )
          : AppBar(
              automaticallyImplyLeading: false,
              leading: null,
              actions: [
                TextButton(
                  onPressed: () {
                    Get.back(result: imageUrls); // or selected images
                  },
                  child: const Text(
                    "Done",
                    style: TextStyle(color: CommonColors.appBarColor),
                  ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showImagePickerDialog(context, (file) async {
            if (file != null) {
              debugPrint('Multi File data: ${file.path}');
              setState(() {
                if (file.path.isNotEmpty) {
                  imageUrls.add(file.path);
                }
              });
            } else {
              failToast("File not selected");
            }
          });
        },
        child: const Icon(Icons.add_outlined),
      ),
      body: imageUrls.isEmpty
          ? const Center(child: Text("No Images"))
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (imageUrls.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    child: Text(
                      "Images (${imageUrls.length})",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 200,
                        childAspectRatio: 1,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      itemCount: imageUrls.length,
                      itemBuilder: (context, index) {
                        final isSelected = selectedIndexes.contains(index);
                        return GestureDetector(
                          onLongPress: () => _onLongPress(index),
                          onTap: () => _onImageTap(index),
                          child: Stack(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: isSelected
                                          ? Colors.blue
                                          : Colors.grey.shade400,
                                      width: isSelected ? 2.5 : 1.5),
                                  borderRadius: BorderRadius.circular(14),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey
                                          .withAlpha((0.15 * 255).round()),
                                      blurRadius: 6,
                                      offset: const Offset(2, 2),
                                    ),
                                  ],
                                  color: Colors.white,
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: AspectRatio(
                                    aspectRatio: 1,
                                    child: Image.file(
                                      File(imageUrls[index]),
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Image.asset(
                                          'assets/images/profile.png',
                                          fit: BoxFit.cover,
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              // Checkbox for selection mode
                              if (isSelectionMode)
                                Positioned(
                                  bottom: 8,
                                  left: 8,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          color: Colors.blue, width: 2),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: Icon(
                                        isSelected
                                            ? Icons.check_circle
                                            : Icons.radio_button_unchecked,
                                        color: isSelected
                                            ? Colors.blue
                                            : Colors.grey,
                                        size: 24,
                                      ),
                                    ),
                                  ),
                                ),
                              // Single delete button (only when not in selection mode)
                              if (!isSelectionMode)
                                Positioned(
                                  bottom: 8,
                                  right: 8,
                                  child: Material(
                                    color: Colors.white,
                                    shape: const CircleBorder(),
                                    elevation: 2,
                                    child: InkWell(
                                      customBorder: const CircleBorder(),
                                      onTap: () {
                                        setState(() {
                                          imageUrls.removeAt(index);
                                        });
                                      },
                                      child: const Padding(
                                        padding: EdgeInsets.all(6.0),
                                        child: Icon(Icons.delete,
                                            color: Colors.red, size: 22),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

showMultiImageBottomSheetDialog(BuildContext context, List<String> imageUrls) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    isDismissible: false,
    enableDrag: false,
    backgroundColor: Colors.transparent, // <-- Add this line
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(24),
        topRight: Radius.circular(24),
      ),
    ),
    builder: (context) {
      final height = MediaQuery.of(context).size.height * 0.7;
      return ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        child: SizedBox(
          height: height,
          child: MultiImageBottomSheet(initialImageUrls: imageUrls),
        ),
      );
    },
  );
}

/* 
void showDialogWithImage(BuildContext context, String? imagePath) {
  // String defaultImagePath =
  //     'https://greentrans.in:446/GreenTransApp/imageplace.jpg';
  String actualImagePath = imagePath!;

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        contentPadding: EdgeInsets.zero,
        content: Stack(
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.sizeOf(context).width * 0.04,
                  vertical: MediaQuery.sizeOf(context).height * 0.08),
              width: double.infinity,
              child: Image.file(
                File(actualImagePath),
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Image.file(File(actualImagePath), fit: BoxFit.cover);
                },
              ),
            ),
            Positioned(
              top: 10,
              right: 10,
              child: IconButton(
                icon: Icon(
                  Icons.close,
                  color: CommonColors.dangerColor,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        ),
      );
    },
  );
}

 */
