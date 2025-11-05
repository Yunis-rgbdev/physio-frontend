import 'package:persian_fonts/persian_fonts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:telewehab/pages/auth/auth_controllers/signup_controller.dart';


class ResponsiveHelper {
  final double screenWidth;
  ResponsiveHelper(this.screenWidth);

  bool get isDesktop => screenWidth > 800;
  double get headerSize => (screenWidth * 0.5).clamp(16.0, 26.0);
  double get header2Size => (screenWidth * 0.05).clamp(12.0, 32.0);
  double get commentSize => (screenWidth * 0.03).clamp(12.0, 24.0);
  double get paragraphSize => (screenWidth * 0.02).clamp(14.0, 18.0);
  double get inputSize => (screenWidth * 0.3).clamp(350.0, 400.0);
  double get buttonSize => (screenWidth * 0.3).clamp(350.0, 400.0);
}

class GenderController extends GetxController {
  var selectedGender = ''.obs;
  final List<String> genders = ['آقا', 'خانم',];
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
  _SignupSection({required this.responsive});
  final GenderController controller = Get.put(GenderController());

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
                  Stack(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding:
                            const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                          child: Text(
                            'PhysioConnect',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: responsive.isDesktop ? 26 : 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: IconButton(onPressed: Get.back, icon: Icon(Icons.arrow_back_rounded)),
                      )
                    ],
                  ),
                  const SizedBox(height: 60,),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 40, right: 80, left: 80, bottom: 20),
                    child: Text(
                      'ایجاد حساب کاربری',
                      style: PersianFonts.Vazir.copyWith(
                        fontSize: responsive.header2Size - 5,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  // 🔹 National Code input field
                  const SizedBox(height: 30),
                  
                  SizedBox(
                    
                    // width: responsive.inputSize,
                        child: TextFormField(
                          onChanged: (value) => _signupController.nationalCode.value = value,
                          validator: SignupController().validateNationalCode,
                          controller: SignupController().nationalCodeController,
                          decoration: InputDecoration(
                          labelText: 'کدملی',
                          constraints: BoxConstraints.expand(height: 70, width: responsive.inputSize),
                          floatingLabelBehavior: FloatingLabelBehavior.auto,
                          floatingLabelStyle: PersianFonts.Shabnam.copyWith(
                            color: Color.fromRGBO(62, 104, 255, 1), 
                            fontWeight: FontWeight.bold, 
                            fontSize: 18,
                          ),
                          labelStyle: PersianFonts.Shabnam.copyWith(color: Colors.black26),
                          contentPadding: EdgeInsets.symmetric(vertical: 18, horizontal: 18),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(50)),
                          focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                          borderSide: BorderSide(color: Colors.red, width: 1)
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(32),
                          borderSide: BorderSide(
                            color: Colors.black12,
                            width: 1.5,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                          borderSide: BorderSide(color: Colors.red, width: 1)
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                          borderSide: BorderSide(color: Color.fromRGBO(62, 104, 255, 1), width: 1)
                        ),
                      ),
                    ),
                  ),

                  // 🔹 full name input field
                  const SizedBox(height: 0),
                  SizedBox(
                    
                    // width: responsive.inputSize,
                        child: TextFormField(
                          onChanged: (value) => _signupController.fullName.value = value,
                          // validator: SignupController().validateNationalCode,
                          controller: SignupController().fullNameController,
                          decoration: InputDecoration(
                          labelText: 'نام و نام خانوادگی',
                          constraints: BoxConstraints.expand(height: 70, width: responsive.inputSize),
                          floatingLabelBehavior: FloatingLabelBehavior.auto,
                          floatingLabelStyle: PersianFonts.Shabnam.copyWith(
                            color: Color.fromRGBO(62, 104, 255, 1),
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                          labelStyle: PersianFonts.Shabnam.copyWith(color: Colors.black26),
                          contentPadding: EdgeInsets.symmetric(vertical: 18, horizontal: 18),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(50)),
                          focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                          borderSide: BorderSide(color: Colors.red, width: 1)
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(32),
                          borderSide: BorderSide(
                            color: Colors.black12,
                            width: 1.5,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                          borderSide: BorderSide(color: Colors.red, width: 1)
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                          borderSide: BorderSide(color: Color.fromRGBO(62, 104, 255, 1), width: 1)
                        ),
                      ),
                    ),
                  ),

                  // 🔹 phone number input field
                  const SizedBox(height: 0),
                  SizedBox(
                    
                    // width: responsive.inputSize,
                        child: TextFormField(
                          onChanged: (value) => _signupController.phoneNumber.value = value,
                          // validator: SignupController().validateNationalCode,
                          controller: SignupController().phoneNumberController,
                          decoration: InputDecoration(
                          labelText: 'شماره موبایل',
                          constraints: BoxConstraints.expand(height: 70, width: responsive.inputSize),
                          floatingLabelBehavior: FloatingLabelBehavior.auto,
                          floatingLabelStyle: PersianFonts.Shabnam.copyWith(color: Color.fromRGBO(62, 104, 255, 1), fontWeight: FontWeight.bold, fontSize: 18),
                          labelStyle: PersianFonts.Shabnam.copyWith(color: Colors.black26,),
                          contentPadding: EdgeInsets.symmetric(vertical: 18, horizontal: 18),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(50)),
                          focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                          borderSide: BorderSide(color: Colors.red, width: 1)
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(32),
                          borderSide: BorderSide(
                            color: Colors.black12,
                            width: 1.5,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                          borderSide: BorderSide(color: Colors.red, width: 1)
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                          borderSide: BorderSide(color: Color.fromRGBO(62, 104, 255, 1), width: 1)
                        ),
                      ),
                    ),
                  ),
                  
                  // GENDER DROP DOWN FIELD
                  const SizedBox(height: 0),
                  SizedBox(
                    height: 60,
                    width: responsive.inputSize,
                    child: Obx(() => Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(32),
                        border: Border.all(
                          color: Colors.black12,
                          width: 1
                        )
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: controller.selectedGender.value.isEmpty
                          ? null
                          : controller.selectedGender.value,
                            hint: Text(
                              'جنسیت',
                              style: PersianFonts.Shabnam.copyWith(
                                fontSize: 16,
                                color: Colors.black26,
                              ),
                            ),
                            isExpanded: false,
                                    
                                    
                                    style: PersianFonts.Shabnam.copyWith(),
                                    borderRadius: BorderRadius.circular(32),
                                    padding: EdgeInsets.symmetric(vertical: 18, horizontal: 18),
                                    focusColor: Colors.white,
                                    menuWidth: 100,

                                    icon: const Icon(Icons.arrow_drop_down_rounded),
                                    items: controller.genders.map((String gender) {
                                      return DropdownMenuItem<String>(
                      value: gender,
                      child: Row(
                        children: [
                          Text(
                            gender,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black26,
                            ),
                          ),
                        ],
                      ),
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      controller.selectedGender.value = value!;
                                    },
                                  ),
                                ),
                    ),
                            ),
                  ),
                  

                  // 🔹 Continue button
                  const SizedBox(height: 25),
                  SizedBox(
                    height: 50,
                    width: responsive.buttonSize,
                    child: ElevatedButton(
                      onPressed: () {
                        
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            // const Color.fromRGBO(62, 104, 255, 1),
                            Colors.black,
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 24),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32),
                        ),
                      ),
                      child: Text(
                        'ادامه',
                        style: PersianFonts.Vazir.copyWith(
                            fontSize: 18, color: Colors.white),
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