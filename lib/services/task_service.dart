import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_app/models/task_model.dart';
import 'package:todo_app/services/auth_service.dart';

class TaskService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> addTask(String task) async {
    final String id = AuthService().currentUser!.uid;

    await _db.collection('tasks').doc(id).collection('userTasks').add(TaskModel(
            id: Timestamp.now().millisecondsSinceEpoch,
            taskName: task,
            isCompleted: false)
        .toMap());
  }

  Stream getTasks() {
    final String id = AuthService().currentUser!.uid;

    return _db
        .collection('tasks')
        .doc(id)
        .collection('userTasks')
        .orderBy('id', descending: true)
        .snapshots();
  }

  Future<void> deleteTask(String docId) async {
    final String id = AuthService().currentUser!.uid;

    await _db
        .collection('tasks')
        .doc(id)
        .collection('userTasks')
        .doc(docId)
        .delete();
  }

  Future<void> updateTaskStatus(String docId, bool isCompleted) async {
    final String id = AuthService().currentUser!.uid;

    await _db
        .collection('tasks')
        .doc(id)
        .collection('userTasks')
        .doc(docId)
        .update({'isCompleted': !isCompleted});
  }

  Future<void> editTask(String taskId, String taskName) async {
    final String id = AuthService().currentUser!.uid;

    await _db
        .collection('tasks')
        .doc(id)
        .collection('userTasks')
        .doc(taskId)
        .update({'taskName': taskName});
  }

  Stream searchTasks(String taskName) {
    final String id = AuthService().currentUser!.uid;

    return _db
        .collection('tasks')
        .doc(id)
        .collection('userTasks')
        .where('taskName', isGreaterThanOrEqualTo: taskName)
        .where('taskName', isLessThanOrEqualTo: '$taskName\uf8ff')
        .snapshots();
  }
}
