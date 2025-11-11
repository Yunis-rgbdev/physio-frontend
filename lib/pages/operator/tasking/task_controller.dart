import 'package:get/get.dart';
import 'package:shamsi_date/shamsi_date.dart';
import 'package:flutter/material.dart';
import 'package:telewehab/utils/api_service.dart';
import 'package:telewehab/models/patient_models.dart';
import 'package:telewehab/models/daily_task_model.dart';

class PhysioTasksController extends GetxController {
  final String operatorNationalCode;
  final ApiService apiService;

  PhysioTasksController({
    required this.operatorNationalCode,
    required this.apiService,
  });

  final selectedDate = Jalali.now().obs;
  final selectedPatient = Rxn<Patient>();
  final patients = <Patient>[].obs;
  final tasks = <DailyTask>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadPatients();
  }

  String get formattedDate {
    final f = selectedDate.value.formatter;
    return '${f.yyyy}/${f.mm}/${f.dd}';
  }

  String get persianDate {
    final f = selectedDate.value.formatter;
    return '${f.dd} ${f.mN} ${f.yyyy}';
  }

  String get dateForApi {
    return '${selectedDate.value.year}-${selectedDate.value.month.toString().padLeft(2, '0')}-${selectedDate.value.day.toString().padLeft(2, '0')}';
  }

  Future<void> loadPatients() async {
    try {
      isLoading.value = true;
      final result = await apiService.getPatients(operatorNationalCode);
      patients.value = result;
      if (result.isNotEmpty) {
        selectedPatient.value = result[0];
        await loadTasks();
      }
    } catch (e) {
      Get.snackbar(
        'خطا',
        'بارگذاری بیماران با خطا مواجه شد',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadTasks() async {
    if (selectedPatient.value == null) return;

    try {
      isLoading.value = true;
      final result = await apiService.getDailyTasks(
        selectedPatient.value!.nationalCode!,
        dateForApi,
      );
      tasks.value = result;
    } catch (e) {
      Get.snackbar(
        'خطا',
        'بارگذاری تکالیف با خطا مواجه شد',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void previousDay() {
    selectedDate.value = selectedDate.value.addDays(-1);
    loadTasks();
  }

  void nextDay() {
    selectedDate.value = selectedDate.value.addDays(1);
    loadTasks();
  }

  void selectPatient(Patient patient) {
    selectedPatient.value = patient;
    loadTasks();
  }

  Future<void> addTask(DailyTask task) async {
    try {
      isLoading.value = true;
      final newTask = await apiService.createTask(task);
      tasks.add(newTask);
      Get.back();
      Get.snackbar(
        'موفق',
        'تکلیف با موفقیت اضافه شد',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withOpacity(0.1),
      );
    } catch (e) {
      Get.snackbar(
        'خطا',
        'افزودن تکلیف با خطا مواجه شد',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateTask(DailyTask task) async {
    try {
      isLoading.value = true;
      final updatedTask = await apiService.updateTask(task);
      final index = tasks.indexWhere((t) => t.id == task.id);
      if (index != -1) {
        tasks[index] = updatedTask;
      }
      Get.back();
      Get.snackbar(
        'موفق',
        'تکلیف با موفقیت ویرایش شد',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withOpacity(0.1),
      );
    } catch (e) {
      Get.snackbar(
        'خطا',
        'ویرایش تکلیف با خطا مواجه شد',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteTask(int taskId) async {
    try {
      isLoading.value = true;
      await apiService.deleteTask(taskId);
      tasks.removeWhere((t) => t.id == taskId);
      Get.snackbar(
        'موفق',
        'تکلیف با موفقیت حذف شد',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withOpacity(0.1),
      );
    } catch (e) {
      Get.snackbar(
        'خطا',
        'حذف تکلیف با خطا مواجه شد',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }
  void changeDate(Jalali newDate) {
  selectedDate.value = newDate;
  loadTasks();
}
}
