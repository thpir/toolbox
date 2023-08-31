import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'custom_slider.dart';
import '../../../controllers/ruler_controller.dart';
import '../../../controllers/storage/shared_prefs/shared_prefs_providers/metrics_provider.dart';

class Sliders extends StatefulWidget {
  const Sliders({
    Key? key,
    required this.rulerController,
  }) : super(key: key);

  final RulerController rulerController;

  @override
  State<Sliders> createState() => _SlidersState();
}

class _SlidersState extends State<Sliders> {
  @override
  Widget build(BuildContext context) {
    final metricsProvider = Provider.of<MetricsProvider>(context);
    return SizedBox(
      child: CustomSlider(
        rulerController: widget.rulerController,
        valueChangedHorizontally: (value) {
          setState(() {});
        },
        valueChangedVertically: (value) {
          setState(() {});
        },
        sliderHeight: widget.rulerController.sliderHeight,
        availableWidthInMm: (widget.rulerController.sliderWidth - 50) /
            (metricsProvider.metrics
                ? widget.rulerController.getPixelCountInMm()
                : widget.rulerController.getPixelCountInInches() * 8),
        sliderWidth: widget.rulerController.sliderWidth,
        availableHeightInMm: (widget.rulerController.sliderHeight - 50) /
            (metricsProvider.metrics
                ? widget.rulerController.getPixelCountInMm()
                : widget.rulerController.getPixelCountInInches() * 8),
      ),
    );
  }
}
