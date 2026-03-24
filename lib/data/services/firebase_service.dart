import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseStorage _storage = FirebaseStorage.instance;

  // Collections
  static CollectionReference<Map<String, dynamic>> get users => 
      _firestore.collection('users');
  
  static CollectionReference<Map<String, dynamic>> get reports => 
      _firestore.collection('reports');
  
  static CollectionReference<Map<String, dynamic>> get notifications => 
      _firestore.collection('notifications');

  // Auth
  static User? get currentUser => _auth.currentUser;
  static Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Firestore
  static FirebaseFirestore get firestore => _firestore;
  
  // Storage
  static Reference get storageRef => _storage.ref();
  
  // ✅ أضف هذه الـ getters
  static Reference get reportsStorageRef => 
      _storage.ref().child('reports');
  
  static Reference get userStorageRef => 
      _storage.ref().child('users');
  
  static Reference get profileImagesRef => 
      _storage.ref().child('profile_images');
  
  static Reference get reportImagesRef => 
      _storage.ref().child('report_images');
}