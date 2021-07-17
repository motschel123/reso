import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:reso/business_logic/providers/chat_manager.dart';
import 'package:reso/business_logic/providers/feed_manager.dart';
import 'package:reso/business_logic/providers/profile_manager.dart';
import 'package:reso/consts/theme.dart';
import 'package:reso/ui/screens/container/authentication.dart';
import 'package:reso/ui/screens/container/navigation.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  /*
   * Manage Crashlytics
   */
  if (kDebugMode) {
    // Force disable Crashlytics collection while doing every day development.
    // Temporarily toggle this to true if you want to test crash reporting in your app.
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
  } else {
    // Handle Crashlytics enabled status when not in Debug,
    // e.g. allow your users to opt-in to crash reporting.
    // TODO: add opt-in
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
  }
  runZonedGuarded<Future<void>>(() async {
    // Pass all uncaught errors from the framework to Crashlytics.
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

    runApp(const App());
  }, FirebaseCrashlytics.instance.recordError);
}

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

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
          providers: <SingleChildWidget>[
            // Global Providers
            ChangeNotifierProvider<FeedManager>(
                create: (BuildContext context) => FeedManager()),
            ChangeNotifierProvider<ChatManager>(
                create: (BuildContext context) => ChatManager()),
            ChangeNotifierProvider<ProfileManager>(
                create: (BuildContext context) => ProfileManager()),
          ],
          builder: (_, __) => const NavigationContainer(),
        ),
      ),
    );
  }
}
