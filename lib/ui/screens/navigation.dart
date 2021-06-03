import 'package:flutter/material.dart';
import 'package:reso/ui/screens/create_offer.dart';
import 'package:reso/ui/screens/live_feed.dart';

class NavigationContainer extends StatefulWidget {
  const NavigationContainer({Key? key}) : super(key: key);

  @override
  _NavigationContainerState createState() => _NavigationContainerState();
}

class _NavigationContainerState extends State<NavigationContainer> {
  int _selectedIndex = 0;
  static const List<Widget> _widgetOptions = <Widget>[
    LiveFeed(),
    CreateOffer(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.feed),
            label: 'Feed',
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
  }
}
