import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

enum LoginState {
  loggedOut,
  emailAddress,
  register,
  password,
}

abstract class AuthManager {
  ValueNotifier<LoginState> get loginStateNotifier;
  ValueNotifier<User?> get currentUser;
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
