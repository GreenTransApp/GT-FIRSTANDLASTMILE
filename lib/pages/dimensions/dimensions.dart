import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:get/state_manager.dart';
import 'package:gtlmd/common/Colors.dart';
import 'package:gtlmd/common/Toast.dart';
import 'package:gtlmd/common/Utils.dart';
import 'package:gtlmd/design_system/device_type.dart';
import 'package:gtlmd/design_system/size_config.dart';
import 'package:gtlmd/pages/bookingWithEWayBill/bookingWithEwayBill.dart';
import 'package:gtlmd/pages/bookingWithEWayBill/models/grDetailsResponse.dart';
import 'package:gtlmd/pages/dimensions/dimensionCard.dart';
import 'package:gtlmd/pages/dimensions/models/dimensionModel.dart';
import 'package:gtlmd/pages/pickup/model/serviceTypeModel.dart';

class DimensionScreen extends StatefulWidget {
  final int pckgs;
  final bool isCft;
  final ServiceTypeModel selectedServiceType;
  final String? pieces;
  final String? length;
  final String? breadth;
  final String? height;
  final String? vweight;
  final String? cft;

  DimensionScreen({
    super.key,
    required this.pckgs,
    required this.isCft,
    required this.selectedServiceType,
    this.pieces,
    this.length,
    this.breadth,
    this.height,
    this.vweight,
    this.cft,
  });

  @override
  State<DimensionScreen> createState() => _DimensionScreenState();
}

class _DimensionScreenState extends State<DimensionScreen> {
  bool canAddMore = true;
  final List<DimensionModel> _dimensions = []; // Start empty or with data

  @override
  void initState() {
    super.initState();
    _initializeDimensions();
  }

  void _initializeDimensions() {
    if (widget.pieces != null && widget.pieces!.isNotEmpty) {
      List<String> piecesList =
          widget.pieces!.split(',').where((e) => e.isNotEmpty).toList();
      List<String> lengthsList =
          widget.length!.split(',').where((e) => e.isNotEmpty).toList();
      List<String> breadthsList =
          widget.breadth!.split(',').where((e) => e.isNotEmpty).toList();
      List<String> heightsList =
          widget.height!.split(',').where((e) => e.isNotEmpty).toList();
      List<String> vWeightsList =
          widget.vweight!.split(',').where((e) => e.isNotEmpty).toList();
      List<String> cftList =
          widget.cft!.split(',').where((e) => e.isNotEmpty).toList();

      for (int i = 0; i < piecesList.length; i++) {
        _dimensions.add(DimensionModel(
          unitType: 'C', // Default to CM, adjust if needed
          pieces: int.tryParse(piecesList[i]) ?? 0,
          length: double.tryParse(lengthsList[i]) ?? 0,
          breadth: double.tryParse(breadthsList[i]) ?? 0,
          height: double.tryParse(heightsList[i]) ?? 0,
          vWeight: int.tryParse(vWeightsList[i]) ?? 0,
          cft: int.tryParse(cftList[i]) ?? (widget.isCft ? 10 : 0),
          canAddMore: true,
        ));
      }
    }

    if (_dimensions.isEmpty) {
      _dimensions.add(DimensionModel(
          unitType: 'C',
          pieces: 0,
          length: 0,
          breadth: 0,
          height: 0,
          vWeight: 0,
          cft: 10,
          canAddMore: true));
    }
  }

  void _addDimension() {
    setState(() {
      _dimensions.add(DimensionModel(
          unitType: 'C',
          pieces: 0,
          length: 0,
          breadth: 0,
          height: 0,
          cft: 0,
          vWeight: 0,
          canAddMore: canAddMore));
    });
  }

  void _removeDimension(int index) {
    setState(() {
      _dimensions.removeAt(index);

      // Re-number dimensions after removal
      for (int i = 0; i < _dimensions.length; i++) {
        // _dimensions[i] = i + 1;
      }
    });
  }

  changePieces(int index) {
    calculate(index);
  }

