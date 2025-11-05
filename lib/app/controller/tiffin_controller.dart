import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../data/models/tiffin_model.dart';
import '../data/services/storage_service.dart';
import 'home_widget_config.dart';

class TiffinController extends GetxController {
  var tiffins = <TiffinModel>[].obs;
  var paymentDates = <DateTime>[].obs;
  final storage = StorageService();

  @override
  void onInit() {
    super.onInit();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      HomeWidgetConfig.initialize().then((value) async {
        loadTiffins();
        loadPaymentDates();
      });
    });
  }

  List<DateTime?> getCalendarDays(DateTime month) {
    final firstDay = DateTime(month.year, month.month, 1);
    final lastDay = DateTime(month.year, month.month + 1, 0);

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

  Future<void> loadTiffins() async {
    tiffins.value = await storage.loadData();
  }

  DateTime getLastTiffinDate() {
    if (tiffins.isEmpty) return DateTime.now();

    final validDates =
        tiffins
            .where((e) => e.type != TiffinType.none)
            .map((e) => e.date)
            .toList();

    if (validDates.isEmpty) return DateTime.now();

    validDates.sort((a, b) => a.compareTo(b));
    return validDates.last;
  }

  int totalCurrentCycle() {
    DateTime from;
    if (paymentDates.isEmpty) {
      from = tiffins.isNotEmpty ? tiffins.first.date : DateTime.now();
    } else {
      from = paymentDates.last.add(Duration(days: 1));
    }

    DateTime to = getLastTiffinDate();

    return totalAmountBetween(from, to);
  }

  DateTime getCurrentCycleStart() {
    if (paymentDates.isEmpty) {
      return tiffins.isNotEmpty ? tiffins.first.date : DateTime.now();
    }
    return paymentDates.last.add(Duration(days: 1));
  }

  DateTime getCurrentCycleEnd() {
    return getLastTiffinDate();
  }

  Future<void> loadPaymentDates() async {
    final loaded = await storage.loadPaymentDates();
    loaded.sort((a, b) => a.compareTo(b));
    paymentDates.value = loaded;
  }

  Future<void> updateTiffin({
    required DateTime date,
    required TiffinType type,
    required BuildContext context,
    required TiffinController controller,
    required List<DateTime?> days,
  }) async {
    final index = tiffins.indexWhere(
      (e) =>
          e.date.year == date.year &&
          e.date.month == date.month &&
          e.date.day == date.day,
    );

    if (index >= 0) {
      tiffins[index].type = type;
    } else {
      tiffins.add(TiffinModel(date: date, type: type));
    }

    await storage.saveData(tiffins);
    tiffins.refresh();

    // HomeWidgetConfig.update(
    //   context,
    // CalendarWidget(controller: controller, days: days),
    // );
  }

  Future<void> togglePaymentDate(DateTime date) async {
    final existsIndex = paymentDates.indexWhere(
      (d) => d.year == date.year && d.month == date.month && d.day == date.day,
    );

    if (existsIndex >= 0) {
      paymentDates.removeAt(existsIndex);
    } else {
      paymentDates.add(
        DateTime(date.year, date.month, date.day),
      ); // normalize time
      paymentDates.sort((a, b) => a.compareTo(b));
    }

    await storage.savePaymentDates(paymentDates);
    paymentDates.refresh();
  }

  Future<void> addPaymentDate(DateTime date) async {
    final normalized = DateTime(date.year, date.month, date.day);
    if (!paymentDates.any((d) => d == normalized)) {
      paymentDates.add(normalized);
      paymentDates.sort((a, b) => a.compareTo(b));
      await storage.savePaymentDates(paymentDates);
      paymentDates.refresh();
    }
  }

  Future<void> removePaymentDate(DateTime date) async {
    paymentDates.removeWhere(
      (d) => d.year == date.year && d.month == date.month && d.day == date.day,
    );
    await storage.savePaymentDates(paymentDates);
    paymentDates.refresh();
  }

  // existing summary helpers...
  int totalVegInMonth(DateTime month) {
    return tiffins
        .where((t) => t.date.year == month.year && t.date.month == month.month)
        .where((t) => t.type == TiffinType.veg)
        .length;
  }

  int totalNonVegInMonth(DateTime month) {
    return tiffins
        .where((t) => t.date.year == month.year && t.date.month == month.month)
        .where((t) => t.type == TiffinType.nonVeg)
        .length;
  }

  int totalDaysInMonth(DateTime month) {
    return tiffins
        .where(
          (t) =>
              t.date.year == month.year &&
              t.date.month == month.month &&
              (t.type == TiffinType.veg || t.type == TiffinType.nonVeg),
        )
        .length;
  }

  int totalAmountInMonth(DateTime month) {
    int vegCount = totalVegInMonth(month);
    int nonVegCount = totalNonVegInMonth(month);
    return vegCount * 80 + nonVegCount * 100;
  }

  int totalAmountBetween(DateTime from, DateTime to) {
    final start = DateTime(from.year, from.month, from.day);
    final end = DateTime(to.year, to.month, to.day, 23, 59, 59);

    int vegCount =
        tiffins
            .where((t) => !t.date.isBefore(start) && !t.date.isAfter(end))
            .where((t) => t.type == TiffinType.veg)
            .length;

    int nonVegCount =
        tiffins
            .where((t) => !t.date.isBefore(start) && !t.date.isAfter(end))
            .where((t) => t.type == TiffinType.nonVeg)
            .length;

    return vegCount * 80 + nonVegCount * 100;
  }
}
