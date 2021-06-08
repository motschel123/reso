import 'package:firebase_auth/firebase_auth.dart';
import 'package:reso/business_logic/providers/auth_manager.dart';

class FirebaseAuthManager extends AuthManager {
  @override
  LoginState get loginState => _loginState;
  LoginState _loginState = LoginState.loggedOut;

  @override
  String? get email => _email;
  String? _email;

  @override
  void startLoginFlow() {
    _loginState = LoginState.emailAddress;
    notifyListeners();
  }

  @override
  Future<void> verifyEmail(
    String email,
    void Function(FirebaseAuthException e) errorCallback,
  ) async {
    try {
      final List<String> methods =
          await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);

      if (methods.contains('password')) {
        _loginState = LoginState.password;
        notifyListeners();
      } else {
        _loginState = LoginState.register;
        notifyListeners();
      }
      _email = email;
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      errorCallback(e);
    }
  }

  @override
  Future<void> signInWithEmailAndPassword(
    String email,
    String password,
    void Function(FirebaseAuthException e) errorCallback,
  ) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      print('signed in');
    } on FirebaseAuthException catch (e) {
      errorCallback(e);
    }
  }

  @override
  void cancelRegistration() {
    _loginState = LoginState.emailAddress;
    notifyListeners();
  }

  @override
  void cancelLogin() {
    _loginState = LoginState.emailAddress;
    notifyListeners();
  }

  @override
  Future<void> registerAccount(
      String email,
      String displayName,
      String password,
      void Function(FirebaseAuthException e) errorCallback) async {
    try {
      final UserCredential credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      await credential.user!.updateProfile(displayName: displayName);
    } on FirebaseAuthException catch (e) {
      errorCallback(e);
    }
  }

  @override
  void signOut() {
    _loginState = LoginState.loggedOut;
    notifyListeners();
    FirebaseAuth.instance.signOut();
  }
}
