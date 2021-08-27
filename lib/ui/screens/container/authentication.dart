import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reso/business_logic/providers/auth_manager.dart';
import 'package:reso/ui/widgets/styled_form_elements.dart';

class Authentication extends StatelessWidget {
  const Authentication({Key? key, required this.child}) : super(key: key);

  final Widget child;
  // TODO(motschel123): signIn with no passwort throws excption pls fix
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AuthManager>(
      create: (_) => AuthManager(),
      child: Consumer<AuthManager>(
        builder: (BuildContext context, AuthManager authManager, _) {
          Widget currentPage;
          switch (authManager.loginState) {
            case LoginState.loggedOut:
              currentPage =
                  LoggedOut(startLoginFlow: authManager.startLoginFlow);
              break;
            case LoginState.enterEmail:
              currentPage = EmailForm(
                callback: (String email) => authManager.submitEmail(
                  email,
                  errorCallback: (dynamic e, StackTrace s) =>
                      _showErrorDialog(context, 'Ungültige Email', e),
                ),
                emailValidator: AuthManager.emailValidator,
              );
              break;

            case LoginState.signUp:
              currentPage = SignUpForm(
                email: authManager.email!,
                cancel: authManager.cancelRegistration,
                registerAccount: (String email, String password) =>
                    authManager.registerAccount(
                  email,
                  password,
                  errorCallback: (dynamic e, StackTrace s) => _showErrorDialog(
                      context, 'Account konnte nicht erstellt werden', e),
                ),
                emailValidator: AuthManager.emailValidator,
                passwordValidator: AuthManager.passwordValidator,
              );
              break;

            case LoginState.login:
              currentPage = LoginForm(
                email: authManager.email!,
                cancel: authManager.cancelLogin,
                loginAccount: (String email, String password) => authManager
                    .signInWithEmailAndPassword(email, password,
                        errorCallback: (dynamic e, StackTrace stackTrace) {
                  _showErrorDialog(context, 'Anmeldung nicht erfolgreich', e);
                }),
                emailValidator: AuthManager.emailValidator,
                passwordValidator: AuthManager.passwordValidator,
              );
              break;
            case LoginState.authenticated:
              currentPage = child;
              break;
          }

          // Using IgnorePointer, Stack with AnimatedOpacity and CircularProgressIndicator
          // to signal fetching from server
          return IgnorePointer(
            child: Stack(
              children: <Widget>[
                Scaffold(body: currentPage),
                AnimatedOpacity(
                    opacity: authManager.fetching ? 0.8 : 0,
                    duration: const Duration(milliseconds: 400),
                    child: const ColorFiltered(
                        colorFilter: ColorFilter.mode(
                          Colors.black87,
                          BlendMode.darken,
                        ),
                        child: Placeholder(
                          fallbackHeight: double.infinity,
                          fallbackWidth: double.infinity,
                          color: Colors.transparent,
                        ))),
                if (authManager.fetching)
                  const Center(child: CircularProgressIndicator())
              ],
            ),
            ignoring: authManager.fetching,
          );
        },
      ),
    );
  }
}

class LoggedOut extends StatelessWidget {
  const LoggedOut({Key? key, required this.startLoginFlow}) : super(key: key);

  final void Function() startLoginFlow;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
    );
  }
}

class EmailForm extends StatefulWidget {
  const EmailForm(
      {Key? key, required this.callback, required this.emailValidator})
      : super(key: key);

  final void Function(String email) callback;
  final Validator emailValidator;

  @override
  _EmailFormState createState() => _EmailFormState();
}

class _EmailFormState extends State<EmailForm> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              StyledTextFormField(
                hintText: 'Email',
                autocorrect: false,
                controller: _controller,
                keyboardType: TextInputType.emailAddress,
                validator: widget.emailValidator,
              ),
              const SizedBox(height: 16.0),
              StyledButtonLarge(
                  text: 'Weiter',
                  color: Colors.amber,
                  callback: () {
                    final bool? valid = _formKey.currentState?.validate();
                    if (valid != null && valid)
                      widget.callback(_controller.text);
                  })
            ],
          ),
        ),
      ),
    );
  }
}

