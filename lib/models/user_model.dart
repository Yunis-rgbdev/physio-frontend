// user_model.dart

import 'package:telewehab/models/patient_models.dart';
import 'package:telewehab/models/operator_models.dart';

class User {
  final String id;
  final String nationalCode;
  final String fullName;
  final dynamic email;
  final int role;
  final dynamic profile; // Can hold either Patient or Operator

  User({
    required this.id,
    required this.nationalCode,
    required this.fullName,
    required this.role,
    this.email,
    this.profile,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    final role = json["role"];

    dynamic profile;
    if (json["profile"] != null) {
      if (role == 2) {
        profile = Patient.fromJson(json["profile"]);
      } else if (role == 1 || role == 3) {
        profile = Operator.fromJson(json["profile"]);
      }
    }

    return User(
      id: json["id"] ?? "",
      nationalCode: json["national_code"].toString(),
      fullName: json["full_name"] ?? "",
      role: role ?? 0,
      profile: profile,
    );
  }
}
