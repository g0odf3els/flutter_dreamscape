import 'package:flutter/material.dart';

class RequestError extends StatelessWidget {
  final String errorMessage;
  final VoidCallback? onRetry;

  const RequestError({
    super.key,
    required this.errorMessage,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            errorMessage,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          TextButton(
            onPressed: onRetry,
            child: const Text('Try again'),
          )
        ],
      ),
    );
  }
}
