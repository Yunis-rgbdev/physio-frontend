import 'dart:async';

import 'package:flutter/material.dart';
import 'package:persian_fonts/persian_fonts.dart';
import 'package:get/get.dart';
import 'package:telewehab/pages/operator/operator_controllers/dashboard_controller.dart';


// management_page.dart
class MedicalFilePage extends StatelessWidget {
  
  MedicalFilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final DashboardController _controller = Get.find<DashboardController>();
    final width = MediaQuery.of(context).size.width;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: SingleChildScrollView(
        // padding: EdgeInsets.all(24),
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            color: Colors.white
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 12),
            child: Wrap(
              alignment: WrapAlignment.spaceEvenly,

              children: [
                // _buildAppbar(width),
                Row(

                  children: [
                    Flexible(flex: 7, child: _buildInputItem('Full Name', _controller.FullNameController)),
                    Flexible(flex: 3, child: _buildInputItem('Gender', _controller.GenderController)),
                    Flexible(flex: 2, child: _buildInputItem('Age', _controller.BirthDateController)),
                    Flexible(flex: 2, child: _buildInputItem('Weight', _controller.WeightController)),
                    Flexible(flex: 2, child: _buildInputItem('Height', _controller.HeightController)),
                  ],
                ),
                
                _buildInputItem('Reason', _controller.ReasonController),
                _buildInputItem('Education', _controller.EducationController),
                _buildInputItem('Relationship', _controller.RelationshipController),
                _buildInputItem('Children', _controller.ChildrenCountController),
                _buildInputItem('Doctor Name', _controller.DoctorNameController),
                _buildInputItem('Therapist Name', _controller.TherapistNameController),
                _buildInputItem('Appointment Date', _controller.AppointmentDateController),
                _buildInputItem('Helper Tool', _controller.HelperToolController),
                _buildInputItem('Address', _controller.AddressController),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputItem(String labelText,
  TextEditingController controller) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      child: Column(
        children: [
          // Align(
          //   alignment: Alignment.centerRight,
          //   child: Padding(
          //     padding: const EdgeInsets.symmetric(vertical: 4),
          //     child: Text(
          //       labelText,
          //       style: PersianFonts.Shabnam.copyWith(
          //         color: Colors.black54, 
          //         fontWeight: FontWeight.bold
          //       ),
          //     ),
          //   ),
          // ),
          SizedBox(
            height: 40,
            child: TextFormField(
              controller: controller,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                labelText: labelText,
                floatingLabelAlignment: FloatingLabelAlignment.start,
                floatingLabelBehavior: FloatingLabelBehavior.always,
                floatingLabelStyle: PersianFonts.Shabnam.copyWith(color: Colors.black54, fontWeight: FontWeight.bold),
                labelStyle: PersianFonts.Shabnam.copyWith(color: Colors.black54, fontWeight: FontWeight.bold),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(0.0),
                  borderSide: BorderSide(color: Colors.grey, width: 1)
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(0.0),
                  borderSide: BorderSide(color: Colors.grey, width: 1),
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(0.0),
                  borderSide: BorderSide(color: Colors.grey, width: 1),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(0.0),
                  borderSide: BorderSide(color: Colors.red, width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(0.0),
                  borderSide: BorderSide(color: Color.fromRGBO(62, 104, 255, 1), width: 1),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


