import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/tiffin_model.dart';

class StorageService {
  static const String _tiffinKey = "tiffin_data";
  static const String _paymentDatesKey = "payment_dates";

  Future<void> saveData(List<TiffinModel> data) async {
    final prefs = await SharedPreferences.getInstance();
    final list = data.map((e) => e.toJson()).toList();
    await prefs.setString(_tiffinKey, jsonEncode(list));
  }

  Future<List<TiffinModel>> loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final str = prefs.getString(_tiffinKey);
    if (str == null) return [];
    final list = jsonDecode(str) as List;
    return list.map((e) => TiffinModel.fromJson(e)).toList();
  }

  Future<void> savePaymentDates(List<DateTime> dates) async {
    final prefs = await SharedPreferences.getInstance();
    final list = dates.map((d) => d.toIso8601String()).toList();
    await prefs.setString(_paymentDatesKey, jsonEncode(list));
  }

  Future<List<DateTime>> loadPaymentDates() async {
    final prefs = await SharedPreferences.getInstance();
    final str = prefs.getString(_paymentDatesKey);
    if (str == null) return [];
    final list = jsonDecode(str) as List;
    return list.map<DateTime>((e) => DateTime.parse(e as String)).toList();
  }
}
