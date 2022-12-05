import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ShareTaskModal extends StatelessWidget {
  const ShareTaskModal({
    required this.taskId,
    required this.userId,
    super.key,
  });

  final String taskId;
  final String userId;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(
          height: 20,
        ),
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            "Show this QR Code to who you pretende to share this task!",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        QrImage(
          backgroundColor: Colors.white,
          data: '{"taskId": "$taskId", "userId": "$userId"}',
          size: 250,
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text(
            'Confirmar',
            style: TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }
}
