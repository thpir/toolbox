import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:localization/localization.dart';
import 'package:provider/provider.dart';

import '../../../models/screen_props.dart';
import '../../../controllers/storage/shared_prefs/shared_prefs_providers/ui_theme_provider.dart';

class Compass extends StatelessWidget {
  const Compass({super.key, required this.width});

  final double width;

  @override
  Widget build(BuildContext context) {
    final uiThemeProvider = Provider.of<UiThemeProvider>(context);
    
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

    return StreamBuilder<CompassEvent>(
        stream: FlutterCompass.events,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error reading heading: ${snapshot.error}');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }
          double? direction = snapshot.data!.heading;
          // if direction is null, then device does not support this sensor
          // show error message
          if (direction == null) {
            return Text('no_compass_text'.i18n());
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                  direction <= 0
                      ? '${(direction * -1).floor().toString()}°'
                      : '${(360 - direction).floor().toString()}°',
                  style: const TextStyle(
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.bold,
                      fontSize: 20)),
              Stack(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: CircleAvatar(
                      radius: width / 2.5,
                      foregroundImage: AssetImage(checkUIMode(uiThemeProvider.uiMode)
                          ? 'assets/images/compass_illustration_static_dark.png'
                          : 'assets/images/compass_illustration_static.png'),
                      foregroundColor: Colors.transparent,
                      backgroundColor: Colors.transparent,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Transform.rotate(
                      angle: (direction * (math.pi / 180) * -1),
                      child: CircleAvatar(
                        radius: width / 2.5,
                        foregroundImage: AssetImage(checkUIMode(uiThemeProvider.uiMode)
                            ? 'assets/images/compass_illustration_dynamic_dark.png'
                            : 'assets/images/compass_illustration_dynamic.png'),
                        foregroundColor: Colors.transparent,
                        backgroundColor: Colors.transparent,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        });
  }
}
