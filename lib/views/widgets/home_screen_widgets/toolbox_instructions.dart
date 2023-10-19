import 'package:flutter/material.dart';
import 'package:localization/localization.dart';
import 'package:provider/provider.dart';

import '../../../controllers/storage/shared_prefs/shared_prefs_providers/ui_theme_provider.dart';

class ToolboxInstructions extends StatelessWidget {
  const ToolboxInstructions({
    super.key,
    required this.width,
    required this.height,
  });

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    final uiThemeProvider = Provider.of<UiThemeProvider>(context);
    return Container(
      width: width,
      height: height,
      //color: Theme.of(context).scaffoldBackgroundColor,
      decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            image: DecorationImage(
                image: uiThemeProvider.uiMode == "dark" ? const AssetImage('assets/images/background_toolbox_dark.png') : const AssetImage('assets/images/background_toolbox.png'),
                fit: BoxFit.cover)),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'toolbox_instructions_widget_instruction_text'.i18n(),
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 20,
            ),
            Icon(
              Icons.ads_click,
              color: Theme.of(context).focusColor,
              size: 50,
            ),
          ],
        ),
      ),
    );
  }
}
