import 'package:flutter/material.dart';
import 'package:reso/ui/widgets/styled_form_elements.dart';

enum ApplicationLoginState {
  loggedOut,
  emailAddress,
  register,
  password,
}

class Authentication extends StatelessWidget {
  const Authentication({
    Key? key,
    required this.loginState,
    required this.email,
    required this.verifyEmail,
    required this.signInWithEmailAndPassword,
    required this.cancelRegistration,
    required this.cancelLogin,
    required this.registerAccount,
    required this.signOut,
  }) : super(key: key);

  final ApplicationLoginState loginState;
  final String? email;
  final void Function(
    String email,
    void Function(Exception e) error,
  ) verifyEmail;
  final void Function(
    String email,
    String password,
    void Function(Exception e) error,
  ) signInWithEmailAndPassword;
  final void Function() cancelRegistration;
  final void Function() cancelLogin;
  final void Function(
    String email,
    String password,
    void Function(Exception e) error,
  ) registerAccount;
  final void Function() signOut;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: buildAuthElements(context),
      )),
    );
  }

  Widget buildAuthElements(BuildContext context) {
    switch (loginState) {
      case ApplicationLoginState.loggedOut:
        return const AppTitle();

      case ApplicationLoginState.emailAddress:
        return EmailForm(
            callback: (String email) => verifyEmail(
                email,
                (Exception e) =>
                    _showErrorDialog(context, 'Ungültige Email', e)));

      case ApplicationLoginState.register:
        return RegisterForm(
          email: email!,
          cancel: cancelRegistration,
          registerAccount: (String email, String password) {
            registerAccount(
                email,
                password,
                (Exception e) => _showErrorDialog(
                    context, 'Account konnte nicht erstellt werden', e));
          },
        );

      case ApplicationLoginState.password:
        return LoginForm(
            email: email!,
            cancel: cancelLogin,
            loginAccount: (String email, String password) {
              signInWithEmailAndPassword(
                  email,
                  password,
                  (Exception e) => _showErrorDialog(
                      context, 'Anmeldung nicht erfolgreich', e));
            });
    }
  }
}

class AppTitle extends StatelessWidget {
  const AppTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
            height: 42.0,
            decoration: const BoxDecoration(
              color: Colors.amber,
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
            ),
            child: Center(
              child: Text(
                'Weiter',
                style: Theme.of(context).textTheme.button,
              ),
            )),
      ],
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
    return Form(
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
  Widget build(BuildContext context) {
    return Form(
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
  Widget build(BuildContext context) {
    return Form(
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
