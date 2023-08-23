import 'package:flutter/material.dart';

import '../models/ruler.dart';

class VerticalRuler extends StatelessWidget {
  const VerticalRuler({
    Key? key,
    required this.ruler,
    required this.isMm,
    required this.isDefaultCalibration,
    required this.calibrationValue,
  }) : super(key: key);

  final Ruler ruler;
  final bool isMm;
  final bool isDefaultCalibration;
  final double calibrationValue;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.zero,
      child: const Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children:[],
          ),
          const Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
          Column(
            children: []
          ),
        ],
      ),
    );
  }
}
