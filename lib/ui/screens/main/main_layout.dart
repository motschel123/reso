import 'package:flutter/material.dart';
import 'package:reso/ui/screens/create_offer.dart';

class MainLayout extends StatelessWidget {
  const MainLayout(
      {Key? key,
      required this.title,
      required this.body,
      required this.actions,
      required this.bottomNavigationBar})
      : super(key: key);

  final String title;
  final Widget body;
  final List<Widget>? actions;
  final BottomNavigationBar bottomNavigationBar;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        backgroundColor: Colors.amber,
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute<CreateOffer>(
              builder: (BuildContext context) => const CreateOffer()));
        },
      ),
      backgroundColor: Colors.white,
      appBar: AppBar(
        actions: actions,
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
