import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:reso/consts/strings_german.dart';

enum LoginState {
  loggedOut,
  enterEmail,
  login,
  signUp,
  authenticated,
}

typedef ErrorCallback = void Function(dynamic e, StackTrace stackTrace);

typedef Validator = String? Function(String? string);

class AuthManager with ChangeNotifier {
  AuthManager({@visibleForTesting FirebaseAuth? authOverride})
      : _auth = authOverride ?? FirebaseAuth.instance {
    _email = null;
    _displayName = null;
    _imageRef = null;
    _auth.authStateChanges().listen((User? currentUser) {
      if (currentUser != null) {
        _loginState = LoginState.authenticated;
      } else {
        _loginState = LoginState.loggedOut;
      }
      notifyListeners();
    });
  }
  final FirebaseAuth _auth;

  LoginState get loginState => _loginState;
  LoginState _loginState = LoginState.loggedOut;

  bool get fetching => _fetching;
  bool _fetching = false;

  String? get email => _email;
  String? _email;
  String? get displayName => _displayName;
  String? _displayName;
  String? get imageRef => _imageRef;
  String? _imageRef;
  bool get isNewUser => _isNewUser;
  bool _isNewUser = true;

  static String? emailValidator(String? email) {
    if (email == null || (email = email.trim()).isEmpty) {
      return EMAIL_EMPTY;
    }

    final String preAt = email.split('@')[0];
    final String postAt = email.split('@')[1];

    if (RegExp(r'[a-z]+\.[a-z]+').stringMatch(preAt) != preAt) {
      return EMAIL_FORMAT_INVALID;
    }

    if (RegExp(r'[a-z]+\.[a-z]+').stringMatch(postAt) != postAt) {
      return EMAIL_FORMAT_INVALID;
    }

    if (RegExp(r'(?:fau.de)').stringMatch(postAt) != postAt) {
      return EMAIL_DOMAIN_INVALID;
    }
  }

  static String? passwordValidator(String? password) {
    // TODO(motschel123): implement
  }
  static String? displayNameValidator(String? displayName) {
    // TODO(motschel123): implement
  }

  void startLoginFlow() {
    _loginState = LoginState.enterEmail;
    notifyListeners();
  }

  Future<void> submitEmail(String email, {ErrorCallback? errorCallback}) async {
    _fetching = true;
    notifyListeners();
    return _auth.fetchSignInMethodsForEmail(email).then((List<String> methods) {
      if (methods.contains('password')) {
        _loginState = LoginState.login;
      } else {
        _loginState = LoginState.signUp;
      }
    }).onError<FirebaseAuthException>(
        (FirebaseAuthException error, StackTrace stacktrace) {
      _loginState = LoginState.enterEmail;
      errorCallback?.call(error, stacktrace);
    }).whenComplete(() {
      _fetching = false;
      _email = email;
      notifyListeners();
    });
  }

  Future<void> signInWithEmailAndPassword(
    String email,
    String password, {
    ErrorCallback? errorCallback,
  }) {
    _fetching = true;
    notifyListeners();
    return _auth
        .signInWithEmailAndPassword(email: email, password: password)
        .then((_) {})
        .onError<FirebaseAuthException>(
      (FirebaseAuthException e, StackTrace s) {
        errorCallback?.call(e, s);
        _loginState = LoginState.enterEmail;
      },
    ).whenComplete(() {
      _fetching = false;
      notifyListeners();
    });
  }

  Future<void> registerAccount(String email, String password,
      {ErrorCallback? errorCallback}) async {
    _fetching = true;
    notifyListeners();

    return _auth
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((UserCredential userCredential) {
      _isNewUser = userCredential.additionalUserInfo?.isNewUser ?? false;
    }).catchError((dynamic error, StackTrace stack) async {
      errorCallback?.call(error, stack);
    }).whenComplete(() {
      _fetching = false;
      notifyListeners();
    });
  }

/*  Future<void> submitDisplayName(String newName,
      {ErrorCallback? errorCallback}) {
    _fetching = true;
    notifyListeners();
    return _userDataService.updateUserData(newDisplayName: newName).then((_) {
      _loginState = LoginState.uploadImage;
      notifyListeners();
    }).onError<FirebaseException>(
        (FirebaseException error, StackTrace stackTrace) {
      errorCallback?.call(error, stackTrace);
    }).whenComplete(() {
      _fetching = false;
      notifyListeners();
    });
  }

  Future<void> submitImage({ErrorCallback? errorCallback}) async {
    _fetching = true;
    notifyListeners();
    return StorageService.getImageUrl(DEFAULT_PROFILE_IMAGE_NAME)
        .then((String imageUrl) => _auth.currentUser!.updatePhotoURL(imageUrl))
        .then((_) {
      _loginState = LoginState.registered;
      notifyListeners();
    }).onError<FirebaseException>((FirebaseException e, StackTrace stacktrace) {
      errorCallback?.call(e, stacktrace);
    }).whenComplete(() {
      _fetching = false;
      notifyListeners();
    });
  }*/

  void cancelRegistration() {
    _loginState = LoginState.enterEmail;
    notifyListeners();
  }

  void cancelLogin() {
    _loginState = LoginState.enterEmail;
    notifyListeners();
  }

  void signOut() {
    _auth.signOut();
  }
}
