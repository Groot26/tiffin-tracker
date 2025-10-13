enum TiffinType { none, veg, nonVeg }

class TiffinModel {
  final DateTime date;
  TiffinType type;

  TiffinModel({required this.date, this.type = TiffinType.none});

  Map<String, dynamic> toJson() => {
    "date": date.toIso8601String(),
    "type": type.index,
  };

  factory TiffinModel.fromJson(Map<String, dynamic> json) {
    return TiffinModel(
      date: DateTime.parse(json["date"]),
      type: TiffinType.values[json["type"]],
    );
  }
}
