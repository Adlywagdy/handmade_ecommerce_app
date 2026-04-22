import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

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

  Future<void> login({
    required String email,
    required String password,
  }) async {
    await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<UserCredential> signInWithGoogle() async {
    await _initGoogleSignIn();

    try {
      final GoogleSignInAccount googleUser =
          await _googleSignIn.authenticate();

      final GoogleSignInAuthentication googleAuth =
          googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      final userCredential =
          await _firebaseAuth.signInWithCredential(credential);

      print('GOOGLE LOGIN SUCCESS: ${userCredential.user?.email}');
      return userCredential;
    } on GoogleSignInException catch (e) {
      print('GOOGLE SIGN IN ERROR CODE: ${e.code}');
      print('GOOGLE SIGN IN ERROR DESC: ${e.description}');

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
    final UserCredential credential =
        await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final User user = credential.user!;

    await user.updateDisplayName(fullName);

    await _firestore.collection('users').doc(user.uid).set({
      'uid': user.uid,
      'fullName': fullName,
      'email': email,
      'role': role,
      'provider': 'email',
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<String> registerWithGoogle({
    required String selectedRole,
  }) async {
    await _initGoogleSignIn();

    try {
      final GoogleSignInAccount googleUser =
          await _googleSignIn.authenticate();

      final GoogleSignInAuthentication googleAuth =
          googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await _firebaseAuth.signInWithCredential(credential);

      final User user = userCredential.user!;
      final DocumentReference<Map<String, dynamic>> userDoc =
          _firestore.collection('users').doc(user.uid);

      final docSnapshot = await userDoc.get();

      String finalRole = selectedRole;

      if (docSnapshot.exists) {
        final data = docSnapshot.data();
        final existingRole = data?['role'];

        if (existingRole is String && existingRole.isNotEmpty) {
          finalRole = existingRole;
        }
      }

      await userDoc.set({
        'uid': user.uid,
        'fullName': user.displayName ?? '',
        'email': user.email ?? '',
        'role': finalRole,
        'provider': 'google',
        'createdAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      return finalRole;
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
  }
}