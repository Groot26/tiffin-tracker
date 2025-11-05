import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/tiffin_controller.dart';
import '../../../data/models/tiffin_model.dart';

// class MiniCalendarWidget extends StatelessWidget {
//   final List<TiffinModel> tiffins;
//   final List<DateTime> paymentDates;
//   final double? width;
//   final double? height;
//
//   const MiniCalendarWidget({
//     super.key,
//     required this.tiffins,
//     required this.paymentDates,
//     this.width,
//     this.height,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     if (tiffins.isEmpty) {
//       return const Center(child: Text("No data"));
//     }
//
//     final firstDate = tiffins.first.date;
//     final daysInMonth = DateUtils.getDaysInMonth(
//       firstDate.year,
//       firstDate.month,
//     );
//     final firstWeekday = DateTime(firstDate.year, firstDate.month, 1).weekday;
//
//     // Generate days (null for leading empty slots)
//     final days = List<DateTime?>.generate(daysInMonth + (firstWeekday % 7), (
//       i,
//     ) {
//       if (i < (firstWeekday % 7)) return null;
//       return DateTime(
//         firstDate.year,
//         firstDate.month,
//         i - (firstWeekday % 7) + 1,
//       );
//     });
//
//     return SizedBox(
//       width: width ?? 300,
//       height: height ?? 300,
//       child: LayoutBuilder(
//         builder: (context, constraints) {
//           final totalWidth = constraints.maxWidth;
//           final totalHeight = constraints.maxHeight;
//
//           const crossAxisCount = 7;
//           const spacing = 2.0;
//           final rows = (days.length / crossAxisCount).ceil();
//
//           final cellWidth =
//               (totalWidth - spacing * (crossAxisCount - 1)) / crossAxisCount;
//           final cellHeight = (totalHeight - spacing * (rows - 1)) / rows;
//
//           return Wrap(
//             spacing: spacing,
//             runSpacing: spacing,
//             children: List.generate(days.length, (index) {
//               final date = days[index];
//               if (date == null) {
//                 // Empty day slot
//                 return SizedBox(width: cellWidth, height: cellHeight);
//               }
//
//               // Find tiffin model for this day
//               final tiffin = tiffins.firstWhere(
//                 (e) =>
//                     e.date.year == date.year &&
//                     e.date.month == date.month &&
//                     e.date.day == date.day,
//                 orElse: () => TiffinModel(date: date, type: TiffinType.none),
//               );
//
//               // Background color based on type
//               Color bgColor;
//               if (tiffin.type == TiffinType.veg) {
//                 bgColor = Colors.green;
//               } else if (tiffin.type == TiffinType.nonVeg) {
//                 bgColor = Colors.red;
//               } else {
//                 bgColor = Colors.grey.shade300;
//               }
//
//               // Payment day highlight
//               final isPaymentDay = paymentDates.any(
//                 (d) =>
//                     d.year == date.year &&
//                     d.month == date.month &&
//                     d.day == date.day,
//               );
//
//               BoxBorder? border;
//               if (isPaymentDay) {
//                 border = Border.all(color: Colors.amber.shade700, width: 2);
//               }
//
//               return Container(
//                 width: cellWidth,
//                 height: cellHeight,
//                 decoration: BoxDecoration(
//                   color: bgColor,
//                   border: border,
//                   borderRadius: BorderRadius.circular(6),
//                   boxShadow: [
//                     if (isPaymentDay)
//                       BoxShadow(
//                         color: Colors.amber.withOpacity(0.4),
//                         blurRadius: 3,
//                         spreadRadius: 0.5,
//                       ),
//                   ],
//                 ),
//                 alignment: Alignment.center,
//                 child: Text(
//                   '${date.day}',
//                   style: TextStyle(
//                     color:
//                         tiffin.type == TiffinType.none
//                             ? Colors.black87
//                             : Colors.white,
//                     fontSize: 13,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//               );
//             }),
//           );
//         },
//       ),
//     );
//   }
// }

class MiniCalendarWidget extends StatelessWidget {
  // final List<DateTime?> days;
  final List<TiffinModel> tiffins;
  final List<DateTime> paymentDates;
  final double? width;
  final double? height;

  const MiniCalendarWidget({
    super.key,
    // required this.days,
    required this.tiffins,
    required this.paymentDates,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    TiffinController controller = Get.put(TiffinController());

    DateTime currentMonth = DateTime.now();
    final days = controller.getCalendarDays(currentMonth);

    if (days.isEmpty) {
      return const Center(child: Text("No data"));
    }

    return SizedBox(
      width: width ?? 300,
      height: height ?? 300,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final totalWidth = constraints.maxWidth;
          final totalHeight = constraints.maxHeight;

          const crossAxisCount = 7;
          const spacing = 2.0;
          final rows = (days.length / crossAxisCount).ceil();

          final cellWidth =
              (totalWidth - spacing * (crossAxisCount - 1)) / crossAxisCount;
          final cellHeight = (totalHeight - spacing * (rows - 1)) / rows;

          return Wrap(
            spacing: spacing,
            runSpacing: spacing,
            children: List.generate(days.length, (index) {
              final date = days[index];
              if (date == null) {
                // Empty slot before month start
                return SizedBox(width: cellWidth, height: cellHeight);
              }

              // Find matching tiffin model
              final tiffin = tiffins.firstWhere(
                (e) =>
                    e.date.year == date.year &&
                    e.date.month == date.month &&
                    e.date.day == date.day,
                orElse: () => TiffinModel(date: date, type: TiffinType.none),
              );

              // Background color logic
              Color bgColor;
              if (tiffin.type == TiffinType.veg) {
                bgColor = Colors.green;
              } else if (tiffin.type == TiffinType.nonVeg) {
                bgColor = Colors.red;
              } else {
                bgColor = Colors.grey.shade300;
              }

              // Payment day highlight
              final isPaymentDay = paymentDates.any(
                (d) =>
                    d.year == date.year &&
                    d.month == date.month &&
                    d.day == date.day,
              );

              BoxBorder? border;
              if (isPaymentDay) {
                border = Border.all(color: Colors.amber.shade700, width: 2);
              }

              return Container(
                width: cellWidth,
                height: cellHeight,
                decoration: BoxDecoration(
                  color: bgColor,
                  border: border,
                  borderRadius: BorderRadius.circular(6),
                  boxShadow: [
                    if (isPaymentDay)
                      BoxShadow(
                        color: Colors.amber.withOpacity(0.4),
                        blurRadius: 3,
                        spreadRadius: 0.5,
                      ),
                  ],
                ),
                alignment: Alignment.center,
                child: Text(
                  '${date.day}',
                  style: TextStyle(
                    color:
                        tiffin.type == TiffinType.none
                            ? Colors.black87
                            : Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              );
            }),
          );
        },
      ),
    );
  }
}
