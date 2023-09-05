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

  SnackBar getErrorSnackbar(String errorText, BuildContext context) {
    return SnackBar(
      content: Text(
        errorText,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: const Color.fromARGB(255, 186, 26, 26),
    );
  }
}
