import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

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

class SignupController extends GetxController with InputValidationMixin {
  final formKey = GlobalKey<FormState>();

  TextEditingController nationalCodeController = TextEditingController();
  TextEditingController fullNameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  RxString nationalCode = ''.obs;
  RxString fullName = ''.obs;
  RxString phoneNumber = ''.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    nationalCodeController.addListener(
      () {
        nationalCode.value = nationalCodeController.text;
      }
    );
    fullNameController.addListener(
      () {
        fullName.value = fullNameController.text;
      }
    );
    phoneNumberController.addListener(
      () {
        phoneNumber.value = phoneNumberController.text;
      }
    );
  }
}