import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:reso/business_logic/providers/message_manager.dart';
import 'package:reso/model/chat.dart';
import 'package:reso/model/offer.dart';
import 'package:reso/ui/screens/chat_dialogue.dart';
import 'package:reso/ui/screens/main/live_feed.dart';
import 'package:reso/ui/screens/main/messaging.dart';
import 'package:reso/ui/screens/main/profile.dart';
import 'package:reso/ui/screens/main/search.dart';

final GlobalKey<NavigatorState> appNavigatorKey = GlobalKey<NavigatorState>();

class NavigationContainer extends StatefulWidget {
  const NavigationContainer({Key? key}) : super(key: key);

  @override
  _NavigationContainerState createState() => _NavigationContainerState();
}

class _NavigationContainerState extends State<NavigationContainer> {
  int _selectedIndex = 0;
  final List<Widget> _widgetOptions = <Widget>[
    const LiveFeed(),
    const SearchOffers(),
    const Messaging(),
    const Profile(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: appNavigatorKey,
      initialRoute: '/',
      onGenerateRoute: (RouteSettings settings) {
        WidgetBuilder builder;
        switch (settings.name) {
          case '/':
            builder = (BuildContext context) => Scaffold(
                  body: _widgetOptions[_selectedIndex],
                  bottomNavigationBar: BottomNavigationBar(
                    unselectedItemColor: Theme.of(context).buttonColor,
                    items: const <BottomNavigationBarItem>[
                      BottomNavigationBarItem(
                        icon: Icon(Icons.feed),
                        label: 'Feed',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.search),
                        label: 'Suchen',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.message),
                        label: 'Nachrichten',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.person),
                        label: 'Profil',
                      ),
                    ],
                    currentIndex: _selectedIndex,
                    selectedItemColor: Colors.amber,
                    onTap: _onItemTapped,
                  ),
                );
            break;
          case ChatDialogue.routeId:
            Chat chat;
            Offer offer;
            try {
              HashMap<String, dynamic> args =
                  settings.arguments! as HashMap<String, dynamic>;
              chat = args['chat'] as Chat;
              offer = args['offer'] as Offer;
            } catch (e) {
              throw FormatException(
                  "Couldn't parse settings.arguments required for ChatDialogue! Required values 'chat', 'offer'! $e");
            }

            builder = (BuildContext context) =>
                ChatDialogue(messageManager: MessageManager(chat, offer));
            break;
          default:
            throw const FormatException('Unknown route');
        }
        return MaterialPageRoute<void>(builder: builder, settings: settings);
      },
    );
  }
}
