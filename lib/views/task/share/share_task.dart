import 'dart:io';

import 'package:flutter/material.dart';
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

  static Future<String?> show({
    required BuildContext context,
    required BarcodeFormat format,
  }) async =>
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (ctx) => ShareTask(
            format: format,
            onScan: (scan) => Navigator.of(ctx).pop(scan),
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
    return Scaffold(
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
