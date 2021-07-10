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
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text('Suchen', style: Theme.of(context).textTheme.headline1),
          ),
          const Divider(height: 0),
        ])));
  }
}
