import 'dart:convert';
// import 'package:flutter/material.dart';
import 'package:telewehab/models/patient_models.dart';
import 'package:http/http.dart' as http;
import 'package:telewehab/models/daily_task_model.dart';
import 'package:telewehab/models/active_session_model.dart';
import 'package:telewehab/models/medical_file_model.dart';
import 'package:dio/dio.dart';

class ApiService {
  static const String baseUrl = "http://127.0.0.1:8000";
  final Dio _dio = Dio();

  // ]-------------------[ AUTHENTICATION API SERVICES ]-------------------[
  static Future<Map<String, dynamic>> login(String nationalCode, String password) async {
    final url = Uri.parse('$baseUrl/api/auth/login/');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'national_code': nationalCode,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Login failed: ${response.body}');
    }
  }

  // ]-------------------[ MEDICAL FILES API SERVICES ]-------------------[
  
  /// Fetches all active medical files for a specific operator
  Future<List<MedicalFile>> getActiveMedicalFilesByOperator(String operatorNationalCode) async {
    final url = Uri.parse('$baseUrl/medfile/medical-files/operator/$operatorNationalCode/');
    
    try {
      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        // Filter only active medical files
        return data
            .map((json) => MedicalFile.fromJson(json))
            .where((file) => file.isActive)
            .toList();
      } else {
        throw Exception('Failed to load medical files: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching medical files: $e');
    }
  }

  /// Fetches patient details by national code
  Future<Patient> getPatientByNationalCode(String nationalCode) async {
    final url = Uri.parse('$baseUrl/patients/search/?national_code=$nationalCode');
    
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        return Patient.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 404) {
        throw Exception('Patient not found');
      } else {
        throw Exception('Failed to load patient');
      }
    } catch (e) {
      throw Exception('Error fetching patient: $e');
    }
  }

  /// Combines medical files with patient details for dashboard display
  Future<List<PatientWithVAS>> getPatientsWithVASScores(String operatorNationalCode) async {
    try {
      print('Fetching medical files for operator: $operatorNationalCode');
      
      // Get all active medical files for this operator
      final medicalFiles = await getActiveMedicalFilesByOperator(operatorNationalCode);
      
      print('Found ${medicalFiles.length} active medical files');
      
      // Create list to hold combined data
      List<PatientWithVAS> patientsWithVAS = [];

      // For each medical file, fetch patient details
      for (var file in medicalFiles) {
        try {
          final patient = await getPatientByNationalCode(file.patientNationalCode);
          
          final patientWithVAS = PatientWithVAS.fromMedicalFile(file);
          patientWithVAS.patientName = patient.fullName;
          patientWithVAS.birthDate = patient.birthDate;
          
          patientsWithVAS.add(patientWithVAS);
          print('Added patient: ${patient.fullName} with VAS: ${file.vasScore}');
        } catch (e) {
          // If patient details fail, still add the VAS data
          print('Failed to fetch patient ${file.patientNationalCode}: $e');
          patientsWithVAS.add(PatientWithVAS.fromMedicalFile(file));
        }
      }

      return patientsWithVAS;
    } catch (e) {
      print('Error in getPatientsWithVASScores: $e');
      throw Exception('Error getting patients with VAS scores: $e');
    }
  }

  // ]-------------------[ DASHBOARD API SERVICES ]-------------------[

  Future<ActiveSession> getAllActiveSessionsAndVasScore(String nationalCode) async {
    final url = Uri.parse('$baseUrl/operators/$nationalCode/active-sessions/');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return ActiveSession.fromJson(data);
    } else {
      throw Exception('Failed to get active sessions for user $nationalCode');
    }
  }

  static Future<Map<String, dynamic>> getProfile(String token) async {
    final url = Uri.parse('$baseUrl/profile/');
    final response = await http.get(url, headers: {'Authorization': 'Bearer $token'});
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load profile');
    }
  }

  Future<List> getPatientsByOperator(String operatorNationalCode) async {
    final url = Uri.parse('$baseUrl/odpatients/?national_code=$operatorNationalCode');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load profile');
    }
  }

  static Future<List> getPatients() async {
    final url = Uri.parse('$baseUrl/patietns/');
    final response = await http.get(url, headers: {});
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load profile');
    }
  }

  Future<Patient> searchPatient(String nationalCode) async {
    final url = Uri.parse('$baseUrl/patients/search/?national_code=$nationalCode');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return Patient.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 404) {
      throw Exception('Patient not found');
    } else {
      throw Exception('Failed to load patient');
    }
  }

  Future<List<Patient>> getAllPatients(String operatorNationalCode) async {
    try {
      final response = await _dio.get(
        '/patients/',
        queryParameters: {'operator': operatorNationalCode},
      );
      return (response.data as List).map((p) => Patient.fromJson(p)).toList();
    } catch (e) {
      throw Exception('Failed to load patients: $e');
    }
  }

  Future<List<DailyTask>> getDailyTasks(String patientNationalCode, String date) async {
    try {
      final response = await _dio.get(
        '/daily-tasks/',
        queryParameters: {
          'patient': patientNationalCode,
          'date': date,
        },
      );
      return (response.data as List).map((t) => DailyTask.fromJson(t)).toList();
    } catch (e) {
      throw Exception('Failed to load tasks: $e');
    }
  }

  Future<DailyTask> createTask(DailyTask task) async {
    try {
      final response = await _dio.post('/daily-tasks/', data: task.toJson());
      return DailyTask.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to create task: $e');
    }
  }

  Future<DailyTask> updateTask(DailyTask task) async {
    try {
      final response = await _dio.put(
        '/daily-tasks/${task.id}/',
        data: task.toJson(),
      );
      return DailyTask.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to update task: $e');
    }
  }

  Future<void> deleteTask(int taskId) async {
    try {
      await _dio.delete('/daily-tasks/$taskId/');
    } catch (e) {
      throw Exception('Failed to delete task: $e');
    }
  }
}