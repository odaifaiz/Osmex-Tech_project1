import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // إضافة تقرير جديد
  Future<void> addReport(Map<String, dynamic> reportData) async {
    try {
      await _firestore.collection('reports').add({
        ...reportData,
        'userId': _auth.currentUser?.uid,
        'createdAt': FieldValue.serverTimestamp(),
        'status': 'pending',
      });
    } catch (e) {
      print('Error adding report: $e');
      throw e;
    }
  }

  // جلب تقارير المستخدم
  Stream<QuerySnapshot> getUserReports() {
    return _firestore
        .collection('reports')
        .where('userId', isEqualTo: _auth.currentUser?.uid)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  // جلب جميع التقارير (للمسؤول)
  Stream<QuerySnapshot> getAllReports() {
    return _firestore
        .collection('reports')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  // تحديث حالة التقرير
  Future<void> updateReportStatus(String reportId, String status) async {
    await _firestore.collection('reports').doc(reportId).update({
      'status': status,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }
}