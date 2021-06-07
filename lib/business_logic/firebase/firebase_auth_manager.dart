import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:reso/business_logic/auth_manager.dart';

class FirebaseAuthManager extends AuthManager {
  @override
  ValueNotifier<LoginState> get loginStateNotifier => _loginState;
  final ValueNotifier<LoginState> _loginState =
      ValueNotifier<LoginState>(LoginState.loggedOut);

  @override
  String? get email => _email;
  String? _email;

  @override
  void startLoginFlow() {
    _loginState.value = LoginState.emailAddress;
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
        _loginState.value = LoginState.password;
      } else {
        _loginState.value = LoginState.register;
      }
      _email = email;
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
    _loginState.value = LoginState.emailAddress;
  }

  @override
  void cancelLogin() {
    _loginState.value = LoginState.emailAddress;
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
    _loginState.value = LoginState.loggedOut;
    FirebaseAuth.instance.signOut();
  }
}
