import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../controllers/storage/shared_prefs/shared_prefs_providers/ui_theme_provider.dart';
import '../../../models/screen_props.dart';

class MorseChart extends StatelessWidget {
  const MorseChart({super.key});

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
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          image: DecorationImage(
              image: AssetImage(checkUIMode(uiProvider.uiMode)
                  ? 'assets/images/background_toolbox_dark.png'
                  : 'assets/images/background_toolbox.png'),
              fit: BoxFit.cover)),
      child: Center(
        child: Image.asset(
          checkUIMode(uiProvider.uiMode)
              ? 'assets/images/international_morse_code_dark.png'
              : 'assets/images/international_morse_code.png',
          width: double.infinity,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
