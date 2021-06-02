import 'package:flutter/material.dart';
import 'package:reso/consts/theme.dart';
import 'package:reso/ui/screens/offer_detail.dart';
import 'package:firebase_core/firebase_core.dart';

void main() {
  runApp(const _InitializeApp(child: MyApp()));
}

class _InitializeApp extends StatefulWidget {
  const _InitializeApp({
    Key? key,
    required this.child,
    this.onError = const Center(
      child: Text('Error'),
    ),
    this.onLoading = const Center(
      child: CircularProgressIndicator(),
    ),
  }) : super(key: key);

  final Widget child;
  final Widget onError;
  final Widget onLoading;

  @override
  State<_InitializeApp> createState() => _InitializeAppState();
}

class _InitializeAppState extends State<_InitializeApp> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<FirebaseApp>(
      future: _initialization,
      builder: (BuildContext context, AsyncSnapshot<FirebaseApp> snapshot) {
        if (snapshot.hasError) {
          return widget.onError;
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return widget.child;
        }
        return widget.onLoading;
      },
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: lightTheme,
      home: const OfferDetail(
        offerTitle: '3D-Druck',
        offerPrice: 'ab 3,00€',
        offerDescription:
            'FDM Druck mit verschiedenen Farben\nPLA und TPU, Preis je nach Objekt',
        offerAuthor: 'Luca Beetz',
        profileImage: 'https://thispersondoesnotexist.com/image',
        offerImage:
            'https://www.twopeasandtheirpod.com/wp-content/uploads/2021/03/Veggie-Pizza-8-500x375.jpg',
        offerColor: Colors.amber,
      ),
    );
  }
}
