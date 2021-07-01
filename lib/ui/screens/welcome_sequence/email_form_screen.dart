import 'package:flutter/material.dart';
import 'package:reso/ui/widgets/styled_form_elements.dart';

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
                Expanded(child: SizedBox(), flex: 1),
                Expanded(
                    child: Center(
                      child: Text(
                        "RESO",
                        style: TextStyle(fontSize: 70.0, color: Colors.orange),
                      ),
                    ),
                    flex: 4), // App-Name
                Expanded(
                    child: Center(
                      child: Text(
                        "Du kannst dich nur mit deiner FAU-Mail anmelden",
                        style: TextStyle(fontSize: 15.0),
                      ),
                    ),
                    flex: 2), // Text
                Expanded(child: SizedBox(), flex: 3),
                Expanded(
                    child: StyledTextFormField(
                      hintText: 'Email',
                      controller: _controller,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    flex: 4), // Email
                Expanded(child: SizedBox(), flex: 6),
                Expanded(
                    child: StyledButtonLarge(
                        text: 'Überprüfen',
                        color: Colors.blueGrey,
                        callback: () => widget.callback(_controller.text)),
                    flex: 2),
                Expanded(child: SizedBox(), flex: 2),
                /* StyledTextFormField(
                  hintText: 'Email',
                  controller: _controller,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16.0),
                StyledButtonLarge(
                    text: 'Weiter',
                    color: Colors.amber,
                    callback: () => widget.callback(_controller.text)) */
              ],
            ),
          ),
        ),
      ),
    );
  }
}
