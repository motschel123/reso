import 'package:flutter/material.dart';
import 'package:reso/ui/widgets/styled_form_elements.dart';

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
                Expanded(child: SizedBox(), flex: 2),
                Expanded(
                    child: Center(
                      child: Text(
                        "RESO",
                        style: TextStyle(fontSize: 70.0, color: Colors.yellow),
                      ),
                    ),
                    flex: 8), // App-Name
                Expanded(
                    child: Center(
                      child: Text(
                        "Wilkommen zurück", //"Hey, willkommen in unserer Community"
                        style: TextStyle(fontSize: 15.0),
                      ),
                    ),
                    flex: 4), // Text
                Expanded(child: SizedBox(), flex: 6),
                Expanded(
                    child: StyledTextFormField(
                      hintText: 'Email',
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    flex: 4), //Email
                Expanded(child: SizedBox(), flex: 4),
                Expanded(
                    child: StyledTextFormField(
                      hintText: 'Passwort',
                      controller: _passwordController,
                      obscureText: true,
                    ),
                    flex: 4), //Passwort
                Expanded(child: SizedBox(), flex: 10),
                Expanded(
                    child: StyledButtonLarge(
                        text: 'Einloggen',
                        color: Colors.blueGrey,
                        callback: () => widget.loginAccount(
                            _emailController.text, _passwordController.text)),
                    flex: 4),
                Expanded(child: SizedBox(), flex: 1),
                Expanded(
                    child: StyledButtonLarge(
                        text: 'Zurück',
                        color: Colors.red,
                        callback: widget.cancel),
                    flex: 4),
                Expanded(child: SizedBox(), flex: 1),
                /*StyledTextFormField(
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
                    text: 'Zurück', color: Colors.red, callback: widget.cancel), */
              ],
            ),
          ),
        ),
      ),
    );
  }
}
