import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_task_list/views/task/list/task_list_models.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class ShareTask extends StatefulWidget {
  final BarcodeFormat format;
  final void Function(String?) onScan;
  const ShareTask({
    Key? key,
    required this.format,
    required this.onScan,
  }) : super(key: key);

  @override
  State<ShareTask> createState() => _ShareTaskState();

  static Future<QRCodeScanResult?> show({
    required BuildContext context,
    required BarcodeFormat format,
  }) async =>
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (ctx) => ShareTask(
            format: format,
            onScan: (scan) {
              QRCodeScanResult? qrResult;
              try {
                final parsedJson = json.decode(scan!);
                qrResult = QRCodeScanResult(
                  userId: parsedJson['userId'],
                  taskId: parsedJson['taskId'],
                );
                Navigator.of(ctx).pop<QRCodeScanResult>(qrResult);
              } catch (e) {
                Navigator.of(context).pop(null);
              }
            },
          ),
        ),
      );
}

class _ShareTaskState extends State<ShareTask> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FocusDetector(
      onFocusGained: () => controller!.resumeCamera(),
      child: Scaffold(
        body: Column(
          children: <Widget>[
            Expanded(
              flex: 5,
              child: QRView(
                key: qrKey,
                onQRViewCreated: _onQRViewCreated,
              ),
            ),
            Expanded(
              flex: 1,
              child: Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () => widget.onScan(null),
                  child: const Text("Cancelar"),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream
        .firstWhere((scanData) => scanData.format == widget.format)
        .then((scanData) => widget.onScan(scanData.code));
    ;
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
