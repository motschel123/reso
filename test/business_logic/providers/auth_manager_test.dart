import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:reso/business_logic/providers/auth_manager.dart';
import 'package:reso/business_logic/services/user_data_service.dart';
import 'package:reso/consts/strings_german.dart';
import 'package:reso/model/user_profile.dart';

import 'auth_manager_test.mocks.dart';

// workaround mocking static methods
Future<bool> waitUserDocExists(String uid) async =>
    UserDataService.waitUserDocExists(uid);

Future<UserProfile> getUserProfile(String uid) async =>
    UserDataService.getUserProfile(uid);

@GenerateMocks(<Type>[
  User,
  UserCredential,
  UserProfile
], customMocks: <MockSpec<dynamic>>[
  MockSpec<FirebaseAuth>(
    as: Symbol('MockFirebaseAuth'),
    returnNullOnMissingStub: true,
  ),
  MockSpec<UserDataService>(
      returnNullOnMissingStub: true,
      fallbackGenerators: <Symbol, Function>{
        Symbol('waitUserDocExists'): waitUserDocExists,
        Symbol('getUserProfile'): getUserProfile,
      })
])
void main() {
  const String exDisplayName = 'Max Mustermann';
  const String exUid = '12345';

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

  group('authentication flow', () {
    final MockUser mockUser = MockUser();
    final MockUserCredential mockUserCredential = MockUserCredential();
    final MockFirebaseAuth mockAuth = MockFirebaseAuth();
    final StreamController<User?> authStreamController =
        StreamController<User?>.broadcast();
    when(mockAuth.authStateChanges())
        .thenAnswer((Invocation realInvocation) => authStreamController.stream);

    AuthManager authManager = AuthManager(authOverride: mockAuth);

    int isFetchingNotified = 0;
    int notFetchingNotified = 0;
    int notFetchingAfterIsFetchingNotified = 0;
    int helperCount = 0;

    setUp(() {
      isFetchingNotified = 0;
      notFetchingNotified = 0;
      notFetchingAfterIsFetchingNotified = 0;

      clearInteractions(mockUser);
      clearInteractions(mockUserCredential);
      clearInteractions(mockAuth);

      when(mockAuth.authStateChanges()).thenAnswer(
          (Invocation realInvocation) => authStreamController.stream);
      authManager = AuthManager(authOverride: mockAuth);
    });

    void fetchNotificationListener() {
      if (authManager.fetching) {
        isFetchingNotified++;
        helperCount++;
      }
      if (!authManager.fetching) {
        notFetchingNotified++;
        if (helperCount > 0) {
          notFetchingAfterIsFetchingNotified++;
          helperCount = 0;
        }
      }
    }

    test('startLoginFlow', () {
      bool switchedStateToEnterEmail = false;
      bool notified = false;
      void listener() {
        notified = true;
        if (authManager.loginState == LoginState.enterEmail) {
          switchedStateToEnterEmail = true;
        }
      }

      authManager.addListener(listener);
      authManager.addListener(fetchNotificationListener);
      authManager.startLoginFlow();
      authManager.removeListener(listener);
      authManager.removeListener(fetchNotificationListener);

      expect(switchedStateToEnterEmail, true,
          reason: "AuthManager din't switch to enterEmail state");
      expect(notified, true,
          reason: "AuthManager didn't notify on switched state");
    });

    test('submitEmail fetchNotifications', () async {
      when(mockAuth.fetchSignInMethodsForEmail('login'))
          .thenAnswer((_) async => <String>['password']);
      when(mockAuth.fetchSignInMethodsForEmail('register'))
          .thenAnswer((_) async => <String>[]);
      when(mockAuth.fetchSignInMethodsForEmail('error'))
          .thenAnswer((_) => Future<List<String>>.error(FirebaseAuthException(
                code: 'invalid-email',
              )));

      authManager.addListener(fetchNotificationListener);

      await authManager.submitEmail('login');
      await authManager.submitEmail('register');
      await authManager.submitEmail('error');

      authManager.removeListener(fetchNotificationListener);

      expect(isFetchingNotified, greaterThanOrEqualTo(3),
          reason:
              "submitEmail doesn't notifyListeners of fetching=true in some cases ");
      expect(notFetchingNotified, greaterThanOrEqualTo(3),
          reason:
              "submitEmail doesn't notifyListeners after fetching=false in some cases");
      expect(notFetchingAfterIsFetchingNotified, equals(isFetchingNotified),
          reason:
              "submitEmail doesn't always set fetching=false and notifies listeners after fetching was set to true");
    });

    test('signInWithEmailAndPassword errors', () async {
      final List<String> badMails = <String>[
        'invalid-email',
        'user-disabled',
        'user-not-found',
        'wrong-password'
      ];

      authManager.addListener(fetchNotificationListener);

      for (final String mail in badMails) {
        when(mockAuth.signInWithEmailAndPassword(
                email: mail, password: anyNamed('password')))
            .thenAnswer((_) async => Future<UserCredential>.error(
                FirebaseAuthException(code: mail)));

        await authManager.signInWithEmailAndPassword(mail, 'passwort');

        expect(authManager.fetching, false,
            reason:
                "AuthMananger shouldn't be fetching after waiting for signIn with an error");
        expect(authManager.loginState, LoginState.enterEmail,
            reason:
                "AuthManager didn't keep his loginState after sign in error");
      }

      authManager.removeListener(fetchNotificationListener);

      verify(mockAuth.signInWithEmailAndPassword(
              email: anyNamed('email'), password: anyNamed('password')))
          .called(badMails.length);

      expect(isFetchingNotified, greaterThanOrEqualTo(badMails.length),
          reason:
              "signInWithEmailAndPassword didn't notify about fetching state");
      expect(notFetchingNotified, greaterThanOrEqualTo(badMails.length),
          reason:
              "signInWithEmailAndPassword didn't notify about end of fetching state");
      expect(notFetchingAfterIsFetchingNotified,
          greaterThanOrEqualTo(badMails.length),
          reason:
              "signInWithEmailAndPassword didn't notify the end of each started fetching state");
    });

    test('signInWithEmailAndPassword fetching if user registered', () async {
      // mock registered sign in
      when(mockAuth.signInWithEmailAndPassword(
              email: anyNamed('email'), password: anyNamed('password')))
          .thenAnswer((_) async {
        when(mockUser.displayName).thenReturn(exDisplayName);
        when(mockUser.uid).thenReturn(exUid);
        when(mockAuth.currentUser).thenReturn(mockUser);
        authStreamController.add(mockUser);
        return mockUserCredential;
      });

      authManager.addListener(fetchNotificationListener);
      await authManager.signInWithEmailAndPassword('email', 'password');
      await Future<void>.delayed(const Duration(seconds: 2));
      authManager.removeListener(fetchNotificationListener);

      expect(authManager.loginState, LoginState.registered,
          reason:
              "Authmanager didn't swtich to LoginState.registered after successfull signIn");

      expect(isFetchingNotified, greaterThanOrEqualTo(1),
          reason:
              "signInWithEmailAndPassword doesn't notify fetching for registered user signin");
      expect(notFetchingNotified, greaterThanOrEqualTo(1),
          reason:
              "signInWithEmailAndPassword doesn't notify end of fetching for registered user signin");
      expect(notFetchingAfterIsFetchingNotified, greaterThanOrEqualTo(1),
          reason:
              "signInWithEmailAndPassword doesn't notify end of fetching after start of fetching");
    });

    test('signInWithEmailAndPassword fetching if user not registered',
        () async {
      // mock new user sign in
      when(mockAuth.signInWithEmailAndPassword(
              email: anyNamed('email'), password: anyNamed('password')))
          .thenAnswer((_) async {
        when(mockUser.displayName).thenReturn(null);
        when(mockAuth.currentUser).thenReturn(mockUser);
        authStreamController.add(mockUser);
        return mockUserCredential;
      });

      // TODO: mock UserDataService for firebase response

      authManager.addListener(fetchNotificationListener);
      await authManager.signInWithEmailAndPassword('email', 'password');
      await Future<void>.delayed(const Duration(seconds: 2));
      authManager.removeListener(fetchNotificationListener);
    });

    test('registerAccount', () {});
    test('submitDisplayName', () {});

    test('submitImage', () {});

    test('_userAuthenticated', () {});

    /*group('login flow', () {
      final MockUser mockUser = MockUser();
      final MockUserCredential mockUserCredential = MockUserCredential();
      final MockFirebaseAuth mockAuth = MockFirebaseAuth();
      final StreamController<User?> authStreamController =
          StreamController<User?>.broadcast();
      authStreamController.add(null);
      when(mockAuth.authStateChanges()).thenAnswer(
          (Invocation realInvocation) => authStreamController.stream);

      final AuthManager authManager = AuthManager(authOverride: mockAuth);

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
            reason:
                "submitEmail didn't throw exception or didn't call callback");
      });

      test('signInWithEmailAndPassword', () {
        const String SIGN_IN_SUCCESSFUL_MAIL = 'max.mustermann@fau.de';
        const String INVALID_MAIL = 'nomail@fau';

        // case: sign in successful and user registered;
        when(mockAuth.signInWithEmailAndPassword(
                email: SIGN_IN_SUCCESSFUL_MAIL, password: any))
            // after sign in with valid email:
            .thenAnswer((Invocation realInvocation) async {
          // signal user is registered:
          when(mockUser.displayName).thenReturn('Max Mustermann');
          // auth.currentUser => mockUser to signal sign in
          when(mockAuth.currentUser).thenReturn(mockUser);
          // returned mockUserCredential are linked to mockUser
          when(mockUserCredential.user).thenReturn(mockUser);
          // add mockUser to authStateChanges to notify on sign in
          authStreamController.add(mockUser);
          // return mockUserCredential
          return Future<UserCredential>.value(mockUserCredential);
        });

        authManager.addListener(() {});
      });
    });*/
  });
}
