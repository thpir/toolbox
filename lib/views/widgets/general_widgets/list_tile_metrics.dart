import 'package:flutter/material.dart';
import 'package:localization/localization.dart';
import 'package:provider/provider.dart';

import '../../../controllers/storage/shared_prefs/preferences.dart';
import '../../../controllers/storage/shared_prefs/shared_prefs_providers/metrics_provider.dart';

class ListTileMetrics extends StatefulWidget {
  const ListTileMetrics({super.key});

  @override
  State<ListTileMetrics> createState() => _ListTileMetricsState();
}

class _ListTileMetricsState extends State<ListTileMetrics> {
  bool metrics = true;
  final List<Widget> _metrics = <Widget>[
    Text('millimeters'.i18n()),
    Text('inches'.i18n()),
  ];

  final List<bool> _selectedMetrics = <bool>[
    true,
    false,
  ];

  @override
  void initState() {
    super.initState();
    getMetrics().then((value) {
      setState(() {
        metrics = value;
        setToggleButton();
      });
    });
  }

  void setToggleButton() {
    if (metrics) {
      setState(() {
        _selectedMetrics[0] = true;
        _selectedMetrics[1] = false;
      });
    } else {
      setState(() {
        _selectedMetrics[0] = false;
        _selectedMetrics[1] = true;
      });
    }
  }

  Future<bool> getMetrics() async {
    Preferences metricsPreference = Preferences();
    return metricsPreference.getMetrics();
  }

  @override
  Widget build(BuildContext context) {
    final metricsChange = Provider.of<MetricsProvider>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'select_unit_subtitle'.i18n(),
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: ToggleButtons(
            direction: Axis.horizontal,
            onPressed: (index) {
              setState(() {
                // The button that is tapped is set to true, and the other one to false
                for (int i = 0; i < _selectedMetrics.length; i++) {
                  _selectedMetrics[i] = i == index;
                }
                for (int j = 0; j < _selectedMetrics.length; j++) {
                  if (_selectedMetrics[j]) {
                    j == 0
                        ? metricsChange.metrics = true
                        : metricsChange.metrics = false;
                  }
                }
              });
            },
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            selectedBorderColor: Colors.amber[600],
            selectedColor: Colors.black,
            fillColor: Colors.amber,
            color: Theme.of(context).focusColor,
            constraints: const BoxConstraints(minHeight: 40.0, minWidth: 100.0),
            isSelected: _selectedMetrics,
            children: _metrics,
          ),
        ),
      ],
    );
  }
}
