import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:persian_fonts/persian_fonts.dart';
import 'package:telewehab/models/patient_models.dart';
import 'package:telewehab/pages/operator/operator_controllers/dashboard_controller.dart';



class DashboardPage extends StatelessWidget {

  final DashboardController controller = Get.put(DashboardController());

  DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        color: Colors.white,
        // const Color(0xFF0A0E27),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'نظارت بر بیماران VAS',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.filter_list, color: Colors.white),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            // Patient List
            Expanded(
              child: Obx(() => controller.isLoading.value
                  ? Center(child: CircularProgressIndicator(color: Color(0xFF64B5F6)))
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                      itemCount: controller.patients.length,
                      itemBuilder: (context, index) {
                        return PatientCard(patient: controller.patients[index]);
                      },
                    )),
            ),
          ],
        ),
      ),
    );
  }
}



// Patient Card Widget
class PatientCard extends StatelessWidget {
  final Patient patient;

  const PatientCard({Key? key, required this.patient}) : super(key: key);

  Color _getVASColor(double score) {
    if (score >= 0 && score < 3) {
      return const Color(0xFF00E676); // Green
    } else if (score >= 3 && score < 5) {
      return const Color.fromARGB(255, 247, 224, 20); // Yellow
    } else if (score >= 5 && score < 7) {
      return const Color(0xFFFF9800); // Orange
    } else {
      return const Color(0xFFFF1744); // Red
    }
  }

  String _getVASLevel(double score) {
    if (score >= 0 && score < 3) return 'کم';
    if (score >= 3 && score < 5) return 'متوسط';
    if (score >= 5 && score < 7) return 'زیاد';
    return 'بحرانی';
  }

  IconData _getTrendIcon(String trend) {
    switch (trend) {
      case 'up':
        return Icons.trending_up;
      case 'down':
        return Icons.trending_down;
      default:
        return Icons.trending_flat;
    }
  }

  Color _getTrendColor(String trend) {
    switch (trend) {
      case 'up':
        return const Color(0xFFFF1744);
      case 'down':
        return const Color(0xFF00E676);
      default:
        return const Color(0xFF64B5F6);
    }
  }

  @override
  Widget build(BuildContext context) {
    final vasColor = _getVASColor(patient.vasScore);
    final vasLevel = _getVASLevel(patient.vasScore);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 255, 255, 255),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: vasColor.withOpacity(0.3),
            blurRadius: 20,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            // VAS Circle Indicator
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 80,
                  height: 80,
                  child: CircularProgressIndicator(
                    value: patient.vasScore / 10,
                    strokeWidth: 6,
                    backgroundColor: const Color.fromARGB(255, 170, 170, 170),
                    valueColor: AlwaysStoppedAnimation<Color>(vasColor),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      patient.vasScore.toStringAsFixed(1),
                      style: TextStyle(
                        color: vasColor,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      vasLevel,
                      style: TextStyle(
                        color: vasColor.withOpacity(0.8),
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(width: 20),
            // Patient Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          patient.fullName.toString(),
                          style: const TextStyle(
                            color: Colors.black87,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      // Container(
                      //   padding: const EdgeInsets.symmetric(
                      //     horizontal: 8,
                      //     vertical: 4,
                      //   ),
                      //   decoration: BoxDecoration(
                      //     color: _getTrendColor(patient.trend).withOpacity(0.2),
                      //     borderRadius: BorderRadius.circular(12),
                      //   ),
                      //   child: Row(
                      //     mainAxisSize: MainAxisSize.min,
                      //     children: [
                      //       Icon(
                      //         _getTrendIcon(patient.trend),
                      //         color: _getTrendColor(patient.trend),
                      //         size: 16,
                      //       ),
                      //     ],
                      //   ),
                      // ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF64B5F6).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'سن ${patient.birthDate}',
                          style: const TextStyle(
                            color: Color(0xFF64B5F6),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white12,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'شناسه: ${patient.id}',
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        color: Colors.white.withOpacity(0.4),
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'بروزرسانی ${patient.lastUpdate}',
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Action Button
            IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              color: const Color(0xFF64B5F6),
              iconSize: 20,
              onPressed: () {
                // Navigate to patient details
              },
            ),
          ],
        ),
      ),
    );
  }
}