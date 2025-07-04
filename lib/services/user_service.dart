import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_app/models/user_model.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveNewUser({
    required id,
    required String name,
    required String email,
  }) async {
    await _firestore.collection('users').add(
          UserModel(
            id: id,
            name: name,
            email: email,
          ).toMap(),
        );
  }
}
