class MorseCode {
  static final List<Pair> decodeList = [
    Pair('a', [1, 3]),
    Pair('b', [3, 1, 1, 1]),
    Pair('c', [3, 1, 3, 1]),
    Pair('d', [3, 1, 1]),
    Pair('e', [1]),
    Pair('f', [1, 1, 3, 1]),
    Pair('g', [3, 3, 1]),
    Pair('h', [1, 1, 1, 1]),
    Pair('i', [1, 1]),
    Pair('j', [1, 3, 3, 3]),
    Pair('k', [3, 1, 3]),
    Pair('l', [1, 3, 1, 1]),
    Pair('m', [3, 3]),
    Pair('n', [3, 1]),
    Pair('o', [3, 3, 3]),
    Pair('p', [1, 3, 3, 1]),
    Pair('q', [3, 3, 1, 3]),
    Pair('r', [1, 3, 1]),
    Pair('s', [1, 1, 1]),
    Pair('t', [3]),
    Pair('u', [1, 1, 3]),
    Pair('v', [1, 1, 1, 3]),
    Pair('w', [1, 3, 3]),
    Pair('x', [3, 1, 1, 3]),
    Pair('y', [3, 1, 3, 3]),
    Pair('z', [3, 3, 1, 1]),
    Pair(' ', [7]),
    Pair('1', [1, 3, 3, 3, 3]),
    Pair('2', [1, 1, 3, 3, 3]),
    Pair('3', [1, 1, 1, 3, 3]),
    Pair('4', [1, 1, 1, 1, 3]),
    Pair('5', [1, 1, 1, 1, 1]),
    Pair('6', [3, 1, 1, 1, 1]),
    Pair('7', [3, 3, 1, 1, 1]),
    Pair('8', [3, 3, 3, 1, 1]),
    Pair('9', [3, 3, 3, 3, 1]),
    Pair('d', [3, 3, 3, 3, 3]),
    Pair('stop', [1]),
    Pair('fullstop', [3]),
  ];
}

class Pair {
  final String char;
  final List<int> code;

  Pair(this.char, this.code);
}
