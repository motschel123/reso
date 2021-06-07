import 'package:flutter/material.dart';

class OfferCard extends StatelessWidget {
  /// A Card-like widget to display information about an offer
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
  ///
  const OfferCard(
      {Key? key,
      required this.offerTitle,
      required this.offerPrice,
      required this.offerDescription,
      required this.offerAuthor,
      required this.profileImage,
      required this.offerColor,
      this.offerTime,
      this.offerLocation,
      this.offerImage,
      this.onTap})
      : super(key: key);

  final String offerTitle,
      offerPrice,
      offerDescription,
      offerAuthor,
      profileImage;

  final Color offerColor;

  final String? offerTime, offerLocation, offerImage;

  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: <Widget>[
          Container(
            height: 80.0,
            padding: const EdgeInsets.only(bottom: 8.0, right: 16.0),
            child: Row(
              children: <Widget>[
                Stack(children: <Widget>[
                  Container(
                    height: 56.0,
                    width: 40.0,
                    color: offerColor,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(profileImage),
                      backgroundColor: offerColor,
                      radius: 28.0,
                    ),
                  ),
                ]),
                const SizedBox(width: 8.0),
                Expanded(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            offerTitle,
                            style: Theme.of(context).textTheme.headline3,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(offerPrice,
                            style: Theme.of(context).textTheme.bodyText2,
                            maxLines: 1,
                            overflow: TextOverflow.fade),
                      ],
                    ),
                    Text(offerDescription,
                        style: Theme.of(context).textTheme.bodyText2,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              const Icon(Icons.person, size: 16.0),
                              const SizedBox(width: 4.0),
                              Text(offerAuthor,
                                  overflow: TextOverflow.fade,
                                  style: Theme.of(context).textTheme.bodyText1),
                            ],
                          ),
                          if (offerTime != null)
                            Row(
                              children: <Widget>[
                                const Icon(Icons.timer, size: 16.0),
                                const SizedBox(width: 4.0),
                                Text(offerTime ?? 'NULL',
                                    overflow: TextOverflow.fade,
                                    style:
                                        Theme.of(context).textTheme.bodyText1),
                              ],
                            ),
                          if (offerLocation != null)
                            Row(
                              children: <Widget>[
                                const Icon(Icons.place, size: 16.0),
                                const SizedBox(width: 4.0),
                                Text(offerLocation ?? 'NULL',
                                    overflow: TextOverflow.fade,
                                    style:
                                        Theme.of(context).textTheme.bodyText1),
                              ],
                            ),
                        ])
                  ],
                ))
              ],
            ),
          ),
          if (offerImage != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                margin: const EdgeInsets.only(bottom: 8.0),
                height: 120,
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(offerImage ?? 'NULL'),
                    )),
              ),
            ),
        ],
      ),
    );
  }

  static OfferCard sample() {
    return const OfferCard(
      offerTitle: '3D-Druck',
      offerPrice: 'ab 3,00€',
      offerDescription:
          'FDM Druck mit verschiedenen Farben\nPLA und TPU, Preis je nach Objekt',
      offerAuthor: 'Luca Beetz',
      profileImage: 'https://thispersondoesnotexist.com/image',
      offerImage:
          'https://www.twopeasandtheirpod.com/wp-content/uploads/2021/03/Veggie-Pizza-8-500x375.jpg',
      offerColor: Colors.amber,
    );
  }
}
