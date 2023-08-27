import 'package:flutter/material.dart';

import '../preferences.dart';

class CalibrationProvider extends ChangeNotifier {

  Preferences calibrationPreference = Preferences();
  bool _calibrationMode = true;
  double _calibrationValue = 160;

  // Constructor to retrieve the saved preferences of the user
  CalibrationProvider() {

    // The calibrationValue is a constant value used to display ruler correctly
    // in case we cannot access the screen properties and have to use a custom
    // calibration.
    calibrationPreference.getCalibrationValue().then((value) {
      _calibrationValue = value;
      notifyListeners();
    });

    // The calibrationChoice keeps track whether the user selected default or
    // custom ruler calibration.
    calibrationPreference.getCalibrationChoice().then((value) {
      _calibrationMode = value;
      notifyListeners();
    });

  }

  // Getter for setting the calibrationMode.
  bool get calibrationMode => _calibrationMode;

  // Setter to save the chosen calibrationMode.
  set calibrationMode(bool newValue) {
    _calibrationMode = newValue;
    calibrationPreference.setCalibrationChoice(newValue);
    notifyListeners();
  }

  // Getter for setting the custom calibrationValue.
  double get calibrationValue => _calibrationValue;

  // Setter to save the calibration.
  set calibrationValue(double newValue) {
    _calibrationValue = newValue;
    calibrationPreference.setCalibrationValue(newValue);
    notifyListeners();
  }
}
