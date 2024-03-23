import 'package:flutter/material.dart';

class SuccessDialog extends StatelessWidget {
  final String title;
  final String text;
  final String buttonText;

  const SuccessDialog({
    super.key,
    required this.title,
    required this.text,
    required this.buttonText,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(0))),
      title: Text(title),
      content: Text(text),
      actions: [
        TextButton(
          child: Text(buttonText),
          onPressed: () {
            Navigator.of(context).popUntil(
              (route) => route.isFirst,
            );
          },
        )
      ],
    );
  }
}
