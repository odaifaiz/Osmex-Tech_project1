import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;
import 'firebase_service.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // رفع صورة بلاغ
  Future<String?> uploadReportImage(File image, String reportId) async {
    try {
      String fileName = '${DateTime.now().millisecondsSinceEpoch}_${path.basename(image.path)}';
      Reference ref = FirebaseService.reportsStorageRef
          .child(reportId)
          .child(fileName);
      
      UploadTask uploadTask = ref.putFile(image);
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  // رفع صورة بروفايل المستخدم
  Future<String?> uploadProfileImage(File image, String userId) async {
    try {
      String fileName = '${DateTime.now().millisecondsSinceEpoch}_${path.basename(image.path)}';
      Reference ref = FirebaseService.userStorageRef
          .child(userId)
          .child(fileName);
      
      UploadTask uploadTask = ref.putFile(image);
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Error uploading profile image: $e');
      return null;
    }
  }

  // حذف صورة
  Future<void> deleteImage(String imageUrl) async {
    try {
      if (imageUrl.isNotEmpty) {
        Reference ref = _storage.refFromURL(imageUrl);
        await ref.delete();
      }
    } catch (e) {
      print('Error deleting image: $e');
    }
  }
}