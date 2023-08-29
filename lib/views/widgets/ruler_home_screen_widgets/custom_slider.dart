import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../controllers/ruler_controller.dart';
import '../../../controllers/storage/shared_prefs/shared_prefs_providers/metrics_provider.dart';

class CustomSlider extends StatefulWidget {
  final RulerController rulerController;
  final ValueChanged<double>? valueChangedHorizontally;
  final ValueChanged<double>? valueChangedVertically;
  final double sliderHeight;
  final double sliderWidth;
  final double availableWidthInMm;
  final double availableHeightInMm;

  const CustomSlider({
    Key? key,
    required this.rulerController,
    this.valueChangedHorizontally,
    this.valueChangedVertically,
    required this.sliderHeight,
    required this.sliderWidth,
    required this.availableWidthInMm,
    required this.availableHeightInMm,
  }) : super(key: key);

  @override
  State<CustomSlider> createState() => _CustomSliderState();
}

class _CustomSliderState extends State<CustomSlider> {
  ValueNotifier<double> horizontalValueListener = ValueNotifier(0.5);
  ValueNotifier<double> verticalValueListener = ValueNotifier(0.5);
  var savedValue = '';

  @override
  void initState() {
    super.initState();
    //horizontalValueListener.addListener(notifyParentForHorizontalMovement);
    verticalValueListener.addListener(notifyParentForVerticalMovement);
  }

  // Triggered when the horizontal slider has moved.
  void notifyParentForHorizontalMovement() {
    if (widget.valueChangedHorizontally != null) {
      widget.valueChangedHorizontally!(horizontalValueListener.value);
    }
  }

  // Triggered when the vertical slider has moved.
  void notifyParentForVerticalMovement() {
    if (widget.valueChangedVertically != null) {
      widget.valueChangedVertically!(verticalValueListener.value);
    }
  }

  @override
  Widget build(BuildContext context) {
    final metricsProvider = Provider.of<MetricsProvider>(context);

    GestureDetector getHorizontalDetector() {
      return GestureDetector(
        onHorizontalDragUpdate: ((details) {
          double newValue = horizontalValueListener.value +
              details.delta.dx / context.size!.width;
          newValue = newValue.clamp(0.0, 1.0);
          horizontalValueListener.value = newValue;
          notifyParentForHorizontalMovement();
        }),
        child: Container(
          alignment: Alignment.bottomCenter,
          height: widget.sliderHeight,
          width: 50,
          decoration: const BoxDecoration(
            border: Border(
              left: BorderSide(
                width: 1,
                color: Colors.amber,
              ),
            ),
          ),
          child: Container(
            margin: const EdgeInsets.only(bottom: 15),
            decoration: BoxDecoration(
              color: Colors.amber,
              border: Border.all(
                width: 1,
                color: Colors.amber,
              ),
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
            ),
            child: RotatedBox(
              quarterTurns: -1,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      metricsProvider.metrics
                          ? '${(horizontalValueListener.value * widget.availableWidthInMm).toStringAsFixed(1)} mm'
                          : '${(horizontalValueListener.value * widget.availableWidthInMm).toStringAsFixed(2)} inch',
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    ),
                    IconButton(
                      onPressed: (() {
                        savedValue = metricsProvider.metrics
                            ? '${(horizontalValueListener.value * widget.availableWidthInMm).toStringAsFixed(1)} mm'
                            : '${(horizontalValueListener.value * widget.availableWidthInMm).toStringAsFixed(2)} inch';
                        widget.rulerController
                            .saveMeasurement(savedValue, context);
                      }),
                      icon: const Icon(
                        Icons.save,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }

    GestureDetector getVerticalDetector() {
      return GestureDetector(
        onVerticalDragUpdate: ((details) {
          double newValue = verticalValueListener.value +
              details.delta.dy / context.size!.height;
          newValue = newValue.clamp(0.0, 1.0);
          verticalValueListener.value = newValue;
          notifyParentForVerticalMovement();
        }),
        child: Container(
          alignment: Alignment.topRight,
          width: widget.sliderWidth,
          height: 50,
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(
                width: 1,
                color: Colors.amber,
              ),
            ),
          ),
          child: Container(
            margin: const EdgeInsets.only(right: 15),
            height: 50,
            decoration: BoxDecoration(
              color: Colors.amber,
              border: Border.all(
                width: 1,
                color: Colors.amber,
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    metricsProvider.metrics
                        ? '${(verticalValueListener.value * widget.availableHeightInMm).toStringAsFixed(1)} mm'
                        : '${(verticalValueListener.value * widget.availableHeightInMm).toStringAsFixed(2)} inch',
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                    ),
                  ),
                  IconButton(
                      onPressed: (() {
                        savedValue = metricsProvider.metrics
                            ? '${(verticalValueListener.value * widget.availableHeightInMm).toStringAsFixed(1)} mm'
                            : '${(verticalValueListener.value * widget.availableHeightInMm).toStringAsFixed(2)} inch';
                        widget.rulerController
                            .saveMeasurement(savedValue, context);
                      }),
                      icon: const Icon(
                        Icons.save,
                        color: Colors.black,
                      ))
                ],
              ),
            ),
          ),
        ),
      );
    }

    return Container(
      color: Colors.transparent,
      height: widget.sliderHeight,
      width: widget.sliderWidth,
      child: Builder(
        builder: ((context) {
          return Stack(
            children: [
              AnimatedBuilder(
                animation: horizontalValueListener,
                builder: (context, child) {
                  return Align(
                    alignment:
                        Alignment(horizontalValueListener.value * 2 - 1, 0.5),
                    child: child!,
                  );
                },
                child: getHorizontalDetector(),
              ),
              AnimatedBuilder(
                animation: verticalValueListener,
                builder: (context, child) {
                  return Align(
                    alignment:
                        Alignment(0.5, verticalValueListener.value * 2 - 1),
                    child: child!,
                  );
                },
                child: getVerticalDetector(),
              ),
            ],
          );
        }),
      ),
    );
  }
}
