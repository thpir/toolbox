import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../controllers/calculator_controller.dart';

class CalculatorDisplay extends StatelessWidget {
  const CalculatorDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    final calculatorController =
        Provider.of<CalculatorController>(context, listen: true);
    return Expanded(
      flex: 1,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              border: Border.all(color: Colors.grey)),
          child: Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Text(calculatorController.displayValue,
                  maxLines: 1,
                  style: TextStyle(
                      color: Theme.of(context).focusColor, fontSize: 40)),
            ),
          ),
        ),
      ),
    );
  }
}