  calculatePckgs(int index) {
    double totalPieces = 0;
    for (var element in _dimensions) {
      totalPieces += element.pieces;
    }
    if (totalPieces > widget.pckgs) {
      failToast("Total pieces cannot be greater than packages");
      // _dimensions[index].pieces = 0;
      _dimensions[index].piecesController.text = "0";
      _dimensions[index].syncFromControllers();
      // return;
    }

    if (totalPieces == widget.pckgs) {
      for (var element in _dimensions) {
        element.canAddMore = false;
      }
    } else if (totalPieces < widget.pckgs) {
      for (var element in _dimensions) {
        element.canAddMore = true;
      }
    }
    setState(() {});
  }

  changeLength(int index) {
    calculate(index);
  }

  changeBreadth(int index) {
    calculate(index);
  }

  changeHeight(int index) {
    calculate(index);
  }

  changeCft(int index) {
    calculate(index);
  }

  changeVWeight(int index) {
    calculate(index);
  }

  void validateAndSubmit() {
    for (int i = 0; i < _dimensions.length; i++) {
      final dim = _dimensions[i];
      if (dim.piecesController.text.trim().isEmpty) {
        failToast("Pieces is required in Dimension ${i + 1}");
        return;
      }
      if (dim.lengthController.text.trim().isEmpty) {
        failToast("Length is required in Dimension ${i + 1}");
        return;
      }
      if (dim.breadthController.text.trim().isEmpty) {
        failToast("Breadth is required in Dimension ${i + 1}");
        return;
      }
      if (dim.heightController.text.trim().isEmpty) {
        failToast("Height is required in Dimension ${i + 1}");
        return;
      }
      if (dim.cftController.text.trim().isEmpty) {
        failToast("CFT is required in Dimension ${i + 1}");
        return;
      }
      if (dim.vWeightController.text.trim().isEmpty) {
        failToast("Vol Weight is required in Dimension ${i + 1}");
        return;
      }
    }

    double totalPieces = 0;
    int totalVWeight = 0;

    for (var dim in _dimensions) {
      dim.syncFromControllers();
      totalPieces += dim.pieces;
      totalVWeight += dim.vWeight;
    }

    if (totalPieces != widget.pckgs) {
      failToast(
          "Total pieces ($totalPieces) must be equal to packages (${widget.pckgs})");
      return;
    }

    String pieces = "",
        length = "",
        breadth = "",
        height = "",
        vweight = "",
        cft = "";
    for (int i = 0; i < _dimensions.length; i++) {
      final dim = _dimensions[i];
      pieces += "${dim.piecesController.text},";
      length += "${dim.lengthController.text},";
      breadth += "${dim.breadthController.text},";
      height += "${dim.heightController.text},";
      vweight += "${dim.vWeightController.text},";
      cft += "${dim.cftController.text},";
    }

    Get.back(
      result: {
        'totalVWeight': totalVWeight,
        'pieces': pieces,
        'length': length,
        'breadth': breadth,
        'height': height,
        'vweight': vweight,
        'cft': cft,
      },
    );

    // Navigator.pop(context, {
    //   'totalPieces': totalPieces,
    //   'totalVWeight': totalVWeight,
    // });
  }

