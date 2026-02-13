import 'package:flutter/material.dart';
import 'package:pow_note_ai/utils/app_radius.dart';

import '../utils/app_texts.dart';
class MessageBox {

  static void showMessage({
    required BuildContext context,
    required String message,
    VoidCallback? onPressed
  }){
    showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: AppRadius.radius8,
            ),
            title: Text(
                message,
              style: TextTheme.of(context)
                  .bodyMedium
            ),
            icon: Icon(
              Icons.info,
              size: 30,
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(AppTexts.close)
              )
            ],
          );
        }
    );
  }

  static void showFailureMessage({
    required BuildContext context,
    required String message,
    VoidCallback? onPressed
  }){
    showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: AppRadius.radius8,
            ),
            title: Text(
              message,
              style: TextTheme.of(context)
                  .bodyMedium
                  ?.copyWith(color: Colors.redAccent)
            ),
            icon: Icon(
              Icons.error_outline,
              color: Colors.redAccent,
              size: 30,
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(AppTexts.close)
              )
            ],
            elevation: 5,
          );
        }
    );
  }
}