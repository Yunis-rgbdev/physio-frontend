import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:telewehab/pages/operator/operator_controllers/dashboard_controller.dart';
import 'package:get/get.dart';

class PatientsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AppBarBlurController _appController = Get.put(AppBarBlurController());
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: NotificationListener<ScrollNotification>(
        onNotification: (scroll) {
          if (scroll.metrics.axis == Axis.vertical) {
            _appController.updateScroll(scroll.metrics.pixels);
          }
          return false; // allow other listeners to receive it
        },
        child: CustomScrollView(
          slivers: [
            // AppBar built reactively with Obx
            Obx(() {
              final blur = _appController.blurValue;
              final opacity = _appController.opacity;

              return SliverAppBar(
                pinned: true,
                stretch: false,
                elevation: 0,
                backgroundColor: Colors.white.withOpacity(opacity),
                // Use flexibleSpace to apply BackdropFilter blur and a vertical gradient overlay
                flexibleSpace: ClipRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
                    child: Container(
                      // vertical gradient from solid white at top to slightly less opaque white below
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.white.withOpacity(opacity),
                            Colors.white.withOpacity((opacity * 0.85).clamp(0.0, 1.0)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                title: Row(
                  children: const [
                    Text('Patient List', style: TextStyle(color: Color(0xFF4A90E2))),
                    SizedBox(width: 8),
                    Icon(Icons.chevron_right, color: Colors.grey),
                    SizedBox(width: 8),
                    Text('Diane Cooper', style: TextStyle(color: Colors.black87)),
                  ],
                ),
                actions: [
                  IconButton(icon: const Icon(Icons.print, color: Colors.grey), onPressed: () {}),
                  TextButton.icon(
                    icon: const Icon(Icons.edit),
                    label: const Text('Edit Patient'),
                    onPressed: () {},
                  ),
                ],
                // control AppBar height if you want
                expandedHeight: 0, // 0 makes it behave like a normal AppBar but pinned
              );
            }),

            // Page content inside a single SliverToBoxAdapter
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    if (constraints.maxWidth < 900) {
                      // Mobile layout
                      return SingleChildScrollView(
                        physics: const NeverScrollableScrollPhysics(), // outer CustomScrollView handles scroll
                        child: Wrap(
                          children: [
                            PatientHeaderCard(),
                            SizedBox(height: 16),
                            AppointmentTabsSection(),
                            SizedBox(height: 16),
                            
                            // NotesCard(),
                            SizedBox(height: 16),
                            FilesDocumentsCard(),
                          ],
                        ),
                      );
                    } else {
                      // Desktop layout
                      return Wrap(
                        children: [
                          // Use sized widgets inside wrap — keep structure similar to your original
                          Column(
                                children: [
                                  PatientHeaderCard(),
                                  SizedBox(height: 24),
                                  AppointmentTabsSection(),
                                ],
                              ),
                            
                          
                          Container(width: 1, color: const Color(0xFFE0E0E0)),
                          Column(
                                children: [
                                  SizedBox(height: 24),
                                  NotesCard(),
                                  SizedBox(height: 24),
                                  FilesDocumentsCard(),
                                ],
                              ),
                            
                        ],
                      );
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ========== PATIENT HEADER CARD ==========
class PatientHeaderCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final DashboardController _controller = Get.find<DashboardController>();
    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 40,
                backgroundImage: NetworkImage('https://'),
              ),
              SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(
                      () {
                        if (_controller.isLoading.value) {
                          return const CircularProgressIndicator();
                        } else if (_controller.error.isNotEmpty) {
                          return Text(
                            _controller.error.value,
                            style: const TextStyle(color: Colors.red),
                          );
                        } else if (_controller.patient.value != null) {
                          final p = _controller.patient.value!;
                          return Text(
                            p.fullName ?? 'No Name Availabale',
                          );
                        } else {
                          return const Text("No patient searched yet.");
                        }
                      } 
                    ),
                    // Text(
                    //   _controller. ?? 'no name found',
                    //   style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    // ),
                    Text(
                      'email placeholder',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 200,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildStatBox('-', 'Appointments'),
                    SizedBox(width: 7.5),
                    Container(height: 30, width: 1, color: Colors.grey,),
                    SizedBox(width: 7.5),
                    _buildStatBox('-', 'Upcoming'),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Align(
            alignment: Alignment.centerLeft,
            child: SizedBox(
              height: 40,
              width: 200,
              child: ElevatedButton.icon(
                icon: Icon(Icons.message, color: Colors.white,),
                label: Text('Send Message', style: TextStyle(color: Colors.white),),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 0, 0, 0),
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  
                ),
                onPressed: () {},
              ),
            ),
          ),
          SizedBox(height: 24),
          PatientInfoGrid(),
        ],
      ),
    );
  }

  Widget _buildStatBox(String value, String label) {
    return Column(
      children: [
        Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
      ],
    );
  }
}

// ========== PATIENT INFO GRID ==========
class PatientInfoGrid extends StatelessWidget {
  final DashboardController _dashboardController = Get.put(DashboardController());

  @override
  Widget build(BuildContext context) {
    return
        Obx(
                      () {
                        if (_dashboardController.isLoading.value) {
                          return const CircularProgressIndicator();
                        } else if (_dashboardController.error.isNotEmpty) {
                          return Text(
                            _dashboardController.error.value,
                            style: const TextStyle(color: Colors.red),
                          );
                        } else if (_dashboardController.patient.value != null) {
                          final p = _dashboardController.patient.value!;
                          
                          return Column(
                            children: [
                              _buildInfoRow('Gender', p.gender.toString(), 'Birthday', p.birthDate.toString()),
                              _buildInfoRow('Phone Number', p.phoneNumber.toString(), 'ZIP Code', '65649'),
                              _buildInfoRow('National Code', p.nationalCode.toString(), 'City', 'Cilocap'),
                              _buildInfoRow('Member Status', p.isActive.toString(), 'VAS Average', p.vasScore.toString())
                            ],
                          );
                        } else {
                          return const Text("No patient searched yet.");
                        }
                      } 
                    );
  }

