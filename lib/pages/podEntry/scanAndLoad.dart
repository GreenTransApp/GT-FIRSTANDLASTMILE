import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:gtlmd/base/BaseRepository.dart';
import 'package:gtlmd/common/Colors.dart';
import 'package:gtlmd/pages/podEntry/Model/stickerModel.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';

class ScanAndLoad extends StatefulWidget {
  List<StickerModel> stickersList;
  ScanAndLoad({super.key, required this.stickersList});

  @override
  State<ScanAndLoad> createState() => _ScanAndLoadState();
}

class _ScanAndLoadState extends State<ScanAndLoad> {
  bool _selectAll = false;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;
  bool showScan = false;
  List<StickerModel> stickersList = [];
  BaseRepository baseRepo = BaseRepository();
  @override
  initState() {
    super.initState();
    stickersList = widget.stickersList;
    baseRepo.scanBarcode();
  }

  void _toggleSelectAll() {
    setState(() {
      _selectAll = !_selectAll;
      for (var item in stickersList) {
        item.isSelected = _selectAll;
      }
    });
  }

  selectGr(Barcode gr) {
    for (StickerModel sticker in stickersList) {
      if (sticker.stickerNo == gr.code) {
        sticker.isSelected = !sticker.isSelected!;
      }
    }
    setState(() {});
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
        selectGr(scanData);
        showScan = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CommonColors.colorPrimary,
        foregroundColor: CommonColors.White,
        title: const Text('Scan And Load'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // if (!showScan) {
          setState(() {
            showScan = !showScan;
          });
          // }
        },
        child: const Icon(Icons.camera_alt_rounded),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Text("Select All"),
                IconButton(
                  icon: _selectAll
                      ? Icon(Icons.check_box, color: CommonColors.colorPrimary)
                      : const Icon(Icons.check_box_outline_blank),
                  onPressed: _toggleSelectAll,
                ),
              ],
            ),
            Visibility(
              visible: showScan,
              child: Container(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                    height: MediaQuery.sizeOf(context).height * 0.2,
                    child:
                        QRView(key: qrKey, onQRViewCreated: _onQRViewCreated)),
              ),
            ),
            ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: stickersList.length,
                itemBuilder: (context, index) {
                  var data = stickersList[index];
                  return ListTile(
                    title: Text(data.stickerNo!),
                    trailing: Checkbox(
                      value: data.isSelected,
                      onChanged: (value) {
                        Barcode barcode = Barcode(
                          data.stickerNo!,
                          BarcodeFormat.qrcode,
                          data.stickerNo!.codeUnits,
                        );
                        selectGr(barcode);
                      },
                    ),
                  );
                })
          ],
        ),
      )),
    );
  }
}
