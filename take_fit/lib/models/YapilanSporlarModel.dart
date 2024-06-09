class YapilanSporlarModel {
  final int? id;
  final String? spor_name;
  double? consumed_kcal;
  int? step_value;
  int? spent_time;
  final String date_and_time;
  YapilanSporlarModel({
    required this.id,
    required this.spor_name,
    required this.consumed_kcal,
    required this.step_value,
    required this.spent_time,
    required this.date_and_time,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'spor_name': spor_name,
      'consumed_kcal': consumed_kcal,
      'step_value': step_value,
      'spent_time': spent_time,
      'date_and_time': date_and_time,
    };
  }

  factory YapilanSporlarModel.fromJson(Map<String, dynamic> json) {
    return YapilanSporlarModel(
      id: json['id'],
      spor_name: json['spor_name'],
      consumed_kcal: json['consumed_kcal'],
      step_value: json['step_value'],
      spent_time: json['spent_time'],
      date_and_time: json['date_and_time'],
    );
  }
}
