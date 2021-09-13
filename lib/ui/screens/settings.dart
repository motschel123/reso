import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reso/business_logic/providers/auth_manager.dart';
import 'package:reso/ui/screens/main/main_layout.dart';

class Settings extends StatelessWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: MainLayout.appBar(context, 'Settings'),
        body: Column(
          children: <Widget>[
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Du: ${FirebaseAuth.instance.currentUser!.displayName}',
                      style: Theme.of(context).textTheme.headline2,
                    ))),
            TextButton(
                onPressed: () {
                  Provider.of<AuthManager>(context, listen: false).signOut();
                },
                child: const Text('Sign Out')),
          ],
        ));
  }
}
