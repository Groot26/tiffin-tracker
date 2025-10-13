import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/tiffin_model.dart';

class StorageService {
  static const String _key = "tiffin_data";

  Future<void> saveData(List<TiffinModel> data) async {
    final prefs = await SharedPreferences.getInstance();
    final list = data.map((e) => e.toJson()).toList();
    await prefs.setString(_key, jsonEncode(list));
  }

  Future<List<TiffinModel>> loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final str = prefs.getString(_key);
    if (str == null) return [];
    final list = jsonDecode(str) as List;
    return list.map((e) => TiffinModel.fromJson(e)).toList();
  }
}
