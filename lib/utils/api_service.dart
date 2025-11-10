import 'dart:convert';
// import 'package:flutter/material.dart';
import 'package:telewehab/models/patient_models.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "http://127.0.0.1:8000/api";

  static Future<Map<String, dynamic>> login(String nationalCode, String password) async {
    final url = Uri.parse('$baseUrl/login/');
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
}
