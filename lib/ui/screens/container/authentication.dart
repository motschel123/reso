import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reso/ui/screens/welcome_sequence/logged_out_screen.dart';
import 'package:reso/ui/screens/welcome_sequence/email_form_screen.dart';
import 'package:reso/ui/screens/welcome_sequence/register_form_screen.dart';
import 'package:reso/ui/screens/welcome_sequence/login_form_screen.dart';
import 'package:reso/business_logic/auth_manager.dart';
import 'package:reso/business_logic/firebase/firebase_auth_manager.dart';
import 'package:reso/ui/widgets/styled_form_elements.dart';

import '../loading_screen.dart';

class Authentication extends StatelessWidget {
  const Authentication(
      {Key? key, required this.child, required this.authenticationState})
      : super(key: key);

  final Widget child;
  final FirebaseAuthManager authenticationState;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, AsyncSnapshot<User?> userSnapshot) {
          if (userSnapshot.connectionState == ConnectionState.active ||
              userSnapshot.connectionState == ConnectionState.done) {
            if (userSnapshot.hasError) {
              /**
             * FirebaseAuth ERROR 
             */
              throw userSnapshot.error!;
            } else if (userSnapshot.hasData) {
              /**
             * USER IS LOGGED IN
             */
              // Provide the currentUser
              // Provide UserDataService
              return Provider<User>.value(
                value: userSnapshot.data!,
                child: child,
              );
            } else {
              /**
             * user is NOT LOGGED IN 
             */
              return _AuthenticationScreen();
            }
          }
          return const LoadingScreen();
        });
  }
}

class _AuthenticationScreen extends StatelessWidget {
  final FirebaseAuthManager _authStateManager = FirebaseAuthManager();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<LoginState>(
      valueListenable: _authStateManager.loginStateNotifier,
      builder: (BuildContext context, LoginState loginState, _) {
        switch (loginState) {
          case LoginState.loggedOut:
            return LoggedOut(
                startLoginFlow: () => _authStateManager.startLoginFlow());

          case LoginState.emailAddress:
            return EmailForm(
              callback: (String email) => _authStateManager.verifyEmail(
                email,
                (Exception e) =>
                    _showErrorDialog(context, 'Ungültige Email', e),
              ),
            );

          case LoginState.register:
            return RegisterForm(
                email: _authStateManager.email!,
                cancel: _authStateManager.cancelRegistration,
                registerAccount: (String email, String displayName,
                        String password) =>
                    _authStateManager.registerAccount(
                      email,
                      displayName,
                      password,
                      (Exception e) => _showErrorDialog(
                          context, 'Account konnte nicht erstellt werden', e),
                    ));

          case LoginState.password:
            return LoginForm(
              email: _authStateManager.email!,
              cancel: _authStateManager.cancelLogin,
              loginAccount: (String email, String password) =>
                  _authStateManager.signInWithEmailAndPassword(
                      email,
                      password,
                      (Exception e) => _showErrorDialog(
                          context, 'Anmeldung nicht erfolgreich', e)),
            );
        }
      },
    );
  }
}

void _showErrorDialog(BuildContext context, String title, Exception e) {
  showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title, style: Theme.of(context).textTheme.headline2),
          content: Text('${(e as dynamic).message}',
              style: Theme.of(context).textTheme.bodyText1),
          actions: <Widget>[
            StyledButtonLarge(
                text: 'Ok',
                color: Colors.amber,
                callback: () {
                  Navigator.of(context).pop();
                }),
          ],
        );
      });
}
