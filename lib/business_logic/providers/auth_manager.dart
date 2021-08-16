import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:reso/business_logic/services/user_data_service.dart';

enum LoginState {
  loggedOut,
  enterEmail,
  login,
  signUp,
  authenticated,
  completeSignUp,
  registered,
}

typedef ErrorCallback = void Function(
    FirebaseAuthException e, StackTrace stackTrace);

typedef ErrorCallbackNull = Null Function(
    FirebaseAuthException e, StackTrace stackTrace);

typedef Validator = String? Function(String? string);

class AuthManager with ChangeNotifier {
  AuthManager() : _auth = FirebaseAuth.instance {
    _auth.authStateChanges().listen((User? currentUser) {
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
          case LoginState.completeSignUp:
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

  String? emailValidator(String? email) {
    if (email == null || (email = email.trim()).isEmpty)
      return 'Ungültige Email';

    final String preAt = email.split('@')[0];
    if (RegExp(r'[a-z]+\.[a-z]+').stringMatch(preAt) != preAt) {
      return 'Ungültige Email';
    }

    final String postAt = email.split('@')[1];
    if (RegExp(r'(?:fau.de)').stringMatch(postAt) != postAt) {
      return 'Nur fau.de mails zugelassen';
    }
  }

  String? passwordValidator(String? password) {}
  String? displayNameValidator(String? displayName) {}

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
        .then((_) {
      _loginState = LoginState.registered;
      print('signed in');
      // ignore: prefer_void_to_null
    }).onError<FirebaseAuthException>((FirebaseAuthException e, StackTrace s) {
      errorCallback?.call(e, s);
    }).whenComplete(() {
      _fetching = false;
      notifyListeners();
    });
  }

  Future<void> registerAccount(String email, String password,
      {ErrorCallback? errorCallback}) {
    _fetching = true;
    notifyListeners();

    return _auth
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((_) {
      final List<String> fullName =
          email.toLowerCase().split('@')[0].split('.');
      final String firstName =
          fullName[0][0].toUpperCase() + fullName[0].substring(1);
      final String lastName =
          fullName[1][0].toUpperCase() + fullName[1].substring(1);
      _displayName = '$firstName $lastName';
    }).whenComplete(() {
      _fetching = false;
      notifyListeners();
    });
  }

  void completeSignUp() {
    _loginState = LoginState.completeSignUp;
    notifyListeners();
  }

  Future<void> submitDisplayName(String newName) {
    _fetching = true;
    notifyListeners();
    return UserDataService.updateUserData(newDisplayName: newName)
        .then((_) => _loginState = LoginState.registered)
        .whenComplete(() {
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

  /// has to be called when FirebaseAuth reports user signed in
  Future<void> _userAuthenticated() async {
    _fetching = true;
    notifyListeners();
    if (_auth.currentUser!.displayName != null) {
      _loginState = LoginState.registered;
    } else {
      _loginState = LoginState.authenticated;
    }
    return UserDataService.waitUserDocExists(_auth.currentUser!.uid)
        .then((bool exists) {
      if (!exists) {
        throw Exception('User doc not created');
      }
    }).whenComplete(() {
      _fetching = false;
      notifyListeners();
    });
  }

  /// has to be called when FirebaseAuth reports user signed out
  void _userSignedOut() {
    _loginState = LoginState.loggedOut;
    notifyListeners();
  }
}
