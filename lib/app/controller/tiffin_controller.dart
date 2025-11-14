import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../data/models/tiffin_model.dart';
import '../data/services/storage_service.dart';
import 'home_widget_config.dart';

class TiffinController extends GetxController {
  final storage = StorageService();

  var tiffins = <TiffinModel>[].obs;
  var paymentDates = <DateTime>[].obs;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await HomeWidgetConfig.initialize();
      await _loadInitialData();
    });
  }

  Future<void> _loadInitialData() async {
    await loadTiffins();
    await loadPaymentDates();
  }

  List<DateTime?> getCalendarDays(DateTime month) {
    final firstDay = DateTime(month.year, month.month, 1);
    final totalDays = DateTime(month.year, month.month + 1, 0).day;

    final leadingNulls = List<DateTime?>.filled(firstDay.weekday % 7, null);
    final monthDays = List<DateTime?>.generate(
      totalDays,
      (i) => DateTime(month.year, month.month, i + 1),
    );

    return [...leadingNulls, ...monthDays];
  }

  Future<void> loadTiffins() async {
    tiffins.value = await storage.loadData();
  }

  DateTime getLastTiffinDate() => DateTime.now();

  int totalCurrentCycle() {
    final start = getCurrentCycleStart();
    final end = getCurrentCycleEnd();
    return totalAmountBetween(start, end);
  }

  DateTime getCurrentCycleStart() {
    if (paymentDates.isEmpty) {
      return tiffins.isNotEmpty ? tiffins.first.date : DateTime.now();
    }
    return paymentDates.last.add(const Duration(days: 1));
  }

  DateTime getCurrentCycleEnd() => getLastTiffinDate();

  Future<void> loadPaymentDates() async {
    final loaded = await storage.loadPaymentDates();
    loaded.sort();
    paymentDates.value = loaded;
  }

  Future<void> updateTiffin({
    required DateTime date,
    required TiffinType type,
  }) async {
    final index = tiffins.indexWhere((e) => _isSameDate(e.date, date));

    if (index >= 0) {
      tiffins[index].type = type;
    } else {
      tiffins.add(TiffinModel(date: date, type: type));
    }

    await storage.saveData(tiffins);
    tiffins.refresh();
  }

  Future<void> togglePaymentDate(DateTime date) async {
    final normalized = _normalize(date);
    final index = paymentDates.indexWhere((d) => _isSameDate(d, normalized));

    if (index >= 0) {
      paymentDates.removeAt(index);
    } else {
      paymentDates.add(normalized);
      paymentDates.sort();
    }

    await storage.savePaymentDates(paymentDates);
    paymentDates.refresh();
  }

  Future<void> addPaymentDate(DateTime date) async {
    final normalized = _normalize(date);
    if (paymentDates.any((d) => _isSameDate(d, normalized))) return;

    paymentDates.add(normalized);
    paymentDates.sort();

    await storage.savePaymentDates(paymentDates);
    paymentDates.refresh();
  }

  Future<void> removePaymentDate(DateTime date) async {
    paymentDates.removeWhere((d) => _isSameDate(d, date));
    await storage.savePaymentDates(paymentDates);
    paymentDates.refresh();
  }

  int totalVegInMonth(DateTime month) => _countByType(month, TiffinType.veg);

  int totalNonVegInMonth(DateTime month) =>
      _countByType(month, TiffinType.nonVeg);

  int totalDaysInMonth(DateTime month) {
    return tiffins
        .where((t) => t.date.year == month.year && t.date.month == month.month)
        .where((t) => t.type == TiffinType.veg || t.type == TiffinType.nonVeg)
        .length;
  }

  int totalAmountInMonth(DateTime month) {
    return totalVegInMonth(month) * 80 + totalNonVegInMonth(month) * 100;
  }

  int totalAmountBetween(DateTime from, DateTime to) {
    final start = _normalize(from);
    final end = DateTime(to.year, to.month, to.day, 23, 59, 59);

    final veg = _countBetween(start, end, TiffinType.veg);
    final nonVeg = _countBetween(start, end, TiffinType.nonVeg);

    return veg * 80 + nonVeg * 100;
  }

  int _countByType(DateTime month, TiffinType type) {
    return tiffins
        .where((t) => t.date.year == month.year && t.date.month == month.month)
        .where((t) => t.type == type)
        .length;
  }

  int _countBetween(DateTime from, DateTime to, TiffinType type) {
    return tiffins
        .where((t) => !t.date.isBefore(from) && !t.date.isAfter(to))
        .where((t) => t.type == type)
        .length;
  }

  bool _isSameDate(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  DateTime _normalize(DateTime date) =>
      DateTime(date.year, date.month, date.day);
}
