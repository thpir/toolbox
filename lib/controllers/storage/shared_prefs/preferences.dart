import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  static const uiMode = 'uiMode';
  static const calibrationMode = 'calibration_mode';
  static const calibrationValue = 'calibration_value';
  static const metrics = 'metrics';

  /// Getter and setter for the UI-Theme preference
  setUiTheme(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(uiMode, value);
  }

  Future<String> getUiTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(uiMode) ?? 'ui';
  }

  /// Getter and setter for the calibration mode. True is default calibration, 
  /// false is custom calibration.
  setCalibrationChoice(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(calibrationMode, value);
  }

  Future<bool> getCalibrationChoice() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(calibrationMode) ?? true;
  }

  /// Getter and setter for the custom calibration value. 
  /// Only used when calibrationMode is false.
  setCalibrationValue(double value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setDouble(calibrationValue, value);
  }

  Future<double> getCalibrationValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(calibrationValue) ?? 5;
  }

  /// Getter and setter for the metrics preference. True is mm, false is inches.
  setMetrics(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(metrics, value);
  }

  Future<bool> getMetrics() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(metrics) ?? true;
  }
}
