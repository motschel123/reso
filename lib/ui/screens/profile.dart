import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reso/business_logic/auth_manager.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Text('Profil', style: Theme.of(context).textTheme.headline1),
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
