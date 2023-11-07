import 'package:flutter/material.dart';
import 'package:localization/localization.dart';

import '../../../controllers/torch_controller.dart';

class TorchButton extends StatefulWidget {
  const TorchButton({super.key});

  @override
  State<TorchButton> createState() => _TorchButtonState();
}

class _TorchButtonState extends State<TorchButton> {
  final TorchController torchController = TorchController();

  @override
  void initState() {
    torchController.isTorchAvailable();
    super.initState();
  }

  @override
  void dispose() {
    torchController.torchOff();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () async {
              if (torchController.flashOn) {
                await torchController.torchOff();
                setState(() {});
              } else {
                await torchController.torchOn();
                setState(() {});
              }
            },
            child: CircleAvatar(
              radius: 50,
              child: Icon(
                torchController.flashOn
                    ? Icons.flashlight_on
                    : Icons.flashlight_off,
                size: 64,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Text(
                torchController.flashOn
                    ? 'torch_on'.i18n()
                    : 'torch_off'.i18n(),
                style: const TextStyle(
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.bold,
                    fontSize: 20)),
          ),
        ],
      ),
    );
  }
}
