import 'package:flutter/material.dart';

class MainLayout extends StatelessWidget {
  const MainLayout(
      {Key? key,
      required this.title,
      required this.body,
      required this.bottomNavigationBar})
      : super(key: key);

  final String title;
  final Widget body;
  final BottomNavigationBar bottomNavigationBar;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            title,
            style: Theme.of(context).textTheme.headline1,
          ),
        ),
      ),
      body: body,
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}
