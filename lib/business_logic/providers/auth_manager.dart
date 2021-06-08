import 'package:flutter/material.dart';
export './firebase_impl/firebase_auth_manager.dart';

enum LoginState {
  loggedOut,
  emailAddress,
  register,
  password,
}

abstract class AuthManager extends ChangeNotifier {
  LoginState get loginState;
  String? get email;

  void startLoginFlow();
  Future<void> verifyEmail(
      String email, void Function(Exception e) errorCallback);
  Future<void> signInWithEmailAndPassword(
      String email, String password, void Function(Exception e) errorCallback);
  void cancelRegistration();
  void cancelLogin();
  Future<void> registerAccount(String email, String displayName,
      String password, void Function(Exception e) errorCallback);
  void signOut();
}
