import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  bool _googleInitialized = false;

  Future<void> _initGoogleSignIn() async {
    if (_googleInitialized) return;

    await _googleSignIn.initialize();
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

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _firebaseAuth.signOut();
  }
}