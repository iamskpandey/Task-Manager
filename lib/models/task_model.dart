class TaskModel {
  final int id;
  final String taskName;
  bool isCompleted;

  TaskModel(
      {required this.id, required this.taskName, required this.isCompleted});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'taskName': taskName,
      'isCompleted': isCompleted,
    };
  }
}
