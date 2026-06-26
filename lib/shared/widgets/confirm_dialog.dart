import 'package:flutter/material.dart';
import '../../core/constants/app_strings.dart';
import '../../core/theme/app_colors.dart';

class ConfirmDialog extends StatelessWidget {
  final String title;
  final String message;
  final String confirmLabel;
  final String cancelLabel;
  final Color? confirmColor;
  final VoidCallback onConfirm;

  const ConfirmDialog({
    super.key,
    required this.title,
    required this.message,
    this.confirmLabel = AppStrings.yes,
    this.cancelLabel = AppStrings.cancel,
    this.confirmColor,
    required this.onConfirm,
  });

  static Future<void> show(
    BuildContext context, {
    required String title,
    required String message,
    String confirmLabel = AppStrings.yes,
    String cancelLabel = AppStrings.cancel,
    Color? confirmColor,
    required VoidCallback onConfirm,
  }) {
    return showDialog<void>(
      context: context,
      builder: (ctx) => ConfirmDialog(
        title: title,
        message: message,
        confirmLabel: confirmLabel,
        cancelLabel: cancelLabel,
        confirmColor: confirmColor,
        onConfirm: () {
          Navigator.of(ctx).pop();
          onConfirm();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(cancelLabel),
        ),
        TextButton(
          onPressed: onConfirm,
          style: TextButton.styleFrom(
            foregroundColor: confirmColor ?? AppColors.danger,
          ),
          child: Text(confirmLabel),
        ),
      ],
    );
  }
}
