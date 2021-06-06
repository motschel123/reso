import 'package:flutter/material.dart';

class SearchOffers extends StatefulWidget {
  const SearchOffers({Key? key}) : super(key: key);

  @override
  _SearchOffersState createState() => _SearchOffersState();
}

class _SearchOffersState extends State<SearchOffers> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Text('Suchen', style: Theme.of(context).textTheme.headline1),
          ],
        ),
      ),
    ));
  }
}
