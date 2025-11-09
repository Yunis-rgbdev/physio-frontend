// operator_models.dart

class Operator {
  final String id;
  final String? specialty;
  final String? studentCode;
  final String? nezamPezeshkiCode;
  final String? clinicAddress;
  final String? phoneNumber;
  final String? nationalCode;

  Operator({
    required this.id,
    this.specialty,
    this.studentCode,
    this.nezamPezeshkiCode,
    this.clinicAddress,
    this.phoneNumber,
    this.nationalCode,
  });

  factory Operator.fromJson(Map<String, dynamic> json) {
    return Operator(
      id: json["id"] ?? "",
      specialty: json["specialty"],
      studentCode: json["student_code"]?.toString(),
      nezamPezeshkiCode: json["nezam_pezeshki_code"]?.toString(),
      clinicAddress: json["clinic_address"],
      phoneNumber: json["phone_number"],
      nationalCode: json["national_code"],
    );
  }
}
