import 'dart:convert';
// import 'package:flutter/material.dart';
import 'package:telewehab/models/patient_models.dart';
import 'package:http/http.dart' as http;
import 'package:telewehab/models/daily_task_model.dart';
import 'package:dio/dio.dart';

class ApiService {
  static const String baseUrl = "http://127.0.0.1:8000/api";
  final Dio _dio = Dio(); // ✅ Initialized immediately

  static Future<Map<String, dynamic>> login(String nationalCode, String password) async {
    final url = Uri.parse('$baseUrl/auth/login/');
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

  static Future<Map<String, dynamic>> getProfile(String token) async {
    final url = Uri.parse('$baseUrl/profile/');
    final response = await http.get(url, headers: {'Authorization': 'Bearer $token'});
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load profile');
    }
  }

  static Future<List> getAllPatients() async {
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
  Future<List<Patient>> getPatients(String operatorNationalCode) async {
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
