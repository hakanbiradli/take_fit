class StepCounterModel{
  int? id;
  int? adim_sayisi;
  String? tarih;

  StepCounterModel({
    required this.id,
    required this.adim_sayisi,
    required this.tarih,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'adim_sayisi': adim_sayisi,
      'tarih': tarih,
    };
  }
  factory StepCounterModel.fromJson(Map<String, dynamic> json) {
    return StepCounterModel(
      id: json['id'],
      adim_sayisi: json['adim_sayisi'],
      tarih: json['tarih'],
    );
  }

}