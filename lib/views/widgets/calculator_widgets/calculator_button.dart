import 'package:flutter/material.dart';

class CalculatorButton extends StatelessWidget {
  const CalculatorButton(
      {required this.btnColor,
      required this.btnText,
      required this.flex,
      super.key});

  final Color? btnColor;
  final String btnText;
  final int flex;

  @override
  Widget build(BuildContext context) {
    return Expanded(
        flex: flex,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () {},
            child: Container(
              decoration: BoxDecoration(
                  color: btnColor,
                  borderRadius: const BorderRadius.all(Radius.circular(10))),
              child: Center(
                child: Text(btnText,
                    style: TextStyle(
                      color: btnColor == Colors.grey[600] ? Colors.white : Colors.black, 
                      fontSize: 30
                    ),
                  ),
              ),
            ),
          ),
        ));
  }
}