class SignUpForm extends StatefulWidget {
  const SignUpForm({
    Key? key,
    required this.registerAccount,
    required this.cancel,
    required this.email,
    required this.emailValidator,
    required this.passwordValidator,
  }) : super(key: key);

  final String email;
  final void Function(String email, String password) registerAccount;
  final void Function() cancel;
  final Validator emailValidator;
  final Validator passwordValidator;

  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final GlobalKey<FormState> _formKey = GlobalKey();
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
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              StyledTextFormField(
                hintText: 'Email',
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                validator: widget.emailValidator,
              ),
              const SizedBox(height: 8.0),
              StyledTextFormField(
                hintText: 'Passwort',
                controller: _passwordController,
                obscureText: true,
                validator: widget.passwordValidator,
              ),
              const SizedBox(height: 8.0),
              StyledTextFormField(
                hintText: 'Passwort wiederholen',
                controller: _repeatPasswordController,
                obscureText: true,
                validator: (String? repeatPass) =>
                    _passwordController.text == repeatPass
                        ? null
                        : 'Passwörter stimmen nicht überein',
              ),
              const SizedBox(height: 16.0),
              StyledButtonLarge(
                  text: 'Registrieren',
                  color: Colors.amber,
                  callback: () {
                    final bool? valid = _formKey.currentState?.validate();
                    if (valid != null && valid)
                      widget.registerAccount(
                          _emailController.text, _passwordController.text);
                  }),
              const SizedBox(height: 16.0),
              StyledButtonLarge(
                  text: 'Zurück', color: Colors.red, callback: widget.cancel),
            ],
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
    required this.emailValidator,
    required this.passwordValidator,
  }) : super(key: key);

  final String email;
  final void Function(String email, String password) loginAccount;
  final void Function() cancel;
  final Validator emailValidator;
  final Validator passwordValidator;

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _emailController.text = widget.email;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              StyledTextFormField(
                hintText: 'Email',
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                validator: widget.emailValidator,
              ),
              const SizedBox(height: 8.0),
              StyledTextFormField(
                hintText: 'Passwort',
                controller: _passwordController,
                obscureText: true,
                validator: widget.passwordValidator,
              ),
              const SizedBox(height: 8.0),
              StyledButtonLarge(
                text: 'Anmelden',
                color: Colors.amber,
                callback: () {
                  final bool? valid = _formKey.currentState?.validate();
                  if (valid != null && valid)
                    widget.loginAccount(
                        _emailController.text, _passwordController.text);
                },
              ),
              const SizedBox(height: 16.0),
              StyledButtonLarge(
                  text: 'Zurück', color: Colors.red, callback: widget.cancel),
            ],
          ),
        ),
      ),
    );
  }
}

class AuthenticatedScreen extends StatelessWidget {
  const AuthenticatedScreen({Key? key, required this.completeSignUp})
      : super(key: key);

  final void Function() completeSignUp;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          const Text('Authenticated'),
          TextButton(
              onPressed: completeSignUp,
              child: const Text('Finish Registration'))
        ],
      ),
    );
  }
}

class EnterNameForm extends StatefulWidget {
  const EnterNameForm({
    Key? key,
    required this.submitDisplayName,
    this.initialDisplayName,
    required this.displayNameValidator,
  }) : super(key: key);

  final Validator displayNameValidator;
  final Future<void> Function(String displayName) submitDisplayName;
  final String? initialDisplayName;

  @override
  State<StatefulWidget> createState() => _EnterNameFormState();
}

class _EnterNameFormState extends State<EnterNameForm> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController _displayNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _displayNameController.text = widget.initialDisplayName ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          const Text('Wie ist dein Name?'),
          StyledTextFormField(
            hintText: 'Nutze deinen echten Namen',
            controller: _displayNameController,
            validator: widget.displayNameValidator,
          ),
          TextButton(
              onPressed: () {
                final bool? valid = _formKey.currentState?.validate();
                if (valid != null && valid)
                  widget.submitDisplayName(_displayNameController.text);
              },
              child: const Text('Weiter'))
        ],
      ),
    ));
  }
}

void _showErrorDialog(BuildContext context, String title, dynamic e) {
  showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title, style: Theme.of(context).textTheme.headline2),
          content: Text('${e.message}',
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
