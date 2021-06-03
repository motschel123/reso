import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reso/auth/application_state.dart';
import 'package:reso/consts/theme.dart';
import 'package:reso/ui/screens/navigation.dart';
import 'package:reso/ui/screens/authentication.dart';

void main() {
  //  runApp(const InitializeApp(child: MyApp()));
  runApp(ChangeNotifierProvider<ApplicationState>(
      create: (BuildContext context) => ApplicationState(),
      builder: (BuildContext context, _) => const App()));
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ReSo',
      theme: lightTheme,
      // home: const CreateOffer(),
      // home: const OfferDetail(
      //   offerTitle: '3D-Druck',
      //   offerPrice: 'ab 3,00€',
      //   offerDescription:
      //       'FDM Druck mit verschiedenen Farben\nPLA und TPU, Preis je nach Objekt',
      //   offerAuthor: 'Luca Beetz',
      //   profileImage: 'https://thispersondoesnotexist.com/image',
      //   offerImage:
      //       'https://www.twopeasandtheirpod.com/wp-content/uploads/2021/03/Veggie-Pizza-8-500x375.jpg',
      //   offerColor: Colors.amber,
      // ),
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
