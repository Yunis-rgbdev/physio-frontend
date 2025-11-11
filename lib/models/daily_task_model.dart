class DailyTask {
  final int? id;
  final String patientNationalCode;
  final String operatorNationalCode;
  final String date;
  final String title;
  final String description;
  final int repetitions;
  final int sets;
  final bool completed;

  DailyTask({
    this.id,
    required this.patientNationalCode,
    required this.operatorNationalCode,
    required this.date,
    required this.title,
    required this.description,
    required this.repetitions,
    required this.sets,
    this.completed = false,
  });

  factory DailyTask.fromJson(Map<String, dynamic> json) {
    return DailyTask(
      id: json['id'],
      patientNationalCode: json['patient_national_code'],
      operatorNationalCode: json['operator_national_code'],
      date: json['date'],
      title: json['title'],
      description: json['description'],
      repetitions: json['repetitions'] ?? 0,
      sets: json['sets'] ?? 0,
      completed: json['completed'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'patient_national_code': patientNationalCode,
      'operator_national_code': operatorNationalCode,
      'date': date,
      'title': title,
      'description': description,
      'repetitions': repetitions,
      'sets': sets,
      'completed': completed,
    };
  }
}