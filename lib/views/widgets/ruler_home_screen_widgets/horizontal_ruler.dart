import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../controllers/ruler_controller.dart';
import '../../../controllers/storage/shared_prefs/shared_prefs_providers/metrics_provider.dart';

class HorizontalRuler extends StatelessWidget {
  const HorizontalRuler({
    Key? key,
    required this.rulerController,
  }) : super(key: key);

  final RulerController rulerController;

  @override
  Widget build(BuildContext context) {
    final metricsProvider = Provider.of<MetricsProvider>(context);
    return Container(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: rulerController.horizontalRulerPin(
                rulerController.getNumberOfHorizontalRulerPins()),
          ),
          const Padding(padding: EdgeInsets.symmetric(vertical: 5)),
          Row(
            children: rulerController.horizontalRulerDigits(((metricsProvider.metrics
                        ? rulerController.getNumberOfHorizontalRulerPins() - 2
                        : rulerController.getNumberOfHorizontalRulerPins() -
                            1) /
                    (metricsProvider.metrics ? 10 : 8))
                .floor()),
          ),
        ],
      ),
    );
  }
}
