import 'package:flutter/material.dart';
import 'package:reso/ui/widgets/offer_card.dart';

class LiveFeed extends StatelessWidget {
  const LiveFeed({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: SafeArea(
            child: OfferCard(
      offerTitle: '3D-Druck',
      offerPrice: 'ab 3,00€',
      offerDescription:
          'FDM Druck mit verschiedenen Farben\nPLA und TPU, Preis je nach Objekt',
      offerAuthor: 'Luca Beetz',
      profileImage: 'https://thispersondoesnotexist.com/image',
      offerImage:
          'https://www.twopeasandtheirpod.com/wp-content/uploads/2021/03/Veggie-Pizza-8-500x375.jpg',
      offerColor: Colors.amber,
    )));
  }
}
