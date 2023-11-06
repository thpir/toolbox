import 'package:torch_light/torch_light.dart';

import 'message_controller.dart';

class TorchController {
  MessageController messageController = MessageController();
  bool flashOn = false;
  bool _isTorchAvailable = false;

  Future isTorchAvailable() async {
    try {
      _isTorchAvailable = await TorchLight.isTorchAvailable();
    } on Exception catch (_) {
      messageController
          .getErrorSnackbar("No flashlight available at the moment...");
    }
  }

  Future torchOn() async {
    try {
      await TorchLight.enableTorch();
      flashOn = true;
    } on Exception catch (_) {
      _isTorchAvailable
          ? messageController.getErrorSnackbar(
              "Something went wrong. I could not enable the flashlight...")
          : messageController
              .getErrorSnackbar("No flashlight available at the moment...");
    }
  }

  Future torchOff() async {
    try {
      await TorchLight.disableTorch();
      flashOn = false;
    } on Exception catch (_) {
      _isTorchAvailable
          ? messageController.getErrorSnackbar(
              "Something went wrong. I could not disable the flashlight...")
          : messageController
              .getErrorSnackbar("No flashlight available at the moment...");
    }
  }
}
