import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:todo_app/services/auth_service.dart';

class FirebaseStorageService {
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  Future<String> uploadProfileImage(File image) async {
    try {
      Reference ref = _firebaseStorage
          .ref()
          .child('profile_images/${DateTime.now().toString()}');

      await ref.putFile(image);

      String downloadURL = await ref.getDownloadURL();

      await AuthService().currentUser!.updateProfile(photoURL: downloadURL);

      return downloadURL;
    } catch (e) {
      print('$e from uploadProfileImage');
      return '';
    }
  }
}
