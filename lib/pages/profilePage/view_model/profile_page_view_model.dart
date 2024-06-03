import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePageViewModel extends ChangeNotifier {
  File? imagePicker;

  //---- logic buisiness ---
  Future pickImage(ImageSource imageSource) async {
    try {
      final imageFilePick = await ImagePicker().pickImage(source: imageSource);
      if (imageFilePick == null) {
        imagePicker = null;
        notifyListeners();
        return;
      }
      final imageTemporary = File(imageFilePick.path);
      // final imagePermanent = await saveImagePermanently(image.path);

      imagePicker = imageTemporary;
      notifyListeners();
    } on PlatformException catch (e) {
      debugPrint('Failed to pick image: $e');
    }
    return null;
  }

  Future<void> pushUserImage() async {
    User? currentUser = FirebaseAuth.instance.currentUser;

    //--- create file name ---
    final imageName = '${currentUser!.uid}_image_user';
    // --- create StorageRef ---
    final firebaseStorageRef = FirebaseStorage.instance
        .ref()
        .child('image_users/$currentUser!.uid/$imageName');
    // --- upload image ---
    final metadata = SettableMetadata(
      contentType: 'image/jpeg',
    );

    final uploadTask = firebaseStorageRef.putFile(imagePicker!, metadata);
    await uploadTask.then((task) {
      task.ref.getDownloadURL().then((urlImage) async {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .update({'image': urlImage});
      });
    });
    // print(urlImage);
  }
}
