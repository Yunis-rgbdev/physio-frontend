import 'package:flutter/material.dart';
import 'package:get/get.dart';

// API SERVICES
import 'package:telewehab/api_service.dart';

// USER MODELS AND ACTIVE SESSION MODELS
import 'package:telewehab/models/user_model.dart';
import 'package:telewehab/utils/user_session.dart';

mixin InputValidationMixin {
  String? validateNationalCode(String? value) {
    if (value == null || value.isEmpty) {
      return 'کدملی الزامی است';
    }
    if (value.length != 10) {
      return 'کدملی باید ۱۰ رقم باشد';
    }
    if (!RegExp(r'^\d+$').hasMatch(value)) {
      return 'کدملی فقط باید شامل عدد باشد';
    }
    return null;
  }
}

class LoginController extends GetxController with InputValidationMixin {
  final formKey = GlobalKey<FormState>();

  RxString nationalCode = ''.obs;
  RxString password = ''.obs;
  TextEditingController nationalCodeController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  RxBool isLoading = false.obs;

   @override
  void onInit() {
    super.onInit();
    // Sync changes both ways:
    nationalCodeController.addListener(() {
      nationalCode.value = nationalCodeController.text;
    });
    passwordController.addListener(() {
      password.value = passwordController.text;
    });
  }

  bool validateForm() => formKey.currentState?.validate() ?? false;

  void submit() {
    if (validateForm()) {
      Get.snackbar('موفق', 'ورود موفقیت‌آمیز بود');
    } else {
      Get.snackbar('خطا', 'کدملی معتبر نیست',
          backgroundColor: Colors.red[100], colorText: Colors.black);
    }
  }

  @override
  void onClose() {
    nationalCodeController.dispose();
    super.onClose();
  }


  void sendLogin() async {
  try {
    isLoading.value = true;
    final responseData = await ApiService.login(
      nationalCode.value.trim(),
      password.value.trim(),
    );
    final user = User.fromJson(responseData["user"]);

    UserSession.saveSession(
      responseData["access"],
      responseData["refresh"],
      user,
  );
Get.offAllNamed('/home');
  } catch (e) {
    Get.snackbar('Login Failed', e.toString(),
        backgroundColor: Colors.redAccent, colorText: Colors.white);
  } finally {
    isLoading.value = false;
  }
}
}
