import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class StorageService {

  final Reference _reference = FirebaseStorage.instance.ref().child('posts');
  UploadTask _uploadTask;
  
  Future<String> uploadImage(File imageFile) async {

    String fileName = '${DateTime.now()}.png';

    _uploadTask = _reference.child(fileName).putFile(imageFile);

    String imageUrl;

    await _uploadTask.whenComplete(() async => {
      await _reference.child(fileName)
        .getDownloadURL()
        .then((value) => imageUrl = value)
    });

    return imageUrl;
  }
}