import 'package:get/get.dart';
import '../data/models/tiffin_model.dart';
import '../data/services/storage_service.dart';

class TiffinController extends GetxController {
  var tiffins = <TiffinModel>[].obs;
  final storage = StorageService();

  @override
  void onInit() {
    super.onInit();
    loadTiffins();
  }

  Future<void> loadTiffins() async {
    tiffins.value = await storage.loadData();
  }

  Future<void> updateTiffin(DateTime date, TiffinType type) async {
    final index = tiffins.indexWhere((e) =>
    e.date.year == date.year &&
        e.date.month == date.month &&
        e.date.day == date.day);

    if (index >= 0) {
      tiffins[index].type = type;
    } else {
      tiffins.add(TiffinModel(date: date, type: type));
    }

    await storage.saveData(tiffins);
    tiffins.refresh();

  }


  int get totalVeg => tiffins.where((e) => e.type == TiffinType.veg).length;
  int get totalNonVeg =>
      tiffins.where((e) => e.type == TiffinType.nonVeg).length;
  int get totalDays => tiffins.where((e) => e.type != TiffinType.none).length;


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
    return tiffins.where((t) =>
    t.date.year == month.year &&
        t.date.month == month.month &&
        (t.type == TiffinType.veg || t.type == TiffinType.nonVeg)
    ).length;
  }

  int totalAmountInMonth(DateTime month) {
    int vegCount = totalVegInMonth(month);
    int nonVegCount = totalNonVegInMonth(month);
    return vegCount * 80 + nonVegCount * 100;
  }

}