  calculate(int index) {
    calculatePckgs(index);
    if (widget.isCft == true) {
      if (_dimensions[index].unitType == 'C' &&
          (widget.selectedServiceType.modeType == 'A' ||
              widget.selectedServiceType.modeType == 'T')) {
        _dimensions[index].vWeight = (((_dimensions[index].length.ceil() *
                        _dimensions[index].breadth.ceil() *
                        _dimensions[index].height.ceil()) /
                    (_dimensions[index].cft == 0
                        ? 1
                        : _dimensions[index].cft)) *
                _dimensions[index].pieces)
            .ceil();
      } else if (_dimensions[index].unitType == 'C' &&
          widget.selectedServiceType.modeType == 'S') {
        _dimensions[index].vWeight = ((((_dimensions[index].length *
                        _dimensions[index].breadth *
                        _dimensions[index].height) /
                    27000) *
                (_dimensions[index].cft) *
                _dimensions[index].pieces))
            .ceil();
      } else if (_dimensions[index].unitType == 'I' &&
          widget.selectedServiceType.modeType == 'S') {
        _dimensions[index].vWeight = (((_dimensions[index].length.ceil() *
                    _dimensions[index].breadth.ceil() *
                    _dimensions[index].height.ceil() /
                    1728) *
                (_dimensions[index].cft) *
                _dimensions[index].pieces))
            .ceil();
      } else if (widget.selectedServiceType.modeType == 'M') {
        _dimensions[index].vWeight = (((_dimensions[index].length.ceil() *
                    _dimensions[index].breadth.ceil() *
                    _dimensions[index].height.ceil()) *
                (_dimensions[index].pieces / 1000000)))
            .ceil();
      }
    } else {
      if (widget.selectedServiceType.modeType == 'A') {
        _dimensions[index].vWeight = (((_dimensions[index].length.ceil() *
                        _dimensions[index].breadth.ceil() *
                        _dimensions[index].height.ceil()) /
                    6000) *
                _dimensions[index].pieces)
            .ceil();
      } else {
        _dimensions[index].vWeight = (((_dimensions[index].length.ceil() *
                        _dimensions[index].breadth.ceil() *
                        _dimensions[index].height.ceil()) /
                    5000) *
                _dimensions[index].pieces)
            .ceil();
      }
    }
    // _dimensions[index].vWeight = _dimensions[index].vWeight.ceil();
    _dimensions[index].vWeightController.text =
        _dimensions[index].vWeight.toString();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text("Dimensions"),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.horizontalPadding,
            vertical: SizeConfig.verticalPadding),
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: validateAndSubmit,
            style: ElevatedButton.styleFrom(
              backgroundColor: CommonColors.colorPrimary,
              foregroundColor: CommonColors.White,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(SizeConfig.largeRadius)),
            ),
            child: const Text("Submit",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        ),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 20),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: Column(
                  children: List.generate(_dimensions.length, (index) {
                    return
                        // DimensionCard(
                        //   dimension: _dimensions[index],
                        //   onAdd: _addDimension,
                        //   onRemove: index == 0
                        //       ? null // First card cannot be removed
                        //       : () => _removeDimension(index),
                        //   index: index+1,
                        // );
                        Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(SizeConfig.largeRadius)),
                      margin: EdgeInsets.symmetric(
                          vertical: SizeConfig.verticalPadding,
                          horizontal: SizeConfig.horizontalPadding),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: SizeConfig.horizontalPadding,
                            vertical: SizeConfig.verticalPadding),
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            // final isSmall = constraints.maxWidth < 380;

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                /// ---------- HEADER ----------
                                Center(
                                  child: Text(
                                    "DIMENSION : ${index + 1}",
                                    // style: theme.textTheme.titleSmall?.copyWith(
                                    //   fontWeight: FontWeight.w600,
                                    //   color: Colors.blue,
                                    //   letterSpacing: 0.5,
                                    // ),
                                  ),
                                ),
                                SizedBox(
                                    height: SizeConfig.mediumVerticalSpacing),

                                /// ---------- UNIT TYPE ----------
                                _label("Unit Type"),
                                SizedBox(
                                    height: SizeConfig.smallVerticalSpacing),
                                _unitTypeDropdown(index),

                                SizedBox(
                                    height: SizeConfig.mediumVerticalSpacing),

                                /// ---------- PIECES + LENGTH ----------
                                _responsiveRow(
                                  children: [
                                    // _field("Pieces", _dimensions[index].piecesController, changePieces(index)),
                                    // _field("Length (C)", _dimensions[index].lengthController),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        _label('Pieces'),
                                        SizedBox(
                                            height: SizeConfig
                                                .smallVerticalSpacing),
                                        TextFormField(
                                          controller: _dimensions[index]
                                              .piecesController,
                                          keyboardType: TextInputType.number,
                                          decoration: _inputDecoration(),
                                          onChanged: (value) {
                                            _dimensions[index]
                                                .syncFromControllers();
                                            changePieces(index);
                                          },
                                        ),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        _label('Length'),
                                        SizedBox(
                                            height: SizeConfig
                                                .smallVerticalSpacing),
                                        TextFormField(
                                          controller: _dimensions[index]
                                              .lengthController,
                                          keyboardType: TextInputType.number,
                                          decoration: _inputDecoration(),
                                          onChanged: (value) {
                                            _dimensions[index]
                                                .syncFromControllers();
                                            changeLength(index);
                                          },
                                        ),
                                      ],
                                    )
                                  ],
                                ),

                                const SizedBox(height: 12),

                                /// ---------- BREADTH + HEIGHT ----------
                                _responsiveRow(
                                  children: [
                                    // _field("Breadth (C)", _dimensions[index].breadthController),
                                    // _field("Height (C)", _dimensions[index].heightController),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        _label('Breadth'),
                                        SizedBox(
                                            height: SizeConfig
                                                .smallVerticalSpacing),
                                        TextFormField(
                                          controller: _dimensions[index]
                                              .breadthController,
                                          keyboardType: TextInputType.number,
                                          decoration: _inputDecoration(),
                                          onChanged: (value) {
                                            _dimensions[index]
                                                .syncFromControllers();
                                            changeBreadth(index);
                                          },
                                        ),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        _label('Height'),
                                        SizedBox(
                                            height: SizeConfig
                                                .smallVerticalSpacing),
                                        TextFormField(
                                          controller: _dimensions[index]
                                              .heightController,
                                          keyboardType: TextInputType.number,
                                          decoration: _inputDecoration(),
                                          onChanged: (value) {
                                            _dimensions[index]
                                                .syncFromControllers();
                                            changeHeight(index);
                                          },
                                        ),
                                      ],
                                    )
                                  ],
                                ),

                                const SizedBox(height: 12),

                                /// ---------- CFT + VOLUMETRIC WEIGHT ----------
                                _responsiveRow(
                                  children: [
                                    // _field("CFT", _dimensions[index].cftController, initialValue: "10"),
                                    // _field("Volumetric Weight", _dimensions[index].vWeightController),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        _label('CFT'),
                                        SizedBox(
                                            height: SizeConfig
                                                .smallVerticalSpacing),
                                        TextFormField(
                                          controller:
                                              _dimensions[index].cftController,
                                          keyboardType: TextInputType.number,
                                          decoration: _inputDecoration(),
                                          onChanged: (value) {
                                            _dimensions[index]
                                                .syncFromControllers();
                                            changeCft(index);
                                          },
                                        ),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        _label('Vol Weight'),
                                        SizedBox(
                                            height: SizeConfig
                                                .smallVerticalSpacing),
                                        TextFormField(
                                          controller: _dimensions[index]
                                              .vWeightController,
                                          keyboardType: TextInputType.number,
                                          decoration: _inputDecoration(),
                                          onChanged: (value) {
                                            _dimensions[index]
                                                .syncFromControllers();
                                            changeVWeight(index);
                                          },
                                        ),
                                      ],
                                    )
                                  ],
                                ),

                                const SizedBox(height: 16),

                                /// ---------- BUTTONS ----------
                                _buttonsRow(index),
                              ],
                            );
                          },
                        ),
                      ),
                    );
                  }),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // ===================== WIDGET HELPERS =====================

  Widget _label(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _unitTypeDropdown(int index) {
    List<DropdownMenuItem<String>> list = [];
    for (var entry in unitTypeList.entries) {
      list.add(DropdownMenuItem(value: entry.value, child: Text(entry.value)));
    }
    return DropdownButtonFormField<String>(
      value: list.first.value,
      decoration: _inputDecoration(),
      items: list,
      onChanged: (v) {
        switch (v) {
          case "CM":
            _dimensions[index].unitType = "C";
            break;
          case "INCH":
            _dimensions[index].unitType = "I";
            break;
          case 'CBM':
            _dimensions[index].unitType = 'M';
          default:
            _dimensions[index].unitType = "C";
        }
      },
    );
  }

  // Widget _field(String label, TextEditingController controller,  VoidCallback onChange(), {String? initialValue,}) {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       _label(label),
  //       SizedBox(height: SizeConfig.smallVerticalSpacing),
  //       TextFormField(
  //         controller: controller,
  //         initialValue: initialValue ?? "0",
  //         keyboardType: TextInputType.number,
  //         decoration: _inputDecoration(),
  //         onChanged: onChange,
  //       ),
  //     ],
  //   );
  // }

  InputDecoration _inputDecoration() {
    return InputDecoration(
      isDense: true,
      contentPadding: EdgeInsets.symmetric(
          horizontal: SizeConfig.horizontalPadding,
          vertical: SizeConfig.verticalPadding),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(SizeConfig.largeRadius),
      ),
    );
  }

  Widget _responsiveRow({required List<Widget> children}) {
    if (SizeConfig.deviceType == DeviceType.smallPhone) {
      return Column(
        children: [
          children[0],
          SizedBox(height: SizeConfig.mediumVerticalSpacing),
          children[1],
        ],
      );
    }

    return Row(
      children: [
        Expanded(child: children[0]),
        const SizedBox(width: 12),
        Expanded(child: children[1]),
      ],
    );
  }

  Widget _buttonsRow(int index) {
    final addBtn = ElevatedButton(
      onPressed: _dimensions[index].canAddMore ? _addDimension : null,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: SizeConfig.verticalPadding),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(SizeConfig.largeRadius)),
        foregroundColor: CommonColors.White,
        backgroundColor: CommonColors.colorPrimary,
        disabledBackgroundColor:
            CommonColors.grey600, // Custom background color when disable
        disabledForegroundColor:
            CommonColors.grey200, // Custom text color when disabled
      ),
      child: const Text("Add More"),
    );

    final removeBtn = index == 0
        ? const SizedBox()
        : ElevatedButton(
            onPressed: index == 0
                ? null // First card cannot be removed
                : () => _removeDimension(index),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              padding:
                  EdgeInsets.symmetric(vertical: SizeConfig.verticalPadding),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(SizeConfig.largeRadius)),
            ),
            child: const Text("Remove"),
          );

    if (SizeConfig.deviceType == DeviceType.smallPhone) {
      return Column(
        children: [
          SizedBox(width: double.infinity, child: addBtn),
          if (index != 0) ...[
            SizedBox(height: SizeConfig.mediumVerticalSpacing),
            SizedBox(width: double.infinity, child: removeBtn),
          ]
        ],
      );
    }

    return Row(
      children: [
        Expanded(child: addBtn),
        if (index != 0) ...[
          SizedBox(width: SizeConfig.mediumVerticalSpacing),
          Expanded(child: removeBtn),
        ]
      ],
    );
  }
}

Future<Map<String, dynamic>?> showDimensionsScreen<T>(
  BuildContext context,
  int pckgs,
  bool isCft,
  ServiceTypeModel selectedServiceType, {
  String? pieces,
  String? length,
  String? breadth,
  String? height,
  String? vweight,
  String? cft,
}) async {
  return showModalBottomSheet<Map<String, dynamic>>(
      isScrollControlled: true,
      useSafeArea: true,
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(SizeConfig.extraLargeRadius),
        ),
      ),
      builder: (BuildContext context) {
        return FractionallySizedBox(
          heightFactor: 0.85,
          child: Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: DimensionScreen(
                pckgs: pckgs,
                isCft: isCft,
                selectedServiceType: selectedServiceType,
                pieces: pieces,
                length: length,
                breadth: breadth,
                height: height,
                vweight: vweight,
                cft: cft,
              )),
        );
      });
}
