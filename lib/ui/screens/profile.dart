import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reso/business_logic/auth_manager.dart';
import 'package:reso/ui/screens/create_offer.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
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
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Deine Angebote',
                    style: Theme.of(context).textTheme.headline1),
                TextButton(
                  onPressed: () {
                    Provider.of<AuthManager>(context, listen: false).signOut();
                  },
                  child: const Text('Sign out'),
                )
              ],
            ),
          ),
        ));
  }
}
