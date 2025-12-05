// models/medical_file_model.dart
class MedicalFile {
  final int id;
  final String startDate;
  final String? endDate;
  final String? doctorNotes;
  final int vasScore;
  final String patientNationalCode;
  final String operatorNationalCode;
  final bool isActive;

  MedicalFile({
    required this.id,
    required this.startDate,
    this.endDate,
    this.doctorNotes,
    required this.vasScore,
    required this.patientNationalCode,
    required this.operatorNationalCode,
    required this.isActive,
  });

  factory MedicalFile.fromJson(Map<String, dynamic> json) {
    return MedicalFile(
      id: json['id'],
      startDate: json['start_date'],
      endDate: json['end_date'],
      doctorNotes: json['doctor_notes'],
      vasScore: json['vas_score'],
      patientNationalCode: json['patient_national_code'],
      operatorNationalCode: json['operator_national_code'],
      isActive: json['is_active'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'start_date': startDate,
      'end_date': endDate,
      'doctor_notes': doctorNotes,
      'vas_score': vasScore,
      'patient_national_code': patientNationalCode,
      'operator_national_code': operatorNationalCode,
      'is_active': isActive,
    };
  }
}

// Combined model for patient with VAS score
class PatientWithVAS {
  final String patientNationalCode;
  final int vasScore;
  final String startDate;
  final int medicalFileId;
  String? patientName; // Will be populated after fetching patient details
  String? birthDate;

  PatientWithVAS({
    required this.patientNationalCode,
    required this.vasScore,
    required this.startDate,
    required this.medicalFileId,
    this.patientName,
    this.birthDate,
  });

  factory PatientWithVAS.fromMedicalFile(MedicalFile file) {
    return PatientWithVAS(
      patientNationalCode: file.patientNationalCode,
      vasScore: file.vasScore,
      startDate: file.startDate,
      medicalFileId: file.id,
    );
  }
}