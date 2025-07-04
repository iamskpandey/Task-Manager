import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:todo_app/services/firebase_storage_service.dart';

class ImagePickerService {
  Future<String> selectOrCaputeImage(source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      final file = File(pickedFile.path);

      return await FirebaseStorageService()
          .uploadProfileImage(file);
    }
    return '';
  }
}
