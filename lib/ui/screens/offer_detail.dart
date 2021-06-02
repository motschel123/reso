import 'package:flutter/material.dart';
import 'package:reso/ui/widgets/offer_heading.dart';

/// A screen for displaying all information about an offer
///
/// The [offerTitle], [offerPrice], [offerDescription] and [offerAuthor] arguments
/// are required and display general information about the offer.
/// The [profileImage] is the network path to the profile image of the author and
/// must not be null.
///
/// [offerColor] is the background color of the Container behind the profile image
/// and must not be null.
///
/// The [offerTime], [offerLocation] arguments are optional and displayed with
/// matching icons beneath the description.
///
/// Using [offerImage], an addition image can be provided which is displayed
/// in large beneath the rest.
class OfferDetail extends StatelessWidget {
  const OfferDetail(
      {Key? key,
      required this.offerTitle,
      required this.offerPrice,
      required this.offerDescription,
      required this.offerAuthor,
      required this.profileImage,
      required this.offerColor,
      this.offerTime,
      this.offerLocation,
      this.offerImage})
      : super(key: key);

  final String offerTitle,
      offerPrice,
      offerDescription,
      offerAuthor,
      profileImage;

  final Color offerColor;

  final String? offerTime, offerLocation, offerImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Column(
      children: <Widget>[
        OfferHeading(
          offerTitle: offerTitle,
          offerAuthor: offerAuthor,
          profileImage: profileImage,
          offerColor: offerColor,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                height: 120,
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(offerImage ?? 'NULL'),
                    )),
              ),
              const SizedBox(height: 16.0),
              Text(offerDescription,
                  style: Theme.of(context).textTheme.bodyText2),
              const SizedBox(height: 16.0),
              RichText(
                  text: TextSpan(children: <TextSpan>[
                TextSpan(
                    text: 'Preis: ',
                    style: Theme.of(context).textTheme.bodyText1),
                TextSpan(
                    text: offerPrice,
                    style: Theme.of(context).textTheme.bodyText2),
              ])),
              const SizedBox(height: 16.0),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        const Icon(Icons.person, size: 16.0),
                        const SizedBox(width: 4.0),
                        Text(offerAuthor,
                            style: Theme.of(context).textTheme.bodyText1),
                      ],
                    ),
                    if (offerTime != null)
                      Row(
                        children: <Widget>[
                          const Icon(Icons.person, size: 16.0),
                          const SizedBox(width: 4.0),
                          Text(offerTime ?? 'NULL',
                              style: Theme.of(context).textTheme.bodyText1),
                        ],
                      ),
                    if (offerLocation != null)
                      Row(
                        children: <Widget>[
                          const Icon(Icons.place, size: 16.0),
                          const SizedBox(width: 4.0),
                          Text(offerLocation ?? 'NULL',
                              style: Theme.of(context).textTheme.bodyText1),
                        ],
                      ),
                  ]),
              const SizedBox(height: 8.0),
              const Divider(),
              const SizedBox(height: 8.0),
              Container(
                  height: 42.0,
                  decoration: BoxDecoration(
                    color: offerColor,
                    borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                  ),
                  child: Center(
                    child: Text(
                      '$offerAuthor anschreiben',
                      style: Theme.of(context).textTheme.button,
                    ),
                  )),
            ],
          ),
        ),
      ],
    )));
  }
}
