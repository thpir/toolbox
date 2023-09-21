import 'package:flutter/material.dart';

import '../models/calculator.dart';

class CalculatorController extends ChangeNotifier {
  final Calculator calculator;
  String displayValue = '0';

  CalculatorController(this.calculator);

  buttonClicked(String btnID) {
    print('Button clicked with id: $btnID');
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

  acButtonClicked() {}

  performCalculation(String newOperand) {
    calculator.setResult(double.parse(displayValue));
    if (calculator.operand == '+' && calculator.memoryNumber != 0) {
      print('+ calculation');
      print('memoryNumber = ${calculator.memoryNumber}');
      print('result = ${calculator.result}');
      setDisplay((calculator.memoryNumber + calculator.result).toString());
    } else if (calculator.operand == '-' && calculator.memoryNumber != 0) {
      print('- calculation');
      print('memoryNumber = ${calculator.memoryNumber}');
      print('result = ${calculator.result}');
      setDisplay((calculator.memoryNumber - calculator.result).toString());
    } else if (calculator.operand == '×' && calculator.memoryNumber != 0) {
      print('x calculation');
      print('memoryNumber = ${calculator.memoryNumber}');
      print('result = ${calculator.result}');
      setDisplay((calculator.memoryNumber * calculator.result).toString());
    } else if (calculator.operand == '÷' && calculator.memoryNumber != 0) {
      print('÷ calculation');
      print('memoryNumber = ${calculator.memoryNumber}');
      print('result = ${calculator.result}');
      try {
        setDisplay((calculator.memoryNumber / calculator.result).toString());
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
    print('new memoryNumber set: $displayValue');
    calculator.setClrDisplayBool(true);
    print('override is let to: ${calculator.clearDisplay}');
    calculator.setOperand(newOperand);
    print('operand is set to: ${calculator.operand}');
  }

  numberButtonClicked(int number) {
    print('number $number was clicked');
    print('bool clearDisplay = ${calculator.clearDisplay}');
    if (calculator.clearDisplay) {
      print('clearDisplay is true');
      setDisplay(number.toString());
      calculator.setClrDisplayBool(false);
    } else if (displayValue == "0") {
      print('Display had no value yet...');
      setDisplay(number.toString());
    } else {
      print('Added $number to display');
      setDisplay(displayValue + number.toString());
    }
  }

  setDisplay(String newDisplayValue) {
    print('Updating display...');
    displayValue = newDisplayValue;
    notifyListeners();
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
    setDisplay(newValue.toString());
  }

  startFloating() {
    if (displayValue.contains('.')) {
      return;
    } else {
      setDisplay('$displayValue.');
    }
  }
}
