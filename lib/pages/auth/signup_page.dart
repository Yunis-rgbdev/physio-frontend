import 'package:persian_fonts/persian_fonts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:telewehab/pages/auth/auth_controllers/signup_controller.dart';


class ResponsiveHelper {
  final double screenWidth;
  ResponsiveHelper(this.screenWidth);

  bool get isDesktop => screenWidth > 800;
  double get headerSize => (screenWidth * 0.06).clamp(16.0, 48.0);
  double get header2Size => (screenWidth * 0.05).clamp(12.0, 32.0);
  double get commentSize => (screenWidth * 0.03).clamp(12.0, 24.0);
  double get paragraphSize => (screenWidth * 0.02).clamp(14.0, 18.0);
  double get inputSize => (screenWidth * 0.3).clamp(350.0, 400.0);
  double get buttonSize => (screenWidth * 0.3).clamp(350.0, 400.0);
}

class SignupView extends StatelessWidget {
  final loginController = Get.put(SignupController());
  SignupView({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final responsive = ResponsiveHelper(screenWidth);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(children: [
          _SignupSection(responsive: responsive),
        ]),
      ),
    );
  }
}

class _SignupSection extends StatelessWidget {
  final ResponsiveHelper responsive;
  const _SignupSection({required this.responsive});

  @override
  Widget build(BuildContext context) {
    final _signupController = Get.find<SignupController>();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Center(
          child: Container(
            child: Form(
              key: _signupController.formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 12, horizontal: 90),
                    child: Text(
                      'PhysioConnect',
                      style: TextStyle(
                        color: Colors.blue[300],
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 60,),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 40, right: 80, left: 80, bottom: 20),
                    child: Text(
                      'Sign Up',
                      style: PersianFonts.Vazir.copyWith(
                        fontSize: responsive.header2Size - 5,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  // 🔹 National Code input field
                  const SizedBox(height: 15),
                  SizedBox(
                    height: 80,
                    width: responsive.inputSize,
                        child: TextFormField(
                          onChanged: (value) => _signupController.nationalCode.value = value,
                          validator: SignupController().validateNationalCode,
                          controller: SignupController().nationalCodeController,
                          decoration: InputDecoration(
                          labelText: 'کدملی',
                          labelStyle: PersianFonts.Shabnam.copyWith(),
                          contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide(color: Colors.red, width: 1)
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide(
                            color: const Color.fromRGBO(100, 181, 246, 1),
                            width: 1.0,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide(color: Colors.red, width: 1)
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide(color: Color.fromRGBO(100, 181, 246, 1), width: 1)
                        ),
                      ),
                    ),
                  ),

                  // 🔹 full name input field
                  const SizedBox(height: 0),
                  SizedBox(
                    height: 80,
                    width: responsive.inputSize,
                        child: TextFormField(
                          onChanged: (value) => _signupController.fullName.value = value,
                          
                          controller: SignupController().fullNameController,
                          decoration: InputDecoration(
                          labelText: 'full name',
                          focusColor: Color.fromRGBO(100, 181, 246, 1),
                          floatingLabelStyle: PersianFonts.Shabnam.copyWith(color: Color.fromRGBO(100, 181, 246, 1)),
                          labelStyle: PersianFonts.Shabnam.copyWith(),
                          contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide(color: Colors.red, width: 1)
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide(
                            color: const Color.fromRGBO(100, 181, 246, 1),
                            width: 1.0,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide(color: Colors.red, width: 1)
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide(color: Color.fromRGBO(100, 181, 246, 1), width: 1)
                        ),
                      ),
                    ),
                  ),

                  // 🔹 phone number input field
                  const SizedBox(height: 0),
                  SizedBox(
                    height: 80,
                    width: responsive.inputSize,
                        child: TextFormField(
                          onChanged: (value) => _signupController.nationalCode.value = value,
                          validator: SignupController().validateNationalCode,
                          controller: SignupController().nationalCodeController,
                          decoration: InputDecoration(
                          labelText: 'phone number',
                          focusColor: Color.fromRGBO(100, 181, 246, 1),
                          labelStyle: PersianFonts.Shabnam.copyWith(),
                          floatingLabelStyle: PersianFonts.Shabnam.copyWith(color: Color.fromRGBO(100, 181, 246, 1)),
                          contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide(color: Colors.red, width: 1)
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide(
                            color: const Color.fromRGBO(100, 181, 246, 1),
                            width: 1.0,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide(color: Colors.red, width: 1)
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide(color: Color.fromRGBO(100, 181, 246, 1), width: 1)
                        ),
                      ),
                    ),
                  ),


                ],
              )
            ),
          ),
        ),
      ),
    );
  }
}