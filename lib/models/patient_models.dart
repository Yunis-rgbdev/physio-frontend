class Patient {
  final String id;
  final String? nationalCode;
  final String? birthDate;
  final String? gender;
  final String? phoneNumber;

  Patient({
    required this.id,
    this.nationalCode,
    this.birthDate,
    this.gender,
    this.phoneNumber,
  });

  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
      id: json["id"] ?? "",
      nationalCode: json["national_code"],
      birthDate: json["birth_date"],
      gender: json["gender"],
      phoneNumber: json["phone_number"],
    );
  }
}
