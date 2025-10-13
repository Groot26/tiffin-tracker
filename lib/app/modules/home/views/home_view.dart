import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiffin/app/modules/home/controllers/home_controller.dart';

import '../../../controller/tiffin_controller.dart';
import '../../../data/models/tiffin_model.dart';
import '../widgets/day_cube.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final controller = Get.put(TiffinController());
  final home = Get.put(HomeController());
  DateTime currentMonth = DateTime.now();

  // Generate all days of the month with padding for weekdays
  List<DateTime?> getCalendarDays(DateTime month) {
    final firstDay = DateTime(month.year, month.month, 1);
    final lastDay = DateTime(month.year, month.month + 1, 0);

    // Create a growable list with padding for weekdays
    List<DateTime?> days = List<DateTime?>.filled(
      firstDay.weekday % 7,
      null,
      growable: true,
    );

    for (int i = 1; i <= lastDay.day; i++) {
      days.add(DateTime(month.year, month.month, i));
    }

    return days;
  }

  void changeMonth(int offset) {
    setState(() {
      currentMonth = DateTime(
        currentMonth.year,
        currentMonth.month + offset,
        1,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final days = getCalendarDays(currentMonth);

    return Scaffold(
      appBar: AppBar(title: Text("Tiffin Tracker"), centerTitle: true),
      body: Column(
        children: [
          // Month Selector
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () => changeMonth(-1),
                icon: Icon(Icons.arrow_left),
              ),
              Text(
                "${home.monthNames[currentMonth.month - 1]} - ${currentMonth.year}",
              ),
              IconButton(
                onPressed: () => changeMonth(1),
                icon: Icon(Icons.arrow_right),
              ),
            ],
          ),

          // Weekday Labels
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children:
                [
                  "Sun",
                  "Mon",
                  "Tue",
                  "Wed",
                  "Thu",
                  "Fri",
                  "Sat",
                ].map((d) => Expanded(child: Center(child: Text(d)))).toList(),
          ),

          // Calendar Grid
          GridView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.all(4),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              crossAxisSpacing: 4,
              mainAxisSpacing: 4,
            ),
            itemCount: days.length,
            itemBuilder: (context, index) {
              final date = days[index];
              if (date == null) return SizedBox.shrink();

              return Obx(() {
                // Reactive access
                final tiffinType =
                    controller.tiffins
                        .firstWhereOrNull(
                          (e) =>
                              e.date.year == date.year &&
                              e.date.month == date.month &&
                              e.date.day == date.day,
                        )
                        ?.type ??
                    TiffinType.none;

                return DayCube(
                  date: date,
                  type: tiffinType,
                  onTap: () {
                    Get.bottomSheet(
                      Container(
                        color: Colors.white,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ListTile(
                              title: Text("Veg (₹80)"),
                              onTap: () {
                                controller.updateTiffin(date, TiffinType.veg);
                                Get.back();
                              },
                            ),
                            ListTile(
                              title: Text("Non-Veg (₹100)"),
                              onTap: () {
                                controller.updateTiffin(
                                  date,
                                  TiffinType.nonVeg,
                                );
                                Get.back();
                              },
                            ),
                            ListTile(
                              title: Text("Clear"),
                              onTap: () {
                                controller.updateTiffin(date, TiffinType.none);
                                Get.back();
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              });
            },
          ),

          // Summary Card
          Obx(() {
            int veg = controller.totalVegInMonth(currentMonth);
            int nonVeg = controller.totalNonVegInMonth(currentMonth);
            int total = controller.totalDaysInMonth(currentMonth);
            int amount = controller.totalAmountInMonth(currentMonth);

            return Padding(
              padding: const EdgeInsets.all(12.0),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 5,
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      // Top row: Veg & Non-Veg
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _summaryItem("Veg", veg.toString(), Colors.green),
                          _summaryItem(
                            "Non-Veg",
                            nonVeg.toString(),
                            Colors.red,
                          ),
                          _summaryItem(
                            "Days",
                            total.toString(),
                            Colors.blueGrey,
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      // Big Total Amount
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Total ₹: ",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          Text(
                            "$amount",
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange.shade700,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

// Helper widget for Veg/Non-Veg/Days
Widget _summaryItem(String title, String value, Color color) {
  return Column(
    children: [
      Text(
        title,
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
      ),
      SizedBox(height: 6),
      Container(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.8),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    ],
  );
}
