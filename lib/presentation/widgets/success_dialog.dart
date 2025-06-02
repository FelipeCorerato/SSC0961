import 'package:flutter/material.dart';

class SuccessDialog extends StatelessWidget {
  final String title;
  final String message;
  final String buttonText;
  final VoidCallback onPressed;

  const SuccessDialog({
    Key? key,
    required this.title,
    required this.message,
    this.buttonText = 'OK',
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: _buildDialogContent(context),
    );
  }

  Widget _buildDialogContent(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.only(
            top: 60, // Deixa espaço para o ícone
            left: 24,
            right: 24,
            bottom: 24,
          ),
          margin: const EdgeInsets.only(top: 40),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                offset: const Offset(0, 10),
                blurRadius: 20,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                message,
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: onPressed,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(buttonText, style: const TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
        Positioned(
          top: 0,
          child: CircleAvatar(
            backgroundColor: Colors.green,
            radius: 40,
            child: Icon(Icons.check, size: 50, color: Colors.white),
          ),
        ),
      ],
    );
  }
}
