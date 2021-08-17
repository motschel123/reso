import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:reso/business_logic/services/storage_service.dart';
import 'package:reso/business_logic/services/user_data_service.dart';
import 'package:reso/consts/firestore.dart';
import 'package:reso/consts/strings_german.dart';
import 'package:reso/model/user_profile.dart';

enum LoginState {
  loggedOut,
  enterEmail,
  login,
  signUp,
  authenticated,
  enterName,
  uploadImage,
  registered,
}

typedef ErrorCallback = void Function(Exception e, StackTrace stackTrace);

typedef Validator = String? Function(String? string);

class AuthManager with ChangeNotifier {
  AuthManager({FirebaseAuth? authOverride})
      : _auth = authOverride ?? FirebaseAuth.instance {
    _email = null;
    _displayName = null;
    _imageRef = null;
    _auth.authStateChanges().listen((User? currentUser) async {
      if (currentUser != null) {
        // signed in
        switch (_loginState) {
          case LoginState.loggedOut:
          case LoginState.enterEmail:
          case LoginState.signUp:
          case LoginState.login:
            _userAuthenticated();
            break;
          default:
            break;
        }
      } else {
        // signed out
        switch (_loginState) {
          case LoginState.authenticated:
          case LoginState.enterName:
          case LoginState.uploadImage:
          case LoginState.registered:
            _userSignedOut();
            break;
          default:
            break;
        }
      }
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

  String? emailValidator(String? email) {
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

  String? passwordValidator(String? password) {
    // TODO(motschel123): implement
  }
  String? displayNameValidator(String? displayName) {
    // TODO(motschel123): implement
  }

  void startLoginFlow() {
    _loginState = LoginState.enterEmail;
    notifyListeners();
  }

  Future<void> checkEmail(String email, {ErrorCallback? errorCallback}) async {
    _fetching = true;
    notifyListeners();
    return _auth.fetchSignInMethodsForEmail(email).then((List<String> methods) {
      if (methods.contains('password')) {
        _loginState = LoginState.login;
      } else {
        _loginState = LoginState.signUp;
      }
      _email = email;
    }).onError<FirebaseAuthException>((FirebaseAuthException e, StackTrace s) {
      errorCallback?.call(e, s);
    }).whenComplete(() {
      _fetching = false;
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
        .then((_) => null)
        .onError<FirebaseAuthException>(
      (FirebaseAuthException e, StackTrace s) {
        errorCallback?.call(e, s);
      },
    );
  }

  Future<void> registerAccount(String email, String password,
      {ErrorCallback? errorCallback}) async {
    _fetching = true;
    notifyListeners();

    return _auth
        .createUserWithEmailAndPassword(email: email, password: password)
        .then<String>((UserCredential user) async {
      // wait for firebase function to create user document
      final String uid = user.user!.uid;
      final bool exists = await UserDataService.waitUserDocExists(uid);
      if (exists) {
        return uid;
      } else {
        throw FirebaseException(
          plugin: 'FirebaseFunctions',
          message: "User document couldn't be created",
        );
      }
    }).then((String uid) async {
      // get the default values from user document to display in ui
      final UserProfile profile = await UserDataService.getUserProfile(uid);
      _displayName = profile.displayName;
      _imageRef = profile.imageRef;
      notifyListeners();
    }).onError<FirebaseException>((FirebaseException e, StackTrace stacktrace) {
      errorCallback?.call(e, stacktrace);
    }).whenComplete(() {
      _fetching = false;
      notifyListeners();
    });
  }

  void completeSignUp() {
    if (_auth.currentUser!.displayName == null) {
      _loginState = LoginState.enterName;
    } else {
      _loginState = LoginState.registered;
    }
    notifyListeners();
  }

  Future<void> submitDisplayName(String newName,
      {ErrorCallback? errorCallback}) {
    _fetching = true;
    notifyListeners();
    return UserDataService.updateUserData(newDisplayName: newName).then((_) {
      _loginState = LoginState.uploadImage;
      notifyListeners();
    }).onError<Exception>((Exception error, StackTrace stackTrace) {
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
    }).onError<Exception>((Exception e, StackTrace stacktrace) {
      errorCallback?.call(e, stacktrace);
    }).whenComplete(() {
      _fetching = false;
      notifyListeners();
    });
  }

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

  /// has to be called when user sign in or registers
  FutureOr<void> _userAuthenticated({ErrorCallback? errorCallback}) {
    if (_auth.currentUser!.displayName == null)
      // wait for user doc to be created
      return UserDataService.waitUserDocExists(_auth.currentUser!.uid)
          // get user doc
          .then<UserProfile>((bool exists) {
        if (!exists)
          throw FirebaseException(
              plugin: 'FirebaseFunctions',
              message: "User data couldn't be written");
        return UserDataService.getUserProfile(_auth.currentUser!.uid);
        // updated initial values for ui
      }).then((UserProfile profile) {
        _displayName = profile.displayName;
        _imageRef = profile.imageRef;
        _loginState = LoginState.authenticated;
        notifyListeners();
      }).onError<Exception>((Exception error, StackTrace stackTrace) {
        errorCallback?.call(error, stackTrace);
      });
    else {
      _loginState = LoginState.registered;
      notifyListeners();
    }
  }

  /// has to be called when FirebaseAuth reports user signed out
  void _userSignedOut() {
    _loginState = LoginState.loggedOut;
    notifyListeners();
  }
}
