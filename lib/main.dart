import 'package:flutter/material.dart';
import 'package:reso/consts/theme.dart';
import 'package:reso/ui/screens/create_offer.dart';
import 'package:reso/ui/screens/navigation.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: lightTheme,
      home: NavigationContainer(),
      // home: const CreateOffer(),
      // home: const OfferDetail(
      //   offerTitle: '3D-Druck',
      //   offerPrice: 'ab 3,00€',
      //   offerDescription:
      //       'FDM Druck mit verschiedenen Farben\nPLA und TPU, Preis je nach Objekt',
      //   offerAuthor: 'Luca Beetz',
      //   profileImage: 'https://thispersondoesnotexist.com/image',
      //   offerImage:
      //       'https://www.twopeasandtheirpod.com/wp-content/uploads/2021/03/Veggie-Pizza-8-500x375.jpg',
      //   offerColor: Colors.amber,
      // ),
    );
  }
}
