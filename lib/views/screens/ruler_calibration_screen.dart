import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:localization/localization.dart';

import '../../controllers/storage/shared_prefs/shared_prefs_providers/metrics_provider.dart';
import '../../controllers/storage/shared_prefs/shared_prefs_providers/calibration_provider.dart';
import '../../controllers/ruler_controller.dart';
import '../../controllers/storage/shared_prefs/shared_prefs_providers/ui_theme_provider.dart';
import '../../models/screen_props.dart';

class RulerCalibrationScreen extends StatefulWidget {
  static const routeName = '/ruler-calibration-screen';
  const RulerCalibrationScreen({super.key});

  @override
  State<RulerCalibrationScreen> createState() => _RulerCalibrationScreenState();
}

class _RulerCalibrationScreenState extends State<RulerCalibrationScreen> {
  double _height = 400.0;

  @override
  Widget build(BuildContext context) {
    final metricsProvider = Provider.of<MetricsProvider>(context);
    final calibrationProvider = Provider.of<CalibrationProvider>(context);
    RulerController rulerController = RulerController(context);
    rulerController.mm = metricsProvider.metrics;
    rulerController.standardCalibration = calibrationProvider.calibrationMode;
    rulerController.calibrationValue = calibrationProvider.calibrationValue;
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

    return Scaffold(
      appBar: AppBar(
        title: Text('appbar_calibration_text'.i18n(),
            style: const TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.bold,
                fontSize: 20)),
        elevation: 0,
        actions: <Widget>[
          IconButton(
            onPressed: () {
              double newCalibrationValue = _height / 50;
              calibrationProvider.calibrationValue = newCalibrationValue;
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.check_circle_outline,
              color: Colors.green,
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.cancel_outlined,
              color: Colors.red,
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                image: DecorationImage(
                    image: AssetImage(checkUIMode(uiProvider.uiMode)
                        ? 'assets/images/background_toolbox_dark.png'
                        : 'assets/images/background_toolbox.png'),
                    fit: BoxFit.cover)),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 0),
            child: GestureDetector(
              onVerticalDragUpdate: (DragUpdateDetails details) {
                setState(() {
                  _height += details.delta.dy;
                });
              },
              child: Container(
                color: Theme.of(context).colorScheme.background,
                height: _height,
                child: Stack(
                  children: [
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 70.0),
                            child: Text(
                              metricsProvider.metrics
                                  ? 'calibration_explanation_text_mm'.i18n()
                                  : 'calibration_explanation_text_inch'.i18n(),
                              style: Theme.of(context).textTheme.titleLarge,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Icon(
                            Icons.swipe_down,
                            color: Theme.of(context).focusColor,
                            size: 50,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: metricsProvider.metrics
                          ? (_height / 50)
                          : (_height / 16),
                      width: 40,
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(
                            width: 1,
                            color: Theme.of(context).focusColor,
                          ),
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: metricsProvider.metrics
                          ? rulerController.verticalCalibrationRulerPin(
                              50, _height)
                          : rulerController.verticalCalibrationRulerPin(
                              16, _height),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
