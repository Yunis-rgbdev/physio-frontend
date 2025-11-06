import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:persian_fonts/persian_fonts.dart';

class AppointmentsPage extends StatelessWidget {
  final RxString selectedTab = 'همه'.obs;
  final RxString dateRange = '۲۴.۰۱.۲۰۲۲ - ۲۶.۰۱.۲۰۲۲'.obs;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            SizedBox(height: 24),
            _buildAppointmentsList(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'نوبت‌ها',
            style: PersianFonts.Vazir.copyWith(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 20),
          Row(
            children: [
              _buildTabButton('همه'),
              SizedBox(width: 12),
              _buildTabButton('تایید شده'),
              SizedBox(width: 12),
              _buildTabButton('در انتظار تایید'),
              Spacer(),
              _buildDateRangeButton(),
              SizedBox(width: 12),
              _buildIconButton(Icons.edit_outlined, Color(0xFF3E68FF)),
              SizedBox(width: 12),
              _buildIconButton(Icons.filter_alt_outlined, Color(0xFF3E68FF)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(String label) {
    return Obx(() => InkWell(
          onTap: () => selectedTab.value = label,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: selectedTab.value == label
                  ? Colors.transparent
                  : Colors.transparent,
              border: Border(
                bottom: BorderSide(
                  color: selectedTab.value == label
                      ? Color(0xFF3E68FF)
                      : Colors.transparent,
                  width: 2,
                ),
              ),
            ),
            child: Text(
              label,
              style: PersianFonts.Vazir.copyWith(
                fontSize: 14,
                fontWeight: selectedTab.value == label
                    ? FontWeight.bold
                    : FontWeight.normal,
                color: selectedTab.value == label
                    ? Color(0xFF3E68FF)
                    : Colors.black54,
              ),
            ),
          ),
        ));
  }

  Widget _buildDateRangeButton() {
    return Obx(() => Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black12),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Text(
                dateRange.value,
                style: PersianFonts.Vazir.copyWith(
                  fontSize: 13,
                  color: Colors.black87,
                ),
              ),
              SizedBox(width: 8),
              Icon(Icons.calendar_today, size: 16, color: Colors.black54),
            ],
          ),
        ));
  }

  Widget _buildIconButton(IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(icon, color: Colors.white, size: 20),
    );
  }

  Widget _buildAppointmentsList() {
    return Column(
      children: [
        _buildDoctorSection(
          name: 'جید برایان',
          specialty: 'روان‌درمانگر',
          appointmentCount: 3,
          appointments: [
            _AppointmentData(
              patient: 'برندان لستر',
              time: 'دوشنبه، ژانویه ۲۴ ۱۱:۰۰',
              paymentStatus: 'پرداخت شده',
              patientStatus: 'تایید شده',
              paymentColor: Colors.green,
              statusColor: Colors.green,
            ),
            _AppointmentData(
              patient: 'امبرلی گری',
              time: 'دوشنبه، ژانویه ۲۴ ۱۳:۳۰',
              paymentStatus: 'در انتظار پرداخت',
              patientStatus: 'تایید نشده',
              paymentColor: Colors.orange,
              statusColor: Colors.orange,
            ),
            _AppointmentData(
              patient: 'روزالین بوکر',
              time: 'دوشنبه، ژانویه ۲۴ ۱۷:۰۰',
              paymentStatus: 'پرداخت نشده',
              patientStatus: 'لغو شده',
              paymentColor: Colors.red,
              statusColor: Colors.red,
            ),
          ],
        ),
        SizedBox(height: 12),
        _buildDoctorSection(
          name: 'گری مورگان',
          specialty: 'ارتوپد',
          appointmentCount: 5,
          appointments: [],
          isExpanded: false,
        ),
        SizedBox(height: 12),
        _buildDoctorSection(
          name: 'مارگارت راجرز',
          specialty: 'جراح',
          appointmentCount: 2,
          appointments: [],
          isExpanded: false,
        ),
        SizedBox(height: 12),
        _buildDoctorSection(
          name: 'موریس برنز',
          specialty: 'دندانپزشک',
          appointmentCount: 8,
          appointments: [],
          isExpanded: false,
        ),
        SizedBox(height: 12),
        _buildDoctorSection(
          name: 'گابریل گرانت',
          specialty: 'انکولوژیست',
          appointmentCount: 1,
          appointments: [],
          isExpanded: false,
        ),
      ],
    );
  }

  Widget _buildDoctorSection({
    required String name,
    required String specialty,
    required int appointmentCount,
    required List<_AppointmentData> appointments,
    bool isExpanded = true,
  }) {
    final RxBool expanded = isExpanded.obs;

    return Obx(() => Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              InkWell(
                onTap: () => expanded.value = !expanded.value,
                child: Container(
                  padding: EdgeInsets.all(20),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: Color(0xFF3E68FF).withOpacity(0.1),
                        child: Icon(Icons.person, color: Color(0xFF3E68FF)),
                      ),
                      SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: PersianFonts.Vazir.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            specialty,
                            style: PersianFonts.Vazir.copyWith(
                              fontSize: 13,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: 16),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Color(0xFF3E68FF),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          appointmentCount.toString(),
                          style: PersianFonts.Vazir.copyWith(
                            fontSize: 13,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Spacer(),
                      Icon(
                        expanded.value
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        color: Colors.black54,
                      ),
                    ],
                  ),
                ),
              ),
              if (expanded.value && appointments.isNotEmpty) ...[
                Divider(height: 1),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      _buildAppointmentHeader(),
                      SizedBox(height: 12),
                      ...appointments
                          .map((apt) => _buildAppointmentRow(apt))
                          .toList(),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ));
  }

  Widget _buildAppointmentHeader() {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Text(
            'بیمار',
            style: PersianFonts.Vazir.copyWith(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Colors.black54,
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            'زمان پذیرش',
            style: PersianFonts.Vazir.copyWith(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Colors.black54,
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(
            'وضعیت پرداخت',
            style: PersianFonts.Vazir.copyWith(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Colors.black54,
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(
            'بیمار',
            style: PersianFonts.Vazir.copyWith(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Colors.black54,
            ),
          ),
        ),
        SizedBox(width: 40),
      ],
    );
  }

  Widget _buildAppointmentRow(_AppointmentData appointment) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.black.withOpacity(0.05)),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Row(
              children: [
                Icon(Icons.person_outline, size: 18, color: Colors.black54),
                SizedBox(width: 8),
                Text(
                  appointment.patient,
                  style: PersianFonts.Vazir.copyWith(
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: Row(
              children: [
                Icon(Icons.calendar_today_outlined,
                    size: 16, color: Colors.black54),
                SizedBox(width: 8),
                Text(
                  appointment.time,
                  style: PersianFonts.Vazir.copyWith(
                    fontSize: 13,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: appointment.paymentColor,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 8),
                Flexible(
                  child: Text(
                    appointment.paymentStatus,
                    style: PersianFonts.Vazir.copyWith(
                      fontSize: 13,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: appointment.statusColor,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 8),
                Flexible(
                  child: Text(
                    appointment.patientStatus,
                    style: PersianFonts.Vazir.copyWith(
                      fontSize: 13,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.more_vert, color: Colors.black54, size: 20),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}

class _AppointmentData {
  final String patient;
  final String time;
  final String paymentStatus;
  final String patientStatus;
  final Color paymentColor;
  final Color statusColor;

  _AppointmentData({
    required this.patient,
    required this.time,
    required this.paymentStatus,
    required this.patientStatus,
    required this.paymentColor,
    required this.statusColor,
  });
}