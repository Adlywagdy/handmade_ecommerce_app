import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:handmade_ecommerce_app/core/constants/seller_status.dart';
import 'package:handmade_ecommerce_app/core/constants/user_roles.dart';
import 'package:handmade_ecommerce_app/core/services/hivehelper_service.dart';
import 'package:handmade_ecommerce_app/features/auth/models/auth_session.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  bool _googleInitialized = false;

  Future<void> _initGoogleSignIn() async {
    if (_googleInitialized) return;

    await _googleSignIn.initialize(
      serverClientId:
          '825459601482-ge1oq3992bl6qmcln2q53bliab294esn.apps.googleusercontent.com',
    );

    _googleInitialized = true;
  }

  Future<AuthSession> login({
    required String email,
    required String password,
  }) async {
    final UserCredential credential = await _firebaseAuth
        .signInWithEmailAndPassword(email: email, password: password);

    final User user = credential.user!;

    final docSnapshot = await _firestore
        .collection('users')
        .doc(user.uid)
        .get();

    if (!docSnapshot.exists) {
      throw FirebaseAuthException(
        code: 'user-data-not-found',
        message: 'User data not found',
      );
    }

    final data = docSnapshot.data();
    final role = data?['role'];

    if (role is! String || role.isEmpty) {
      throw FirebaseAuthException(
        code: 'invalid-user-role',
        message: 'User role not found',
      );
    }

    return AuthSession(role: role, status: data?['status'] as String?);
  }

  Future<AuthSession> signInWithGoogle() async {
    await _initGoogleSignIn();

    try {
      final GoogleSignInAccount googleUser = await _googleSignIn.authenticate();

      final GoogleSignInAuthentication googleAuth = googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await _firebaseAuth
          .signInWithCredential(credential);

      final User user = userCredential.user!;

      final docSnapshot = await _firestore
          .collection('users')
          .doc(user.uid)
          .get();

      if (!docSnapshot.exists) {
        await signOut();
        throw FirebaseAuthException(
          code: 'user-data-not-found',
          message: 'You are not registered yet. Please sign up first.',
        );
      }

      final data = docSnapshot.data();
      final role = data?['role'];

      if (role is! String || role.isEmpty) {
        throw FirebaseAuthException(
          code: 'invalid-user-role',
          message: 'User role not found',
        );
      }

      return AuthSession(role: role, status: data?['status'] as String?);
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) {
        throw FirebaseAuthException(
          code: 'google-sign-in-cancelled',
          message: 'Google sign-in cancelled',
        );
      }

      throw FirebaseAuthException(
        code: 'google-sign-in-failed',
        message: e.description ?? 'Google sign-in failed',
      );
    }
  }

  Future<void> register({
    required String fullName,
    required String email,
    required String password,
    required String role,
  }) async {
    final UserCredential credential = await _firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password);

    final User user = credential.user!;

    await user.updateDisplayName(fullName);

    await _firestore.collection('users').doc(user.uid).set({
      'uid': user.uid,
      'fullName': fullName,
      'email': email,
      'role': role,
      'provider': 'email',
      if (role == UserRoles.seller) 'status': SellerStatus.pending,
      'createdAt': FieldValue.serverTimestamp(),
    });

    if (role == UserRoles.seller) {
      await _writeSellerProfile(
        uid: user.uid,
        name: fullName,
        email: email,
      );
    }
  }

  Future<void> _writeSellerProfile({
    required String uid,
    required String name,
    required String email,
  }) async {
    await _firestore.collection('sellers').doc(uid).set({
      'uid': uid,
      'name': name,
      'email': email,
      'status': SellerStatus.pending,
      'isActive': false,
      'submittedAt': FieldValue.serverTimestamp(),
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<String> registerWithGoogle({required String selectedRole}) async {
    await _initGoogleSignIn();

    try {
      final GoogleSignInAccount googleUser = await _googleSignIn.authenticate();

      final GoogleSignInAuthentication googleAuth = googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await _firebaseAuth
          .signInWithCredential(credential);

      final bool isNewUser =
          userCredential.additionalUserInfo?.isNewUser ?? false;

      final User user = userCredential.user!;

      if (!isNewUser) {
        await signOut();
        throw FirebaseAuthException(
          code: 'account-already-exists',
          message: 'You are already registered. Please log in instead.',
        );
      }

      await _firestore.collection('users').doc(user.uid).set({
        'uid': user.uid,
        'fullName': user.displayName ?? '',
        'email': user.email ?? '',
        'role': selectedRole,
        'provider': 'google',
        if (selectedRole == UserRoles.seller) 'status': SellerStatus.pending,
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (selectedRole == UserRoles.seller) {
        await _writeSellerProfile(
          uid: user.uid,
          name: user.displayName ?? '',
          email: user.email ?? '',
        );
      }

      return selectedRole;
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) {
        throw FirebaseAuthException(
          code: 'google-sign-in-cancelled',
          message: 'Google sign-in cancelled',
        );
      }

      throw FirebaseAuthException(
        code: 'google-sign-in-failed',
        message: e.description ?? 'Google sign-in failed',
      );
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _firebaseAuth.signOut();
    HiveHelper.clearRoleBox();
    HiveHelper.clearStatusBox();
  }

  Future<void> sendPasswordReset({required String email}) async {
    final querySnapshot = await _firestore
        .collection('users')
        .where('email', isEqualTo: email.trim())
        .limit(1)
        .get();

    if (querySnapshot.docs.isEmpty) {
      throw FirebaseAuthException(
        code: 'user-not-found',
        message: 'No account found with this email.',
      );
    }

    final data = querySnapshot.docs.first.data();
    final provider = data['provider'];

    if (provider == 'google') {
      throw FirebaseAuthException(
        code: 'google-account',
        message:
            'This account was created with Google. Please sign in with Google.',
      );
    }

    await _firebaseAuth.sendPasswordResetEmail(email: email.trim());
  }
}