  Widget _buildInfoRow(String label1, String value1, String label2, String value2) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Expanded(child: _buildInfoItem(label1, value1)),
          SizedBox(width: 24),
          Expanded(child: _buildInfoItem(label2, value2)),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
        SizedBox(height: 4),
        Text(value, style: TextStyle(fontWeight: FontWeight.w500)),
      ],
    );
  }
}

// ========== APPOINTMENT TABS SECTION ==========
class AppointmentTabsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _buildTab('Upcoming Appointments', true),
              SizedBox(width: 24),
              _buildTab('Past Appointments', false),
              SizedBox(width: 24),
              _buildTab('Medical Records', false),
            ],
          ),
          SizedBox(height: 24),
          Row(
            children: [
              Text(
                'Root Canal Treatment',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Spacer(),
              TextButton(
                child: Text('Show Previous Treatment'),
                onPressed: () {},
              ),
            ],
          ),
          SizedBox(height: 16),
          AppointmentTimelineItem(
            date: '26 Nov \'19',
            time: '08:00 - 10:00',
            treatment: 'Open Access',
            doctor: 'Drg. Adam H.',
            clinic: 'Jessismile',
          ),
          SizedBox(height: 16),
          AppointmentTimelineItem(
            date: '12 Dec \'19',
            time: '09:00 - 10:00',
            treatment: 'Root Canal prep',
            doctor: 'Drg. Adam H.',
            clinic: 'Jessismile',
          ),
        ],
      ),
    );
  }

  Widget _buildTab(String label, bool isActive) {
    return Text(
      label,
      style: TextStyle(
        color: isActive ? Color(0xFF4A90E2) : Colors.grey,
        fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
        decoration: isActive ? TextDecoration.underline : null,
        decorationColor: Color(0xFF4A90E2),
        decorationThickness: 2,
      ),
    );
  }
}

// ========== APPOINTMENT TIMELINE ITEM ==========
class AppointmentTimelineItem extends StatelessWidget {
  final String date;
  final String time;
  final String treatment;
  final String doctor;
  final String clinic;

  AppointmentTimelineItem({
    required this.date,
    required this.time,
    required this.treatment,
    required this.doctor,
    required this.clinic,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline
          Column(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: Color(0xFF4A90E2),
                  shape: BoxShape.circle,
                ),
              ),
              Expanded(
                child: Container(
                  width: 2,
                  color: Color(0xFF4A90E2),
                ),
              ),
            ],
          ),
          SizedBox(width: 16),
          // Content
          Expanded(
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Color(0xFFF8F9FB),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Color(0xFFE0E0E0)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(date, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          Text(time, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                        ],
                      ),
                      TextButton.icon(
                        icon: Icon(Icons.note, size: 16),
                        label: Text('Note'),
                        onPressed: () {},
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Treatment', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                            Text(treatment, style: TextStyle(fontWeight: FontWeight.w500)),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Doctor', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                            Text(doctor, style: TextStyle(fontWeight: FontWeight.w500)),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Clinic', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                            Text(clinic, style: TextStyle(fontWeight: FontWeight.w500)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ========== NOTES CARD ==========
class NotesCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Notes', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              TextButton(child: Text('See all'), onPressed: () {}),
            ],
          ),
          SizedBox(height: 16),
          _buildNoteItem('This patient is lorem ipsum dolor sit amet'),
          _buildNoteItem('Lorem ipsum dolor sit amet'),
          _buildNoteItem('has allergic history with Catafium'),
          SizedBox(height: 12),
          SizedBox(
            height: 40,
            
            child: ElevatedButton(
              
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 0, 0, 0),
                minimumSize: Size(double.infinity, 40),
              ),
              onPressed: () {},
              child: Text('Save note', style: TextStyle(color: Colors.white),),
            ),
          ),
          SizedBox(height: 16),
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Color(0xFFF8F9FB),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.person, size: 16, color: Colors.grey),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Lorem ipsum dolor sit amet',
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                ),
                Text('29 Nov 19', style: TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoteItem(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Text('• ', style: TextStyle(fontSize: 18)),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}

// ========== FILES DOCUMENTS CARD ==========
class FilesDocumentsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Files / Documents', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              TextButton.icon(
                icon: Icon(Icons.add),
                label: Text('Add Files'),
                onPressed: () {},
              ),
            ],
          ),
          SizedBox(height: 16),
          _buildFileItem('Check Up Result.pdf', '192kb'),
          _buildFileItem('Dental X-Ray Result 2.pdf', '120kb'),
          _buildFileItem('Medical Prescriptions.pdf', '85kb'),
          _buildFileItem('Dental X-Ray Result.pdf', '95kb'),
        ],
      ),
    );
  }

  Widget _buildFileItem(String name, String size) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Color(0xFFF8F9FB),
        borderRadius: BorderRadius.circular(8),
        
        border: Border.all(color: Color(0xFFE0E0E0)),
      ),
      child: Row(
        children: [
          Icon(Icons.description, color: Colors.grey),
          SizedBox(width: 12),
          Expanded(child: Text(name, style: TextStyle(fontWeight: FontWeight.w500))),
          Text(size, style: TextStyle(color: Colors.grey, fontSize: 12)),
          SizedBox(width: 8),
          Icon(Icons.download, size: 20, color: Colors.grey),
          SizedBox(width: 8),
          Icon(Icons.more_vert, size: 20, color: Colors.grey),
        ],
      ),
    );
  }
}