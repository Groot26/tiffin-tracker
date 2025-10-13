import 'package:flutter/material.dart';

import '../../../data/models/tiffin_model.dart';

class DayCube extends StatelessWidget {
  final DateTime date;
  final TiffinType type;
  final VoidCallback onTap;

  const DayCube(
      {super.key, required this.date, required this.type, required this.onTap});

  @override
  Widget build(BuildContext context) {
    Color color;
    switch (type) {
      case TiffinType.veg:
        color = Colors.green;
        break;
      case TiffinType.nonVeg:
        color = Colors.red;
        break;
      default:
        color = Colors.grey.shade300;
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Center(
          child: Text(
            "${date.day}",
            style: TextStyle(
              color: type == TiffinType.none ? Colors.black54 : Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}