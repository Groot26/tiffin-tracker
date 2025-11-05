// class CalendarWidget extends StatelessWidget {
//   final TiffinController controller;
//   final List<DateTime?> days;
//
//   const CalendarWidget({
//     super.key,
//     required this.controller,
//     required this.days,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           children:
//               [
//                 "Sun",
//                 "Mon",
//                 "Tue",
//                 "Wed",
//                 "Thu",
//                 "Fri",
//                 "Sat",
//               ].map((d) => Expanded(child: Center(child: Text(d)))).toList(),
//         ),
//
//         GridView.builder(
//           shrinkWrap: true,
//           padding: const EdgeInsets.all(4),
//           gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//             crossAxisCount: 7,
//             crossAxisSpacing: 4,
//             mainAxisSpacing: 4,
//           ),
//           itemCount: days.length,
//           itemBuilder: (context, index) {
//             final date = days[index];
//             if (date == null) return const SizedBox.shrink();
//
//             return Obx(() {
//               final tiffinType =
//                   controller.tiffins
//                       .firstWhereOrNull(
//                         (e) =>
//                             e.date.year == date.year &&
//                             e.date.month == date.month &&
//                             e.date.day == date.day,
//                       )
//                       ?.type ??
//                   TiffinType.none;
//
//               final isPaymentDay = controller.paymentDates.any(
//                 (d) =>
//                     d.year == date.year &&
//                     d.month == date.month &&
//                     d.day == date.day,
//               );
//
//               return DayCube(
//                 date: date,
//                 type: tiffinType,
//                 isPaymentDay: isPaymentDay,
//                 onTap: () {
//                   Get.bottomSheet(
//                     Container(
//                       color: Colors.white,
//                       child: Column(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           ListTile(
//                             title: const Text("Veg (₹80)"),
//                             onTap: () {
//                               // controller.updateTiffin(date, TiffinType.veg);
//                               controller.updateTiffin(
//                                 context: context,
//                                 date: date,
//                                 type: TiffinType.veg,
//                                 controller: controller,
//                                 days: days,
//                               );
//                               Get.back();
//                               HomeWidgetConfig.update(
//                                 context,
//                                 CalendarWidget(
//                                   controller: controller,
//                                   days: days,
//                                 ),
//                               );
//                             },
//                           ),
//                           ListTile(
//                             title: const Text("Non-Veg (₹100)"),
//                             onTap: () {
//                               // controller.updateTiffin(date, TiffinType.nonVeg);
//                               controller.updateTiffin(
//                                 context: context,
//                                 date: date,
//                                 type: TiffinType.nonVeg,
//                                 controller: controller,
//                                 days: days,
//                               );
//                               Get.back();
//                               HomeWidgetConfig.update(
//                                 context,
//                                 CalendarWidget(
//                                   controller: controller,
//                                   days: days,
//                                 ),
//                               );
//                             },
//                           ),
//                           ListTile(
//                             title: const Text("Clear"),
//                             onTap: () {
//                               // controller.updateTiffin(date, TiffinType.none);
//                               controller.updateTiffin(
//                                 context: context,
//                                 date: date,
//                                 type: TiffinType.none,
//                                 controller: controller,
//                                 days: days,
//                               );
//                               Get.back();
//                               HomeWidgetConfig.update(
//                                 context,
//                                 CalendarWidget(
//                                   controller: controller,
//                                   days: days,
//                                 ),
//                               );
//                             },
//                           ),
//                           ListTile(
//                             title: const Text("Mark / Unmark Payment Day"),
//                             onTap: () {
//                               controller.togglePaymentDate(date);
//                               Get.back();
//                               HomeWidgetConfig.update(
//                                 context,
//                                 CalendarWidget(
//                                   controller: controller,
//                                   days: days,
//                                 ),
//                               );
//                             },
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               );
//             });
//           },
//         ),
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../controller/home_widget_config.dart';
import '../../../controller/tiffin_controller.dart';
import '../../../data/models/tiffin_model.dart';
import 'day_cube.dart';
import 'mini_calendar_widget.dart';

class CalendarWidget extends StatelessWidget {
  final TiffinController controller;
  final List<DateTime?> days;

  const CalendarWidget({
    super.key,
    required this.controller,
    required this.days,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Weekday Header
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children:
                  ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
                      .map(
                        (d) => Expanded(
                          child: Center(
                            child: Text(
                              d,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13.sp,
                                color: Colors.grey[800],
                              ),
                            ),
                          ),
                        ),
                      )
                      .toList(),
            ),
          ),

          // Calendar Grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.all(4.w),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              crossAxisSpacing: 4.w,
              mainAxisSpacing: 4.h,
              childAspectRatio: 1,
            ),
            itemCount: days.length,
            itemBuilder: (context, index) {
              final date = days[index];
              if (date == null) return const SizedBox.shrink();

              return Obx(() {
                final tiffinModel =
                    controller.tiffins.firstWhereOrNull(
                      (e) =>
                          e.date.year == date.year &&
                          e.date.month == date.month &&
                          e.date.day == date.day,
                    ) ??
                    TiffinModel(date: date, type: TiffinType.none);

                final isPaymentDay = controller.paymentDates.any(
                  (d) =>
                      d.year == date.year &&
                      d.month == date.month &&
                      d.day == date.day,
                );

                return DayCube(
                  date: date,
                  type: tiffinModel.type,
                  isPaymentDay: isPaymentDay,
                  onTap:
                      () => _showOptionsBottomSheet(
                        context,
                        date,
                        tiffinModel.type,
                      ),
                );
              });
            },
          ),
        ],
      ),
    );
  }

  void _showOptionsBottomSheet(
    BuildContext context,
    DateTime date,
    TiffinType currentType,
  ) {
    final items = <MapEntry<String, TiffinType>>[
      MapEntry("Veg (₹80)", TiffinType.veg),
      MapEntry("Non-Veg (₹100)", TiffinType.nonVeg),
      MapEntry("Clear", TiffinType.none),
    ];

    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(8.w),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: SafeArea(
          child: Wrap(
            children: [
              ...items.map(
                (item) => _bottomSheetTile(
                  title: item.key,
                  onTap: () {
                    controller.updateTiffin(
                      // keep your controller signature (you had context, controller, days)
                      context: context,
                      date: date,
                      type: item.value,
                      controller: controller,
                      days: days,
                    );
                    _updateWidgetAfterClose(context, item.value);
                  },
                ),
              ),
              _bottomSheetTile(
                title: "Mark / Unmark Payment Day",
                onTap: () {
                  controller.togglePaymentDate(date);
                  _updateWidgetAfterClose(context, currentType);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _bottomSheetTile({
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      title: Text(title, style: TextStyle(fontSize: 14.sp)),
      onTap: onTap,
    );
  }

  void _updateWidgetAfterClose(BuildContext context, TiffinType tiffinType) {
    Get.back();
    Future.delayed(const Duration(milliseconds: 0), () async {
      await HomeWidgetConfig.update(
        context,
        MiniCalendarWidget(
          // days: days,
          tiffins: controller.tiffins,
          paymentDates: controller.paymentDates,
        ),
      );
    });
  }
}
