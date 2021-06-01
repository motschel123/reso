import 'package:flutter/material.dart';
import 'package:reso/ui/widgets/offer_heading.dart';

class OfferDetail extends StatelessWidget {
  const OfferDetail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: SafeArea(
            child: OfferHeading(
      offerTitle: '3D-Druck',
      offerAuthor: 'Luca Beetz',
      profileImage: 'https://thispersondoesnotexist.com/image',
      offerColor: Colors.amber,
    )));
  }
}
