import 'package:flutter/material.dart';
import 'package:gtlmd/design_system/size_config.dart';
import 'package:gtlmd/pages/dimensions/dimensionCard.dart';

class DimensionScreen extends StatefulWidget {
  const DimensionScreen({super.key});

  @override
  State<DimensionScreen> createState() => _DimensionScreenState();
}

class _DimensionScreenState extends State<DimensionScreen> {
  final List<int> _dimensions = [1]; // Start with one card

  void _addDimension() {
    setState(() {
      _dimensions.add(_dimensions.length + 1);
    });
  }

  void _removeDimension(int index) {
    setState(() {
      _dimensions.removeAt(index);

      // Re-number dimensions after removal
      for (int i = 0; i < _dimensions.length; i++) {
        _dimensions[i] = i + 1;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dimensions"),
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
                    return DimensionCard(
                      index: _dimensions[index],
                      onAdd: _addDimension,
                      onRemove: index == 0
                          ? null // First card cannot be removed
                          : () => _removeDimension(index),
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
}

Future<void> showDimensionsScreen<T>(
  BuildContext context,
) async {
  return showModalBottomSheet<void>(
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
              child: const DimensionScreen()),
        );
      });
}
