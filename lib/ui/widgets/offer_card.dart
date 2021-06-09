import 'package:firebase_image/firebase_image.dart';
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
      required this.offerColor,
      this.profileImage,
      this.offerTime,
      this.offerLocation,
      this.offerImage,
      this.onTap,
      this.imageIcon,
      this.onIconTap})
      : super(key: key);

  final String offerTitle, offerPrice, offerDescription, offerAuthor;

  final Color offerColor;

  final String? offerTime, offerLocation, offerImage, profileImage;

  final void Function()? onTap;

  final Icon? imageIcon;
  final void Function()? onIconTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: <Widget>[
          Container(
            height: 90.0,
            padding: const EdgeInsets.only(bottom: 0.0, right: 16.0),
            child: Row(
              children: <Widget>[
                Stack(children: <Widget>[
                  Container(
                    height: 56.0,
                    width: 42.0,
                    color: offerColor,
                  ),
                  if (profileImage != null)
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(profileImage!),
                        backgroundColor: offerColor,
                        radius: 28.0,
                      ),
                    ),
                  if (profileImage == null)
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: CircleAvatar(
                        child:
                            IconButton(icon: imageIcon!, onPressed: onIconTap),
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
                          flex: 2,
                          child: Text(
                            offerTitle,
                            style: Theme.of(context).textTheme.headline3,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(offerPrice,
                              style: Theme.of(context).textTheme.bodyText2,
                              textAlign: TextAlign.right,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis),
                        ),
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
                      image: FirebaseImage(offerImage!),
                    )),
              ),
            ),
        ],
      ),
    );
  }
}
