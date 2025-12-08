class ActiveSession {
  final String patientNationalCode;
  final int vasScore;
  final String doctorNote;

  ActiveSession({
    required this.patientNationalCode,
    required this.vasScore,
    required this.doctorNote
  });

  factory ActiveSession.fromJson(Map<String, dynamic> json) {
    return ActiveSession(
      patientNationalCode: json["patient_national_code"],
      vasScore: json["vas_score"],
      doctorNote: json["doctor_notes"]
    );
  }
}