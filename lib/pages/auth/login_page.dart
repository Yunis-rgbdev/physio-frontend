import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:persian_fonts/persian_fonts.dart';
import 'package:telewehab/pages/auth/password_page.dart';
import 'auth_controllers/login_controller.dart';

class LoginView extends StatelessWidget {
  final loginController = Get.put(LoginController());
  LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final responsive = ResponsiveHelper(screenWidth);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(children: [
          _InputSection(responsive: responsive),
        ]),
      ),
    );
  }
}

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

class _InputSection extends StatelessWidget {
  final ResponsiveHelper responsive;
  const _InputSection({required this.responsive});

  @override
  Widget build(BuildContext context) {
    final loginController = Get.find<LoginController>();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Form(
              key: loginController.formKey,
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
                  const SizedBox(height: 150),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 40, right: 80, left: 80, bottom: 20),
                    child: Text(
                      'ورود به حساب کاربری',
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
                        onChanged: (value) => loginController.nationalCode.value = value,
                        validator: loginController.validateNationalCode,
                        controller: loginController.nationalCodeController,
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

                  // 🔹 Continue button
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 50,
                    width: responsive.buttonSize,
                    child: ElevatedButton(
                      onPressed: () {
                        Get.to(PasswordView());
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromRGBO(100, 181, 246, 1),
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 24),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'ادامه',
                        style: PersianFonts.Vazir.copyWith(
                            fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),

                  // 🔹 Bottom text section
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('اکانت ندارید؟',
                            style: PersianFonts.Vazir.copyWith(
                                fontSize: 12, color: Colors.black)),
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            'کلیک کنید',
                            style: PersianFonts.Vazir.copyWith(
                                fontSize: 12,
                                color: Color.fromRGBO(100, 181, 246, 1)),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 24, horizontal: 12),
                    child: Container(
                      height: 1,
                      width: 400,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
