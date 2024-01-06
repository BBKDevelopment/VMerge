import 'package:flutter/material.dart';

enum AppColor {
  red,
  pink,
  purple,
  indigo,
  blue,
  cyan,
  teal,
  green,
  lime,
  yellow,
  orange,
  brown;

  Color get value {
    switch (this) {
      case red:
        return Colors.red;
      case pink:
        return Colors.pink;
      case purple:
        return Colors.purple;
      case indigo:
        return Colors.indigo;
      case blue:
        return Colors.blue;
      case cyan:
        return Colors.cyan;
      case teal:
        return Colors.teal;
      case green:
        return Colors.green;
      case lime:
        return Colors.lime;
      case yellow:
        return Colors.yellow;
      case orange:
        return Colors.orange;
      case brown:
        return Colors.brown;
    }
  }
}
