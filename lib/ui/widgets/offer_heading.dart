import 'package:flutter/material.dart';
import 'package:reso/business_logic/services/user_data_service.dart';
import 'package:reso/model/offer.dart';
import 'package:reso/model/user_profile.dart';
import 'package:reso/ui/widgets/storage_image.dart';

class OfferHeading extends StatelessWidget {
  /// A small, row-like Card to display a profile picture and a header with a subtext
  ///
  /// The arguments [offerTitle], [offerAuthor] define the text to display and
  /// must not be null.
  ///
  /// The [profileImageRef] is the storage reference of the profile image of the author and
  /// must not be null.
  ///
  /// [offerColor] is the background color of the Container behind the profile image
  /// and must not be null.
  ///
  /// [onTap] is an optional callback
  const OfferHeading(
      {Key? key, required this.offer, required this.offerColor, this.onTap})
      : super(key: key);

  final Offer offer;
  final Color offerColor;

  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Stack(children: <Widget>[
              Container(
                height: 56.0,
                width: 40.0,
                color: offerColor,
              ),
              Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: FutureStorageCircleAvatar(
                      UserDataService.getUserProfile(offer.authorUid)
                          .then<String>(
                              (UserProfile value) => value.imageRef))),
            ]),
            const SizedBox(width: 8.0),
            Expanded(
                child: GestureDetector(
              onTap: onTap,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(offer.title,
                      style: Theme.of(context).textTheme.headline2),
                  Text('sample name pls implement',
                      style: Theme.of(context).textTheme.subtitle1)
                ],
              ),
            )),
          ],
        ),
        const SizedBox(height: 16.0),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Divider(height: 0),
        ),
      ],
    );
  }
}
