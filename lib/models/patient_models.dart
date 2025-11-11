// patient_models.dart

class Patient {
  final String id;
  final String? nationalCode;
  final String? fullName;
  final String? birthDate;
  final String? gender;
  final String? phoneNumber;
  final bool? isActive;
  final double vasScore;
  final String? lastUpdate;

  Patient({
    required this.id,
    this.nationalCode,
    this.fullName,
    this.birthDate,
    this.gender,
    this.phoneNumber,
    this.isActive,
    required this.vasScore,
    this.lastUpdate,
  });

  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
      id: json["id"] ?? "",
      nationalCode: json["national_code"],
      fullName: json["full_name"],
      birthDate: json["birth_date"],
      gender: json["gender"],
      isActive: json["is_active"],
      phoneNumber: json["phone_number"],
      vasScore: (json['vasScore'] ?? 0).toDouble(),
      lastUpdate: json['lastUpdate'] ?? '',
    );
  }
}
