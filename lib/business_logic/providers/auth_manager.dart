import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

enum LoginState {
  loggedIn,
  loggedOut,
  emailAddress,
  register,
  password,
}

typedef ErrorCallback = void Function(
    FirebaseAuthException e, StackTrace stackTrace);

typedef ErrorCallbackNull = Null Function(
    FirebaseAuthException e, StackTrace stackTrace);

class AuthManager with ChangeNotifier {
  AuthManager() {
    _auth = FirebaseAuth.instance;
  }
  late final FirebaseAuth _auth;

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
  Future<void> verifyEmail(String email, {ErrorCallback? errorCallback}) async {
    return _auth.fetchSignInMethodsForEmail(email).then((List<String> methods) {
      if (methods.contains('password')) {
        _loginState = LoginState.password;
        notifyListeners();
      } else {
        _loginState = LoginState.register;
        notifyListeners();
      }
      _email = email;
      notifyListeners();
    }).onError<FirebaseAuthException>((FirebaseAuthException e, StackTrace s) {
      errorCallback?.call(e, s);
      return null;
    });
  }

  @override
  Future<void> signInWithEmailAndPassword(
    String email,
    String password, {
    ErrorCallback? errorCallback,
  }) {
    return _auth
        .signInWithEmailAndPassword(email: email, password: password)
        .then((_) {
      _loginState = LoginState.loggedIn;
      notifyListeners();
      print('signed in');
      // ignore: prefer_void_to_null
    }).onError<FirebaseAuthException>((FirebaseAuthException e, StackTrace s) {
      errorCallback?.call(e, s);
      return null;
    });
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
      String email, String displayName, String password,
      {ErrorCallback? errorCallback}) async {
    _auth
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((UserCredential credential) =>
            credential.user!.updateProfile(displayName: displayName))
        .onError<FirebaseAuthException>(
            (FirebaseAuthException e, StackTrace s) {
      errorCallback?.call(e, s);
      return null;
    });
  }

  @override
  void signOut() {
    _loginState = LoginState.loggedOut;
    notifyListeners();
    _auth.signOut();
  }
}
