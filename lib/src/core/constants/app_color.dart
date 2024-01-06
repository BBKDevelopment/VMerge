import 'package:flutter/material.dart';

enum AppColor {
  red,
  green,
  blue,
  yellow,
  purple,
  orange,
  pink,
  teal,
  indigo,
  cyan,
  lime,
  brown;

  Color get value {
    switch (this) {
      case red:
        return Colors.red;
      case green:
        return Colors.green;
      case blue:
        return Colors.blue;
      case yellow:
        return Colors.yellow;
      case purple:
        return Colors.purple;
      case orange:
        return Colors.orange;
      case pink:
        return Colors.pink;
      case teal:
        return Colors.teal;
      case indigo:
        return Colors.indigo;
      case cyan:
        return Colors.cyan;
      case lime:
        return Colors.lime;
      case brown:
        return Colors.brown;
    }
  }
}
