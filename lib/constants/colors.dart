import 'package:flutter/material.dart';

class TileColors {
  // Function to get color based on cell value
  static Color getColor(int value) {
    switch (value) {
      case 2:
        return Colors.yellow[100]!;
      case 4:
        return Colors.yellow[300]!;
      case 8:
        return Colors.orange[300]!;
      case 16:
        return Colors.orange[600]!;
      case 32:
        return Colors.red[300]!;
      case 64:
        return Colors.red[600]!;
      case 128:
        return Colors.purple[300]!;
      case 256:
        return Colors.purple[600]!;
      case 512:
        return Colors.blue[300]!;
      case 1024:
        return Colors.blue[600]!;
      case 2048:
        return Colors.green[600]!;
      case 4096:
        return Colors.amber[600]!;
      case 8192:
        return Colors.cyan[600]!;
      case 16384:
        return Colors.pink[600]!;
      case 32768:
        return Colors.teal[600]!;
      case 65536:
        return Colors.indigo[600]!;
      case 131072:
        return Colors.lime[800]!;
      default:
        return Colors.grey[300]!;
    }
  }
}
