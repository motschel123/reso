import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:reso/business_logic/providers/auth_manager.dart';
import 'package:reso/consts/strings_german.dart';

import 'auth_manager_test.mocks.dart';

@GenerateMocks(<Type>[], customMocks: <MockSpec<dynamic>>[
  MockSpec<FirebaseAuth>(
    as: Symbol('MockFirebaseAuth'),
    returnNullOnMissingStub: true,
  )
])
void main() {
  group('Validators', () {
    test('emailValidator should only validate @fau.de mails', () {
      final Map<String, String?> mails = <String, String?>{
        'marcel.schoeckel@gmail.com': EMAIL_DOMAIN_INVALID,
        'm.a@gmx.de': EMAIL_DOMAIN_INVALID,
        'richtige.mail@fau.de': null,
        'nochmal.richtig@fau.de': null,
        'keinmail.gamil@com': EMAIL_FORMAT_INVALID,
        'negat.iv@faude': EMAIL_FORMAT_INVALID,
        'nope.fau@de': EMAIL_FORMAT_INVALID,
        '': EMAIL_EMPTY,
        '       ': EMAIL_EMPTY,
      };

      mails.forEach((String mail, String? response) {
        expect(AuthManager.emailValidator(mail), response,
            reason: '$mail wrong validated');
      });
    });
    test('passwordValidator should validate passwords', () {
      // TODO(motschel123): implement
    });
    test('displayNameValidator should validate names', () {
      // TODO(motschel123): implement
    });
  });

  group('login flow', () {
    final MockFirebaseAuth mockAuth = MockFirebaseAuth();
    final StreamController<User?> streamController = StreamController<User?>();
    streamController.add(null);
    when(mockAuth.authStateChanges())
        .thenAnswer((Invocation realInvocation) => streamController.stream);

    final AuthManager authManager = AuthManager(authOverride: mockAuth);
    test('startLoginFlow', () {
      bool isNotified = false;
      void listener() {
        if (authManager.loginState == LoginState.enterEmail) {
          isNotified = true;
        }
      }

      authManager.addListener(listener);
      authManager.startLoginFlow();
      authManager.removeListener(listener);

      expect(isNotified, true, reason: "AuthManager din't notify listeners");
    });

    test('submitEmail', () async {
      const String LOGIN_MAIL = 'max.mustermann@fau.de';
      const String SIGNUP_MAIL = 'hans.mueller@fau.de';
      const String EXCPETION_MAIL = 'franz.steinhauer@fau.de';

      const List<String> loginReturn = <String>['password'];
      const List<String> signUpReturn = <String>[];
      final FirebaseAuthException authException = FirebaseAuthException(
          code: 'testCode',
          message: 'fetchSignInMethodForEmail threw exception');

      when(mockAuth.fetchSignInMethodsForEmail(LOGIN_MAIL))
          .thenAnswer((_) async => loginReturn);
      when(mockAuth.fetchSignInMethodsForEmail(SIGNUP_MAIL))
          .thenAnswer((_) async => signUpReturn);
      when(mockAuth.fetchSignInMethodsForEmail(EXCPETION_MAIL))
          .thenAnswer((_) => Future<List<String>>.error(authException));

      int loginNotified = 0;
      int signUpNotified = 0;
      int exceptionNotified = 0;
      int calledCallback = 0;

      void listener() {
        if (!authManager.fetching) {
          if (authManager.loginState == LoginState.login &&
              authManager.email == LOGIN_MAIL) {
            loginNotified++;
          } else if (authManager.loginState == LoginState.signUp &&
              authManager.email == SIGNUP_MAIL) {
            signUpNotified++;
          } else if (authManager.loginState == LoginState.enterEmail &&
              authManager.email == EXCPETION_MAIL) {
            exceptionNotified++;
          }
        }
      }

      authManager.addListener(listener);

      await authManager.submitEmail(LOGIN_MAIL);
      await authManager.submitEmail(SIGNUP_MAIL);
      await authManager.submitEmail(
        EXCPETION_MAIL,
        errorCallback: (Exception e, _) {
          if (e == authException) {
            calledCallback++;
          }
        },
      );

      authManager.removeListener(listener);

      expect(loginNotified, 1,
          reason:
              "Listeners haven't been notified after _loginState = LoginState.login or email hasn't been set");
      expect(signUpNotified, 1,
          reason:
              "Listeners haven't been notified after _loginState = LoginState.signUp or email hasn't been set");
      expect(exceptionNotified, 1,
          reason:
              "Listeners haven't been notified after exception was thrown and _loginState = LoginState.enterEmail or email hasn't been set");
      expect(calledCallback, 1,
          reason: "submitEmail didn't throw exception or didn't call callback");
    });
  });
}
