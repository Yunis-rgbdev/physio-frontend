import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shamsi_date/shamsi_date.dart' as shamsi;
import 'package:persian_datetime_picker/persian_datetime_picker.dart' as picker;
import 'task_controller.dart';
import 'package:telewehab/models/daily_task_model.dart';
import 'package:telewehab/models/patient_models.dart';
import 'package:telewehab/utils/api_service.dart';


class PhysioTasksPage extends StatelessWidget {
  // final String operatorNationalCode;

  // const PhysioTasksPage({
  //   Key? key,
  //   required this.operatorNationalCode,
  // }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Initialize controller
    final controller = Get.put(
  PhysioTasksController(
    operatorNationalCode: '1234567890', // 👈 replace with real operator code
    apiService: ApiService(),
  ),

    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('مدیریت تمرینات بیماران'),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.patients.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        return Column(
          children: [
            _DateSelector(controller: controller),
            _PatientSelector(controller: controller),
            Expanded(child: _TasksList(controller: controller)),
          ],
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTaskDialog(context, controller),
        backgroundColor: Colors.teal,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddTaskDialog(BuildContext context, PhysioTasksController controller) {
    if (controller.selectedPatient.value == null) {
      Get.snackbar('خطا', 'ابتدا یک بیمار انتخاب کنید');
      return;
    }

    Get.dialog(
      _TaskDialog(
        controller: controller,
        // patientNationalCode: controller.selectedPatient.value!.nationalCode,
        // operatorNationalCode: operatorNationalCode,
        date: controller.dateForApi,
      ),
    );
  }
}

// ==================== DATE SELECTOR ====================

class _DateSelector extends StatelessWidget {
  final PhysioTasksController controller;

  const _DateSelector({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.teal.shade50,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: controller.previousDay,
          ),
          InkWell(
            onTap: () {},
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.teal),
              ),
              child: Row(
                children: [
                  const Icon(Icons.calendar_today, color: Colors.teal, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    controller.persianDate,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: controller.nextDay,
          ),
        ],
      ),
    ));
  }

  Future<void> _showDatePicker(BuildContext context) async {
final selectedDate = shamsi.Jalali.now().obs;

    final picked = await picker.showPersianDatePicker(
  context: context,
  initialDate: picker.Jalali.fromDateTime(selectedDate.value.toDateTime()),
  firstDate: picker.Jalali(1400, 1),
  lastDate: picker.Jalali(1410, 12),
);

    if (picked != null) controller.changeDate(picked);
  }
}

// ==================== PATIENT SELECTOR ====================

class _PatientSelector extends StatelessWidget {
  final PhysioTasksController controller;

  const _PatientSelector({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.patients.isEmpty) {
        return const Padding(
          padding: EdgeInsets.all(16),
          child: Text('هیچ بیماری یافت نشد'),
        );
      }

      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: DropdownButtonFormField<Patient>(
          value: controller.selectedPatient.value,
          decoration: InputDecoration(
            labelText: 'انتخاب بیمار',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            prefixIcon: const Icon(Icons.person),
          ),
          items: controller.patients.map((patient) {
            return DropdownMenuItem(
              value: patient,
              child: Text('${patient.fullName ?? "نام نامشخص"} - ${patient.nationalCode}'),
            );
          }).toList(),
          onChanged: (patient) {
            if (patient != null) {
              controller.selectPatient(patient);
            }
          },
        ),
      );
    });
  }
}

// ==================== TASKS LIST ====================

class _TasksList extends StatelessWidget {
  final PhysioTasksController controller;

  const _TasksList({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.tasks.isEmpty) {
        return const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.fitness_center, size: 64, color: Colors.grey),
              SizedBox(height: 16),
              Text('هیچ تمرینی برای این روز ثبت نشده است'),
            ],
          ),
        );
      }

      return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: controller.tasks.length,
        itemBuilder: (context, index) {
          final task = controller.tasks[index];
          return _TaskCard(task: task, controller: controller);
        },
      );
    });
  }
}

// ==================== TASK CARD ====================

class _TaskCard extends StatelessWidget {
  final DailyTask task;
  final PhysioTasksController controller;

  const _TaskCard({required this.task, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    task.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                PopupMenuButton(
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit, size: 20),
                          SizedBox(width: 8),
                          Text('ویرایش'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete, color: Colors.red, size: 20),
                          SizedBox(width: 8),
                          Text('حذف', style: TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                  ],
                  onSelected: (value) {
                    if (value == 'edit') {
                      Get.dialog(_TaskDialog(
                        controller: controller,
                        patientNationalCode: task.patientNationalCode,
                        operatorNationalCode: task.operatorNationalCode,
                        date: task.date,
                        existingTask: task,
                      ));
                    } else if (value == 'delete') {
                      _confirmDelete(context, task);
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              task.description,
              style: TextStyle(color: Colors.grey.shade700),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _InfoChip(
                  icon: Icons.repeat,
                  label: '${task.repetitions} تکرار',
                ),
                const SizedBox(width: 8),
                _InfoChip(
                  icon: Icons.fitness_center,
                  label: '${task.sets} ست',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, DailyTask task) {
    Get.dialog(
      AlertDialog(
        title: const Text('تایید حذف'),
        content: const Text('آیا از حذف این تمرین اطمینان دارید؟'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('انصراف'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              if (task.id != null) {
                controller.deleteTask(task.id!);
              }
            },
            child: const Text('حذف', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

// ==================== INFO CHIP ====================

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.teal.shade50,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.teal),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}

// ==================== TASK DIALOG ====================

class _TaskDialog extends StatelessWidget {
  final PhysioTasksController controller;
  final String? patientNationalCode;
  final String? operatorNationalCode;
  final String date;
  final DailyTask? existingTask;

  _TaskDialog({
    required this.controller,
     this.patientNationalCode,
    this.operatorNationalCode,
    required this.date,
    this.existingTask,
  });

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final repetitionsController = TextEditingController();
  final setsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (existingTask != null) {
      titleController.text = existingTask!.title;
      descriptionController.text = existingTask!.description;
      repetitionsController.text = existingTask!.repetitions.toString();
      setsController.text = existingTask!.sets.toString();
    }

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(24),
        constraints: const BoxConstraints(maxWidth: 500),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                existingTask == null ? 'افزودن تمرین جدید' : 'ویرایش تمرین',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: 'عنوان تمرین',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: descriptionController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'توضیحات',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: repetitionsController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'تعداد تکرار',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      controller: setsController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'تعداد ست',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Get.back(),
                    child: const Text('انصراف'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () => _saveTask(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                    child: const Text('ذخیره'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveTask() {
    if (titleController.text.isEmpty) {
      Get.snackbar('خطا', 'عنوان تمرین را وارد کنید');
      return;
    }

    final task = DailyTask(
      id: existingTask?.id,
      patientNationalCode: patientNationalCode,
      operatorNationalCode: operatorNationalCode,
      date: date,
      title: titleController.text,
      description: descriptionController.text,
      repetitions: int.tryParse(repetitionsController.text) ?? 0,
      sets: int.tryParse(setsController.text) ?? 0,
    );

    if (existingTask == null) {
      controller.addTask(task);
    } else {
      controller.updateTask(task);
    }
  }
}