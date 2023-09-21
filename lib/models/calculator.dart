class Calculator {
  double _result = 0;
  double _memoryNumber = 0;
  String _operand = '';
  bool _clearDisplay = false;

  setResult(double newResult) {
    _result = newResult;
  }

  double get result => _result;

  setMemoryNumber(double newMemoryNumber) {
    _memoryNumber = newMemoryNumber;
  }

  double get memoryNumber => _memoryNumber;

  setOperand(String operand) {
    _operand = operand;
  }

  String get operand => _operand;

  setClrDisplayBool(bool newValue) {
    _clearDisplay = newValue;
  }

  bool get clearDisplay => _clearDisplay;
}
