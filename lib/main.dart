import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:reso/business_logic/providers/auth_manager.dart';
import 'package:reso/business_logic/providers/chat_manager.dart';
import 'package:reso/business_logic/providers/feed_manager.dart';
import 'package:reso/business_logic/providers/profile_manager.dart';
import 'package:reso/consts/theme.dart';
import 'package:reso/initialize_app.dart';
import 'package:reso/ui/screens/container/authentication.dart';
import 'package:reso/ui/screens/container/navigation.dart';

void main() {
  runApp(
    InitializeApp(
      app: const App(),
      providers: <SingleChildWidget>[
        Provider<AuthManager>(
            create: (BuildContext context) => FirebaseAuthManager()),
        ChangeNotifierProvider<FeedManager>(
            create: (BuildContext context) => FirebaseFeedManager()),
        Provider<ChatManager>(
            create: (BuildContext context) => FirebaseChatManager()),
        ChangeNotifierProvider<ProfileManager>(
            create: (BuildContext context) => ProfileManager()),
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
      home: Authentication(
        child: const NavigationContainer(),
        authenticationState: FirebaseAuthManager(),
      ),
    );
  }
}
