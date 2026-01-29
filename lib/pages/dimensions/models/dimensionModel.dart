import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DimensionModel {
  String unitType;
  int pieces;
  double length;
  double breadth;
  double height;
  int vWeight;
  int cft;
  bool canAddMore;
  // ContentModel content;

  // Add controllers for UI fields
  final TextEditingController unitTypeController;
  final TextEditingController piecesController;
  final TextEditingController lengthController;
  final TextEditingController breadthController;
  final TextEditingController heightController;
  final TextEditingController cftController;
  final TextEditingController vWeightController;

  DimensionModel({
    required this.unitType,
    required this.pieces,
    required this.length,
    required this.breadth,
    required this.height,
    required this.vWeight,
    required this.cft,
    required this.canAddMore,
    // required this.content
    // required this.contentModel,
  })  : unitTypeController = TextEditingController(text: unitType),
        piecesController = TextEditingController(text: pieces.toString()),
        lengthController = TextEditingController(text: length.toString()),
        breadthController = TextEditingController(text: breadth.toString()),
        heightController = TextEditingController(text: height.toString()),
        cftController = TextEditingController(text: cft.toString()),
        vWeightController = TextEditingController(text: vWeight.toString());

  void syncFromControllers() {
    unitType = unitTypeController.text.trim();
    pieces = int.tryParse(piecesController.text) ?? pieces;
    length = double.tryParse(lengthController.text) ?? length;
    breadth = double.tryParse(breadthController.text) ?? breadth;
    height = double.tryParse(heightController.text) ?? height;
    cft = int.tryParse(cftController.text) ?? cft;
    vWeight = int.tryParse(vWeightController.text) ?? vWeight;
  }

  void disposeControllers() {
    unitTypeController.dispose();
    piecesController.dispose();
    lengthController.dispose();
    breadthController.dispose();
    heightController.dispose();
    cftController.dispose();
    vWeightController.dispose();
  }
}
