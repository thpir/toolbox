import 'package:flutter/material.dart';

class MessageController {
  SnackBar getInformationalSnackbar(String infoText, BuildContext context) {
    return SnackBar(
      content: Text(
        infoText,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      backgroundColor: Theme.of(context).primaryColor,
    );
  }
}
