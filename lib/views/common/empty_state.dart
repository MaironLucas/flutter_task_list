import 'package:flutter/material.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    this.asset,
    this.icon,
    this.buttonText,
    required this.message,
    required this.onTryAgainTap,
  });

  final String? asset;
  final IconData? icon;
  final String message;
  final String? buttonText;
  final Function? onTryAgainTap;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null)
            Icon(
              icon,
              color: Colors.blue,
            )
          else
            Image.asset(asset ?? 'assets/error.png'),
          const SizedBox(
            height: 30,
          ),
          Text(message),
          const SizedBox(
            height: 30,
          ),
          TextButton(
            onPressed: onTryAgainTap as void Function()?,
            child: Text(buttonText ?? 'Tentar novamente'),
          ),
        ],
      ),
    );
  }
}
