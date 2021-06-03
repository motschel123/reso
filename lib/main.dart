import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:reso/auth/application_state.dart';
import 'package:reso/consts/theme.dart';
import 'package:reso/initialize_app.dart';
import 'package:reso/ui/screens/authentication.dart';

void main() {
  runApp(
    InitializeApp(
      app: const App(),
      providers: <SingleChildWidget>[
        ChangeNotifierProvider<ApplicationState>(
            create: (BuildContext context) => ApplicationState()),
      ],
    ),
  );
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ReSo',
      theme: lightTheme,
      home: Consumer<ApplicationState>(
        builder: (BuildContext context, ApplicationState appState, _) =>
            Authentication(
          email: appState.email,
          loginState: appState.loginState,
          startLoginFlow: appState.startLoginFlow,
          verifyEmail: appState.verifyEmail,
          signInWithEmailAndPassword: appState.signInWithEmailAndPassword,
          cancelRegistration: appState.cancelRegistration,
          cancelLogin: appState.cancelLogin,
          registerAccount: appState.registerAccount,
          signOut: appState.signOut,
        ),
      ),
    );
  }
}
