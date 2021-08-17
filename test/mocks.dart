import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:mockito/mockito.dart';

class FirebaseAuthMock extends Mock implements FirebaseAuth {
  FirebaseAuthMock(this._user, this._userCredential);
  final User _user;
  final UserCredential _userCredential;

  final StreamController<User?> _authStateController =
      StreamController<User?>.broadcast();

  @override
  Stream<User?> authStateChanges() => _authStateController.stream;

  @override
  Future<UserCredential> signInWithEmailAndPassword(
      {required String email, required String password}) {
    _authStateController.add(_user);
    return Future<UserCredential>.value(_userCredential);
  }
}

class UserMock extends Mock implements User {}

class UserCredentialMock extends Mock implements UserCredential {}
