import 'package:firebase_image/firebase_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:reso/business_logic/services/user_data_service.dart';
import 'package:reso/model/offer.dart';
import 'package:reso/model/user_profile.dart';
import 'package:reso/ui/widgets/storage_image.dart';

class OfferCard extends StatelessWidget {
  // TODO(motschel123): rewrite doc
  /// A Card-like widget to display information about an offer
  ///
  /// The [offerTitle], [offerPrice], [offerDescription] and [offerAuthor] arguments
  /// are required and display general information about the offer.
  /// The [profileImageRef] is the network path to the profile image of the author and
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
      required this.offer,
      required this.offerColor,
      this.onTap,
      this.imageIcon,
      this.onIconTap})
      : super(key: key);

  final Offer offer;
  final Color offerColor;

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
                  Container(height: 56.0, width: 42.0, color: offerColor),
                  if (imageIcon != null)
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: CircleAvatar(
                        child:
                            IconButton(icon: imageIcon!, onPressed: onIconTap),
                        backgroundColor: offerColor,
                        radius: 28.0,
                      ),
                    )
                  else
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: FutureStorageCircleAvatar(
                        UserDataService.getUserProfile(offer.authorUid)
                            .then<String>(
                                (UserProfile value) => value.imageRef),
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
                            offer.title,
                            style: Theme.of(context).textTheme.headline3,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(offer.price,
                              style: Theme.of(context).textTheme.bodyText2,
                              textAlign: TextAlign.right,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis),
                        ),
                      ],
                    ),
                    Text(offer.description,
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
                              FutureBuilder<String>(
                                  future: UserDataService.getUserProfile(
                                          offer.authorUid)
                                      .then<String>((UserProfile value) =>
                                          value.displayName),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<String> snap) {
                                    if (snap.hasError) {
                                      print(snap.error);
                                    }
                                    return snap.connectionState ==
                                            ConnectionState.waiting
                                        ? Text('L??dt...',
                                            overflow: TextOverflow.fade,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1)
                                        : Text(snap.data.toString());
                                  }),
                            ],
                          ),
                          if (offer.dateEvent != null)
                            Row(
                              children: <Widget>[
                                const Icon(Icons.timer, size: 16.0),
                                const SizedBox(width: 4.0),
                                Text(
                                    DateFormat.MMMd()
                                        .format(offer.dateEvent!.toLocal()),
                                    overflow: TextOverflow.fade,
                                    style:
                                        Theme.of(context).textTheme.bodyText1),
                              ],
                            ),
                          if (offer.location != null)
                            Row(
                              children: <Widget>[
                                const Icon(Icons.place, size: 16.0),
                                const SizedBox(width: 4.0),
                                Text(offer.location ?? 'NULL',
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
          if (offer.imageRef != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                height: 120,
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: FirebaseImage(offer.imageRef!),
                    )),
              ),
            ),
        ],
      ),
    );
  }
}
