import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
export './firebase_impl/firebase_auth_manager.dart';

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

abstract class AuthManager extends ChangeNotifier {
  LoginState get loginState;
  String? get email;

  void startLoginFlow();
  Future<void> verifyEmail(String email, {ErrorCallback? errorCallback});
  Future<void> signInWithEmailAndPassword(String email, String password,
      {ErrorCallback? errorCallback});
  void cancelRegistration();
  void cancelLogin();
  Future<void> registerAccount(
      String email, String displayName, String password,
      {ErrorCallback? errorCallback});
  void signOut();
}
