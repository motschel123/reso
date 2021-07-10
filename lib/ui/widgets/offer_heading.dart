import 'package:flutter/material.dart';

class OfferHeading extends StatelessWidget {
  /// A small, row-like Card to display a profile picture and a header with a subtext
  ///
  /// The arguments [offerTitle], [offerAuthor] define the text to display and
  /// must not be null.
  ///
  /// The [profileImage] is the network path to the profile image of the author and
  /// must not be null.
  ///
  /// [offerColor] is the background color of the Container behind the profile image
  /// and must not be null.
  ///
  /// [onTap] is an optional callback
  const OfferHeading(
      {Key? key,
      required this.offerTitle,
      required this.offerAuthor,
      required this.profileImage,
      required this.offerColor,
      this.onTap})
      : super(key: key);

  final String offerTitle, offerAuthor, profileImage;

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
                child: CircleAvatar(
                  backgroundImage: NetworkImage(profileImage),
                  backgroundColor: offerColor,
                  radius: 28.0,
                ),
              ),
            ]),
            const SizedBox(width: 8.0),
            Expanded(
                child: GestureDetector(
              onTap: onTap,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(offerTitle,
                      style: Theme.of(context).textTheme.headline2),
                  Text(offerAuthor,
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
