import 'package:flutter/material.dart';

import '../preferences.dart';

class MetricsProvider extends ChangeNotifier {

  // Create an instance of 'MetricsPreference' and assign it to a member 
  // variable: metricsPreference
  Preferences metricsPreference = Preferences();
  bool _metrics = true;

  // Constructor to retrieve the preferred metric choice previously selected
  // by the user.
  MetricsProvider() {
    metricsPreference.getMetrics().then((value) {
      _metrics = value;
      notifyListeners();
    });
  }

  // Getter to retrieve the metrics.
  bool get metrics => _metrics;

  // Setter to save the newly selected metrics.
  set metrics(bool newValue) {
    _metrics = newValue;
    metricsPreference.setMetrics(newValue);
    notifyListeners();
  }
}