class Nutrien_Data_Model {
  int? id;
  int? su_miktari;
  int? karbonhidrat_miktari;
  int? protein_miktari;
  int? yag_miktari;
  int? kahvalti_kcal;
  int? ogle_yemegi_kcal;
  int? aksam_yemegi_kcal;
  String? tarih;

  Nutrien_Data_Model({
    required this.id,
    required this.su_miktari,
    required this.karbonhidrat_miktari,
    required this.protein_miktari,
    required this.yag_miktari,
    required this.kahvalti_kcal,
    required this.ogle_yemegi_kcal,
    required this.aksam_yemegi_kcal,
    required this.tarih,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'su_miktari': su_miktari,
      'karbonhidrat_miktari': karbonhidrat_miktari,
      'protein_miktari': protein_miktari,
      'yag_miktari': yag_miktari,
      'kahvalti_kcal': kahvalti_kcal,
      'ogle_yemegi_kcal': ogle_yemegi_kcal,
      'aksam_yemegi_kcal': aksam_yemegi_kcal,
      'tarih': tarih,
    };
  }

  factory Nutrien_Data_Model.fromJson(Map<String, dynamic> json) {
    return Nutrien_Data_Model(
      id: json['id'],
      su_miktari: json['su_miktari'],
      karbonhidrat_miktari: json['karbonhidrat_miktari'],
      protein_miktari: json['protein_miktari'],
      yag_miktari: json['yag_miktari'],
      kahvalti_kcal: json['kahvalti_kcal'],
      ogle_yemegi_kcal: json['ogle_yemegi_kcal'],
      aksam_yemegi_kcal: json['aksam_yemegi_kcal'],
      tarih: json['tarih'],
    );
  }
}
