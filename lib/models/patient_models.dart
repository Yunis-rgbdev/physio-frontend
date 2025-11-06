class Patient {
  final String id;
  final String? nationalCode;
  final String? fullName;
  final String? birthDate;
  final String? gender;
  final String? phoneNumber;
  final double vasScore;
  final String lastUpdate;

  Patient({
    required this.id,
    this.nationalCode,
    this.fullName,
    this.birthDate,
    this.gender,
    this.phoneNumber,
    required this.vasScore,
    required this.lastUpdate,
  });

  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
      id: json["id"] ?? "",
      nationalCode: json["national_code"],
      fullName: json["fullName"],
      birthDate: json["birth_date"],
      gender: json["gender"],
      phoneNumber: json["phone_number"],
      vasScore: json['vasScore'].toDouble(),
      lastUpdate: json['lastUpdate'],
    );
  }
}
