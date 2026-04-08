import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:google_sign_in/google_sign_in.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../models/user_model.dart';
import '../services/firebase_service.dart';

class AuthRepositoryImpl implements AuthRepository {
  final firebase_auth.FirebaseAuth _auth = firebase_auth.FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  Stream<User?> get user {
    return _auth.authStateChanges().map((firebase_auth.User? firebaseUser) {
      return _convertToUser(firebaseUser);
    });
  }

  @override
  User? get currentUser {
    return _convertToUser(_auth.currentUser);
  }

  @override
  Future<User?> login(String email, String password) async {
    try {
      final result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return _convertToUser(result.user);
    } on firebase_auth.FirebaseAuthException catch (e) {
      print('Login error: ${e.message}');
      throw _getErrorMessage(e);
    } catch (e) {
      print('Login error: $e');
      throw 'حدث خطأ غير متوقع';
    }
  }

  @override
  Future<User?> register(String email, String password, {
    String? displayName,
    String? phoneNumber,
  }) async {
    try {
      final result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // تحديث اسم المستخدم في Firebase Auth
      if (displayName != null && displayName.isNotEmpty) {
        await result.user?.updateDisplayName(displayName);
        await result.user?.reload();
      }
      
      final user = _convertToUser(_auth.currentUser);
      
      // حفظ المستخدم في Firestore مع جميع البيانات
      if (user != null) {
        final userModel = UserModel(
          id: user.id,
          email: user.email,
          displayName: displayName ?? user.displayName,
          phoneNumber: phoneNumber ?? user.phoneNumber,
          photoURL: user.photoURL,
          createdAt: DateTime.now(),
        );
        await FirebaseService.users.doc(user.id).set(userModel.toJson());
      }
      
      return user;
    } on firebase_auth.FirebaseAuthException catch (e) {
      print('Register error: ${e.message}');
      throw _getErrorMessage(e);
    } catch (e) {
      print('Register error: $e');
      throw 'حدث خطأ غير متوقع';
    }
  }

  @override
  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth = 
          await googleUser.authentication;

      final credential = firebase_auth.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final result = await _auth.signInWithCredential(credential);
      final user = _convertToUser(result.user);
      
      // حفظ المستخدم في Firestore إذا كان جديداً
      if (user != null) {
        final userDoc = await FirebaseService.users.doc(user.id).get();
        if (!userDoc.exists) {
          final userModel = UserModel(
            id: user.id,
            email: user.email,
            displayName: user.displayName,
            phoneNumber: user.phoneNumber,
            photoURL: user.photoURL,
            createdAt: DateTime.now(),
          );
          await FirebaseService.users.doc(user.id).set(userModel.toJson());
        }
      }
      
      return user;
    } catch (e) {
      print('Google sign in error: $e');
      throw 'حدث خطأ في تسجيل الدخول بجوجل';
    }
  }

  @override
  Future<void> logout() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
  }

  @override
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on firebase_auth.FirebaseAuthException catch (e) {
      print('Reset password error: ${e.message}');
      throw _getErrorMessage(e);
    } catch (e) {
      print('Reset password error: $e');
      throw 'حدث خطأ غير متوقع';
    }
  }

  @override
  Future<bool> isEmailVerified() async {
    final user = _auth.currentUser;
    return user?.emailVerified ?? false;
  }

  @override
  Future<void> sendEmailVerification() async {
    final user = _auth.currentUser;
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
    }
  }

  // دالة مساعدة لتحويل Firebase User إلى User
  User? _convertToUser(firebase_auth.User? firebaseUser) {
    if (firebaseUser == null) return null;
    return User(
      id: firebaseUser.uid,
      email: firebaseUser.email ?? '',
      displayName: firebaseUser.displayName,
      phoneNumber: firebaseUser.phoneNumber,
      photoURL: firebaseUser.photoURL,
      createdAt: DateTime.now(),
      isEmailVerified: firebaseUser.emailVerified,
    );
  }

  // دالة لترجمة أخطاء Firebase
  String _getErrorMessage(firebase_auth.FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'المستخدم غير موجود';
      case 'wrong-password':
        return 'كلمة المرور غير صحيحة';
      case 'email-already-in-use':
        return 'البريد الإلكتروني مستخدم بالفعل';
      case 'weak-password':
        return 'كلمة المرور ضعيفة (يجب أن تكون 6 أحرف على الأقل)';
      case 'invalid-email':
        return 'البريد الإلكتروني غير صالح';
      case 'user-disabled':
        return 'هذا المستخدم تم تعطيله';
      case 'too-many-requests':
        return 'تم إرسال العديد من الطلبات، حاول لاحقاً';
      case 'operation-not-allowed':
        return 'عملية تسجيل الدخول غير مفعلة';
      case 'network-request-failed':
        return 'فشل الاتصال بالشبكة، تأكد من اتصال الإنترنت';
      default:
        return 'حدث خطأ: ${e.message}';
    }
  }
}
