import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../controllers/ruler_controller.dart';
import '../../../controllers/storage/shared_prefs/shared_prefs_providers/metrics_provider.dart';

class VerticalRuler extends StatelessWidget {
  const VerticalRuler({
    Key? key,
    required this.rulerController,
  }) : super(key: key);

  final RulerController rulerController;

  @override
  Widget build(BuildContext context) {
    final metricsProvider = Provider.of<MetricsProvider>(context);
    return Container(
      padding: EdgeInsets.zero,
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: rulerController.verticalRulerPin(
                rulerController.getNumberOfVerticalRulerPins(context)),
          ),
          const Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
          Column(
            children: rulerController.verticalRulerDigits(((metricsProvider.metrics
                        ? rulerController
                                .getNumberOfVerticalRulerPins(context) -
                            2
                        : rulerController
                                .getNumberOfVerticalRulerPins(context) -
                            1) /
                    (metricsProvider.metrics ? 10 : 8))
                .floor()),
          ),
        ],
      ),
    );
  }
}
