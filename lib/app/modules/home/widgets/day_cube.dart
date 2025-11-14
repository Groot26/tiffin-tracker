import 'package:flutter/material.dart';

import '../../../data/models/tiffin_model.dart';

class DayCube extends StatelessWidget {
  final DateTime date;
  final TiffinType type;
  final VoidCallback onTap;
  final bool isPaymentDay;

  const DayCube({
    super.key,
    required this.date,
    required this.type,
    required this.onTap,
    this.isPaymentDay = false,
  });

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    if (type == TiffinType.veg) {
      bgColor = Colors.green;
    } else if (type == TiffinType.nonVeg) {
      bgColor = Colors.red;
    } else {
      bgColor = Colors.grey.shade300;
    }

    BoxBorder? border;
    if (isPaymentDay) {
      border = Border.all(color: Colors.amber.shade700, width: 3);
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: bgColor,
          border: border,
          borderRadius: BorderRadius.circular(6),
          boxShadow: [
            if (isPaymentDay)
              BoxShadow(
                color: Colors.amber.withOpacity(0.4),
                blurRadius: 4,
                spreadRadius: 1,
              ),
          ],
        ),
        child: Center(
          child: Text(
            "${date.day}",
            style: TextStyle(
              color: type == TiffinType.none ? Colors.black87 : Colors.white,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
