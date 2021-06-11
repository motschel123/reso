import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/single_child_widget.dart';
import 'package:reso/consts/theme.dart';
import 'package:reso/ui/screens/container/authentication.dart';
import 'package:reso/ui/screens/container/navigation.dart';
import 'business_logic/providers/chat_manager.dart';
import 'business_logic/providers/feed_manager.dart';
import 'business_logic/providers/profile_manager.dart';

final List<SingleChildWidget> _globalProviders = <SingleChildWidget>[
  ChangeNotifierProvider<FeedManager>(
      create: (BuildContext context) => FeedManager()),
  ChangeNotifierProvider<ChatManager>(
      create: (BuildContext context) => ChatManager()),
  ChangeNotifierProvider<ProfileManager>(
      create: (BuildContext context) => ProfileManager()),
];

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ReSo',
      theme: lightTheme,
      home: Authentication(
        child: MultiProvider(
          providers: _globalProviders,
          builder: (_, __) => const NavigationContainer(),
        ),
      ),
    );
  }
}
