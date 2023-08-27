import 'package:flutter/material.dart';

import '../../../controllers/ruler_controller.dart';

class RulerOrigin extends StatelessWidget {
  const RulerOrigin({
    Key? key,
    required this.rulerController,
  }) : super(key: key);

  final RulerController rulerController;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 5 * rulerController.getPixelCountInMm(),
      height: 5 * rulerController.getPixelCountInMm(),
      decoration: BoxDecoration(
          border: Border(
        top: BorderSide(
            color: Theme.of(context).focusColor,
            width: 1,
            style: BorderStyle.solid),
        left: BorderSide(
            color: Theme.of(context).focusColor,
            width: 1,
            style: BorderStyle.solid),
      )),
      child: Center(
        child: Text(
          '0',
          style: TextStyle(
            fontSize: 20,
            color: Theme.of(context).focusColor,
          ),
        ),
      ),
    );
  }
}