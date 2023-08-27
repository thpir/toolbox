import 'package:flutter/material.dart';
import 'package:localization/localization.dart';

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
    return Container(
      width: width,
      height: height,
      color: Theme.of(context).scaffoldBackgroundColor,
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
