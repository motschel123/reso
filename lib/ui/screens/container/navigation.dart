import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:reso/business_logic/providers/message_manager.dart';
import 'package:reso/model/chat.dart';
import 'package:reso/model/offer.dart';
import 'package:reso/ui/screens/chat_dialogue.dart';
import 'package:reso/ui/screens/main/live_feed.dart';
import 'package:reso/ui/screens/main/main_layout.dart';
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

  final List<_NavigationOption> _navOptions = <_NavigationOption>[
    const _NavigationOption(
      title: 'Feed',
      bottomNavigationBarItem: BottomNavigationBarItem(
        icon: Icon(Icons.feed),
        label: 'Feed',
      ),
      widget: LiveFeed(),
    ),
    const _NavigationOption(
      title: 'Suche',
      bottomNavigationBarItem: BottomNavigationBarItem(
        icon: Icon(Icons.search),
        label: 'Suchen',
      ),
      widget: SearchOffers(),
    ),
    const _NavigationOption(
      title: 'Nachrichten',
      bottomNavigationBarItem: BottomNavigationBarItem(
        icon: Icon(Icons.message),
        label: 'Nachrichten',
      ),
      widget: Messaging(),
    ),
    const _NavigationOption(
      title: 'Profil',
      bottomNavigationBarItem: BottomNavigationBarItem(
        icon: Icon(Icons.person),
        label: 'Profil',
      ),
      widget: Profile(),
    ),
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
            builder = (BuildContext context) => MainLayout(
                  title: _navOptions[_selectedIndex].title,
                  body: _navOptions[_selectedIndex].widget,
                  bottomNavigationBar: BottomNavigationBar(
                    unselectedItemColor: Theme.of(context).buttonColor,
                    items: _navOptions
                        .map((_NavigationOption navOp) =>
                            navOp.bottomNavigationBarItem)
                        .toList(),
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
              final HashMap<String, dynamic> args =
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

class _NavigationOption {
  const _NavigationOption({
    required this.title,
    required this.bottomNavigationBarItem,
    required this.widget,
  });

  final String title;
  final BottomNavigationBarItem bottomNavigationBarItem;
  final Widget widget;
}
