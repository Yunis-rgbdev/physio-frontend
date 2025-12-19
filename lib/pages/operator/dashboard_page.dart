// dashboard_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:persian_fonts/persian_fonts.dart';
import 'package:telewehab/models/medical_file_model.dart';
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'نظارت بر بیماران',
                    style: PersianFonts.Shabnam.copyWith(
                      color: Colors.black87,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.refresh, color: Colors.black87),
                        onPressed: () => controller.refreshData(),
                      ),
                      IconButton(
                        icon: const Icon(Icons.filter_list, color: Colors.black87),
                        onPressed: () => _showFilterDialog(context),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Statistics Summary
            Obx(() => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  _buildStatCard(
                    'مجموع بیماران',
                    controller.patientsWithVAS.length.toString(),
                    Colors.blue,
                  ),
                  const SizedBox(width: 12),
                  _buildStatCard(
                    'بحرانی',
                    controller.getCriticalPatients().length.toString(),
                    Colors.red,
                  ),
                  const SizedBox(width: 12),
                  _buildStatCard(
                    'اولویت بالا',
                    controller.getHighPriorityPatients().length.toString(),
                    Colors.orange,
                  ),
                ],
              ),
            )),
            
            const SizedBox(height: 16),
            
            // Patient List
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFF64B5F6),
                    ),
                  );
                }
                
                if (controller.errorMessage.value.isNotEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error_outline, size: 48, color: Colors.red[300]),
                        const SizedBox(height: 16),
                        Text(
                          controller.errorMessage.value,
                          style: PersianFonts.Shabnam.copyWith(color: Colors.red),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => controller.refreshData(),
                          child: const Text('تلاش مجدد', style: PersianFonts.Shabnam,),
                        ),
                      ],
                    ),
                  );
                }
                
                if (controller.patientsWithVAS.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.inbox_outlined, size: 64, color: Colors.grey[400]),
                        const SizedBox(height: 16),
                        Text(
                          'هیچ بیمار فعالی یافت نشد',
                          style: PersianFonts.Shabnam.copyWith(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  );
                }
                
                return RefreshIndicator(
                  onRefresh: controller.refreshData,
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                    itemCount: controller.patientsWithVAS.length,
                    itemBuilder: (context, index) {
                      return PatientVASCard(
                        patientWithVAS: controller.patientsWithVAS[index],
                      );
                    },
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: PersianFonts.Shabnam.copyWith(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: PersianFonts.Shabnam.copyWith(
                fontSize: 12,
                color: color.withOpacity(0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('فیلتر بیماران', style: PersianFonts.Shabnam.copyWith(fontSize: 16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text('همه بیماران', style: PersianFonts.Shabnam.copyWith(fontSize: 16)),
              onTap: () {
                Navigator.pop(context);
                controller.refreshData();
              },
            ),
            ListTile(
              title: Text('بحرانی (VAS ≥ 7)', style: PersianFonts.Shabnam.copyWith(fontSize: 16),),
              onTap: () {
                Navigator.pop(context);
                controller.patientsWithVAS.value = controller.getCriticalPatients();
              },
            ),
            ListTile(
              title: Text('اولویت بالا (VAS ≥ 5)', style: PersianFonts.Shabnam.copyWith(fontSize: 16)),
              onTap: () {
                Navigator.pop(context);
                controller.patientsWithVAS.value = controller.getHighPriorityPatients();
              },
            ),
          ],
        ),
      ),
    );
  }
}

// Patient VAS Card Widget
class PatientVASCard extends StatelessWidget {
  final PatientWithVAS patientWithVAS;

  const PatientVASCard({Key? key, required this.patientWithVAS}) : super(key: key);

  Color _getVASColor(int score) {
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

  String _getVASLevel(int score) {
    if (score >= 0 && score < 3) return 'کم';
    if (score >= 3 && score < 5) return 'متوسط';
    if (score >= 5 && score < 7) return 'زیاد';
    return 'بحرانی';
  }

  @override
  Widget build(BuildContext context) {
    final vasColor = _getVASColor(patientWithVAS.vasScore);
    final vasLevel = _getVASLevel(patientWithVAS.vasScore);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
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
                    value: patientWithVAS.vasScore / 10,
                    strokeWidth: 6,
                    backgroundColor: const Color.fromARGB(255, 170, 170, 170),
                    valueColor: AlwaysStoppedAnimation<Color>(vasColor),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      patientWithVAS.vasScore.toString(),
                      style: PersianFonts.Shabnam.copyWith(
                        color: vasColor,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      vasLevel,
                      style: PersianFonts.Shabnam.copyWith(
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
                  Text(
                    patientWithVAS.patientName ?? 'بیمار ${patientWithVAS.patientName}',
                    style: PersianFonts.Shabnam.copyWith(
                      color: Colors.black87,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      if (patientWithVAS.birthDate != null)
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
                            'تاریخ تولد: ${patientWithVAS.birthDate}',
                            style: PersianFonts.Shabnam.copyWith(
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
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'کد ملی: ${patientWithVAS.patientNationalCode}',
                          style: PersianFonts.Shabnam.copyWith(
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
                        color: Colors.black54,
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'شروع: ${patientWithVAS.startDate}',
                        style: PersianFonts.Shabnam.copyWith(
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
                // You can pass patientWithVAS.patientNationalCode
              },
            ),
          ],
        ),
      ),
    );
  }
}