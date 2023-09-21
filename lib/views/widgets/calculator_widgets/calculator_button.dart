import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../controllers/calculator_controller.dart';

class CalculatorButton extends StatefulWidget {
  const CalculatorButton(
      {required this.btnColor,
      required this.btnText,
      required this.flex,
      super.key});

  final Color? btnColor;
  final String btnText;
  final int flex;

  @override
  State<CalculatorButton> createState() => _CalculatorButtonState();
}

class _CalculatorButtonState extends State<CalculatorButton> {
  bool isAnimating = false;
  EdgeInsets padding = const EdgeInsets.all(8);

  void _animatePadding() {
    setState(() {
      isAnimating = true;
      padding = const EdgeInsets.all(16);
    });

    Future.delayed(const Duration(milliseconds: 50), () {
      setState(() {
        isAnimating = false;
        padding = const EdgeInsets.all(8);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final calculatorController =
        Provider.of<CalculatorController>(context, listen: false);
    return Expanded(
        flex: widget.flex,
        child: Padding(
          padding: padding,
          child: GestureDetector(
            onTap: () {
              if (!isAnimating) {
                _animatePadding();
              }
              calculatorController.buttonClicked(widget.btnText);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 1,
                      blurRadius: 1,
                      offset: const Offset(0, 0), // changes position of shadow
                    ),
                  ],
                  color: widget.btnColor,
                  borderRadius: const BorderRadius.all(Radius.circular(10))),
              child: Center(
                child: Text(
                  widget.btnText,
                  style: TextStyle(
                      color: widget.btnColor == Colors.grey[600]
                          ? Colors.white
                          : Colors.black,
                      fontSize: 30),
                ),
              ),
            ),
          ),
        ));
  }
}
