import 'package:flutter/material.dart';
import 'package:localization/localization.dart';
import 'package:provider/provider.dart';

import '../../../controllers/storage/shared_prefs/shared_prefs_providers/ui_theme_provider.dart';
import '../../../controllers/torch_controller.dart';
import '../../../models/screen_props.dart';

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
    final uiProvider = Provider.of<UiThemeProvider>(context, listen: true);

    bool checkUIMode(String uiMode) {
      if (uiMode == 'dark') {
        return true;
      } else if (uiMode == 'light') {
        return false;
      } else {
        final darkMode = ScreenProps.isDarkMode(context);
        if (darkMode) {
          return true;
        } else {
          return false;
        }
      }
    }
    
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          image: DecorationImage(
              image: AssetImage(checkUIMode(uiProvider.uiMode)
                  ? 'assets/images/background_toolbox_dark.png'
                  : 'assets/images/background_toolbox.png'),
              fit: BoxFit.cover)),
      child: Center(
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
      ),
    );
  }
}
