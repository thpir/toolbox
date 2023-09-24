import 'package:flutter/material.dart';

import '../models/calculator.dart';

class CalculatorController extends ChangeNotifier {
  final Calculator calculator;
  String displayValue = '0';

  CalculatorController(this.calculator);

  buttonClicked(String btnID) {
    switch (btnID) {
      case 'AC':
        {
          resetDisplay();
        }
        break;
      case '+/-':
        {
          reverseSign();
        }
        break;
      case '%':
        {
          calculatePercentage();
        }
        break;
      case '÷':
        {
          performCalculation(btnID);
        }
        break;
      case '×':
        {
          performCalculation(btnID);
        }
        break;
      case '-':
        {
          performCalculation(btnID);
        }
        break;
      case '+':
        {
          performCalculation(btnID);
        }
        break;
      case ',':
        {
          startFloating();
        }
        break;
      case '=':
        {
          performCalculation('');
        }
        break;
      default:
        {
          numberButtonClicked(int.parse(btnID));
        }
        break;
    }
  }

  performCalculation(String newOperand) {
    calculator.setResult(double.parse(displayValue));
    if (calculator.operand == '+' &&
        calculator.memoryNumber != 0 &&
        calculator.canCalculate) {
      setDisplay(removeTrailingZeros(calculator.memoryNumber + calculator.result));
    } else if (calculator.operand == '-' &&
        calculator.memoryNumber != 0 &&
        calculator.canCalculate) {
      setDisplay(removeTrailingZeros(calculator.memoryNumber - calculator.result));
    } else if (calculator.operand == '×' &&
        calculator.memoryNumber != 0 &&
        calculator.canCalculate) {
      setDisplay(removeTrailingZeros(calculator.memoryNumber * calculator.result));
    } else if (calculator.operand == '÷' &&
        calculator.memoryNumber != 0 &&
        calculator.canCalculate) {
      try {
        setDisplay(removeTrailingZeros(calculator.memoryNumber / calculator.result));
      } catch (e) {
        setDisplay('Not a Number');
        calculator.setResult(0.0);
        calculator.setMemoryNumber(0.0);
        calculator.setOperand('');
        calculator.setClrDisplayBool(false);
        return;
      }
    }
    calculator.setMemoryNumber(double.parse(displayValue));
    calculator.setClrDisplayBool(true);
    calculator.setOperand(newOperand);
    calculator.setCanCalculate(false);
  }

  numberButtonClicked(int number) {
    calculator.setCanCalculate(true);
    if (calculator.clearDisplay) {
      setDisplay(number.toString());
      calculator.setClrDisplayBool(false);
    } else if (displayValue == "0") {
      setDisplay(number.toString());
    } else {
      setDisplay(displayValue + number.toString());
    }
  }

  setDisplay(String newDisplayValue) {  
    displayValue = newDisplayValue;
    notifyListeners();
  }

  String removeTrailingZeros(double value) {
    String stringValue = value.toString();
    if (stringValue.contains('.')) {
      stringValue = stringValue.replaceAll(RegExp(r'0*$'), ''); // Remove trailing zeros
      if (stringValue.endsWith('.')) {
        stringValue = stringValue.substring(0, stringValue.length - 1); // Remove trailing decimal point if it's the only character left
      }
    }
    return stringValue;
  }

  resetDisplay() {
    setDisplay('0');
    calculator.setResult(0.0);
    calculator.setMemoryNumber(0.0);
    calculator.setOperand('');
    calculator.setClrDisplayBool(false);
  }

  reverseSign() {
    String newValue = displayValue;
    if (newValue.startsWith("-")) {
      newValue = newValue.substring(1); // Remove the first character
    } else {
      newValue = '-$newValue';
    }
    setDisplay(newValue);
  }

  calculatePercentage() {
    double newValue = double.parse(displayValue) / 100;
    setDisplay(removeTrailingZeros(newValue));
  }

  startFloating() {
    if (displayValue.contains('.')) {
      return;
    } else {
      setDisplay('$displayValue.');
    }
  }
}
