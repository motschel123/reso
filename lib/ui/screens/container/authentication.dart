import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reso/business_logic/providers/auth_manager.dart';
import 'package:reso/ui/widgets/styled_form_elements.dart';

import '../loading_screen.dart';

class Authentication extends StatelessWidget {
  const Authentication({Key? key, required this.child}) : super(key: key);

  final Widget child;
  // TODO: signIn with no passwort throws excption pls fix
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AuthManager>(
      create: (BuildContext context) => AuthManager(),
      child: StreamBuilder<User?>(
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
                return child;
              } else {
                /**
               * user is NOT LOGGED IN 
               */
                return _AuthenticationScreen();
              }
            }
            return const LoadingScreen();
          }),
    );
  }
}

class _AuthenticationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthManager>(
      builder: (BuildContext context, AuthManager authManager, _) {
        switch (authManager.loginState) {
          case LoginState.loggedOut:
            return LoggedOut(
                startLoginFlow: () => authManager.startLoginFlow());

          case LoginState.emailAddress:
            return EmailForm(
              callback: (String email) => authManager.verifyEmail(
                email,
                errorCallback: (FirebaseAuthException e, StackTrace s) =>
                    _showErrorDialog(context, 'Ungültige Email', e),
              ),
            );

          case LoginState.register:
            return RegisterForm(
                email: authManager.email!,
                cancel: authManager.cancelRegistration,
                registerAccount: (String email, String password) =>
                    authManager.registerAccount(
                      email,
                      password,
                      errorCallback: (FirebaseAuthException e, StackTrace s) =>
                          _showErrorDialog(context,
                              'Account konnte nicht erstellt werden', e),
                    ));

          case LoginState.password:
            return LoginForm(
              email: authManager.email!,
              cancel: authManager.cancelLogin,
              loginAccount: (String email, String password) => authManager
                  .signInWithEmailAndPassword(email, password, errorCallback:
                      (FirebaseAuthException e, StackTrace stackTrace) {
                _showErrorDialog(context, 'Anmeldung nicht erfolgreich', e);
              }),
            );
          case LoginState.loggedIn:
            return const Center(child: Text('Anmelden...'));
        }
      },
    );
  }
}

class LoggedOut extends StatelessWidget {
  const LoggedOut({Key? key, required this.startLoginFlow}) : super(key: key);

  final void Function() startLoginFlow;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              StyledButtonLarge(
                  text: 'Anmelden / Registrieren',
                  color: Colors.amber,
                  callback: startLoginFlow),
            ],
          ),
        ),
      ),
    );
  }
}

class EmailForm extends StatefulWidget {
  const EmailForm({Key? key, required this.callback}) : super(key: key);

  final void Function(String email) callback;

  @override
  _EmailFormState createState() => _EmailFormState();
}

class _EmailFormState extends State<EmailForm> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                StyledTextFormField(
                  hintText: 'Email',
                  controller: _controller,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16.0),
                StyledButtonLarge(
                    text: 'Weiter',
                    color: Colors.amber,
                    callback: () => widget.callback(_controller.text))
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class RegisterForm extends StatefulWidget {
  const RegisterForm({
    Key? key,
    required this.registerAccount,
    required this.cancel,
    required this.email,
  }) : super(key: key);

  final String email;
  final void Function(String email, String password) registerAccount;
  final void Function() cancel;

  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _repeatPasswordController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    _emailController.text = widget.email;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                StyledTextFormField(
                  hintText: 'Email',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 8.0),
                StyledTextFormField(
                  hintText: 'Passwort',
                  controller: _passwordController,
                  obscureText: true,
                ),
                const SizedBox(height: 8.0),
                StyledTextFormField(
                  hintText: 'Passwort wiederholen',
                  controller: _repeatPasswordController,
                  obscureText: true,
                ),
                const SizedBox(height: 16.0),
                StyledButtonLarge(
                    text: 'Registrieren',
                    color: Colors.amber,
                    callback: () => widget.registerAccount(
                        _emailController.text, _passwordController.text)),
                const SizedBox(height: 16.0),
                StyledButtonLarge(
                    text: 'Zurück', color: Colors.red, callback: widget.cancel),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({
    Key? key,
    required this.loginAccount,
    required this.cancel,
    required this.email,
  }) : super(key: key);

  final String email;
  final void Function(String email, String password) loginAccount;
  final void Function() cancel;

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _emailController.text = widget.email;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                StyledTextFormField(
                  hintText: 'Email',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 8.0),
                StyledTextFormField(
                  hintText: 'Passwort',
                  controller: _passwordController,
                  obscureText: true,
                ),
                const SizedBox(height: 8.0),
                StyledButtonLarge(
                    text: 'Anmelden',
                    color: Colors.amber,
                    callback: () => widget.loginAccount(
                        _emailController.text, _passwordController.text)),
                const SizedBox(height: 16.0),
                StyledButtonLarge(
                    text: 'Zurück', color: Colors.red, callback: widget.cancel),
              ],
            ),
          ),
        ),
      ),
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
