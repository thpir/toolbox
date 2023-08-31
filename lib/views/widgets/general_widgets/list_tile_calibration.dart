import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:localization/localization.dart';

import '../../../controllers/storage/shared_prefs/shared_prefs_providers/calibration_provider.dart';
import '../../screens/ruler_calibration_screen.dart';

class ListTileCalibration extends StatefulWidget {
  const ListTileCalibration({super.key});

  @override
  State<ListTileCalibration> createState() => _ListTileCalibrationState();
}

class _ListTileCalibrationState extends State<ListTileCalibration> {
  @override
  Widget build(BuildContext context) {
    final calibrationProvider = Provider.of<CalibrationProvider>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'list_tile_calibration_title'.i18n(),
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
        RadioListTile(
            activeColor: Colors.amber,
            title: Text(
              'list_tile_calibration_default'.i18n(),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            value: true,
            groupValue: calibrationProvider.calibrationMode,
            onChanged: ((value) {
              calibrationProvider.calibrationMode = value!;
            })),
        RadioListTile(
            activeColor: Colors.amber,
            title: Text(
              'list_tile_calibration_custom'.i18n(),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            value: false,
            groupValue: calibrationProvider.calibrationMode,
            onChanged: ((value) {
              calibrationProvider.calibrationMode = value!;
            })),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Close the drawer
                Navigator.of(context).pushNamed(RulerCalibrationScreen
                    .routeName); // Open the calibration screen on top of the main screen
              },
              child: Text(
                'list_tile_calibration_button_text'.i18n(),
                style: const TextStyle(
                  color: Colors.black,
                  fontFamily: 'Roboto',
                  fontSize: 16,
                ),
              )),
        )
      ],
    );
  }
}
