import 'package:flutter/material.dart';
import 'package:telewehab/utils/user_session.dart';
// import 'package:telewehab/models/user_model.dart';
import 'package:telewehab/models/operator_models.dart';
import 'package:telewehab/models/patient_models.dart';

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = UserSession.user;

    if (user == null) {
      return const Scaffold(
        body: Center(
          child: Text("User not logged in"),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text("Welcome ${user.fullName}")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("National Code: ${user.nationalCode}"),
            Text("Role: ${_getRoleName(user.role)}"),

            const SizedBox(height: 16),

            if (user.profile is Operator)
              _buildOperatorProfile(user.profile as Operator)
            else if (user.profile is Patient)
              _buildPatientProfile(user.profile as Patient),
          ],
        ),
      ),
    );
  }

  String _getRoleName(int role) {
    switch (role) {
      case 1:
        return "Operator";
      case 2:
        return "Patient";
      case 3:
        return "Admin";
      default:
        return "Unknown";
    }
  }

  Widget _buildOperatorProfile(Operator operator) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Specialty: ${operator.specialty ?? '-'}"),
        Text("Clinic: ${operator.clinicAddress ?? '-'}"),
        Text("Phone: ${operator.phoneNumber ?? '-'}"),
      ],
    );
  }

  Widget _buildPatientProfile(Patient patient) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Phone: ${patient.phoneNumber ?? '-'}"),
        Text("National Code: ${patient.nationalCode ?? '-'}"),
      ],
    );
  }
}
