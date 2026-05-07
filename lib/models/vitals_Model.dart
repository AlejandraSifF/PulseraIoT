class VitalsModel {
  final double? hr;
  final double? spo2;
  final double? temp;

  final String hrCat;
  final String spo2Cat;
  final String tempCat;

  VitalsModel({
    required this.hr,
    required this.spo2,
    required this.temp,
    required this.hrCat,
    required this.spo2Cat,
    required this.tempCat,
  });

  factory VitalsModel.fromJson(Map<String, dynamic> json) {
    return VitalsModel(
      hr: json['hr']?.toDouble(),
      spo2: json['spo2']?.toDouble(),
      temp: json['temp']?.toDouble(),
      hrCat: json['hr_cat'],
      spo2Cat: json['spo2_cat'],
      tempCat: json['temp_cat'],
    );
  }
}