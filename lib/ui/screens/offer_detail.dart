import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:reso/business_logic/services/chat_service.dart';
import 'package:firebase_image/firebase_image.dart';
import 'package:intl/intl.dart';
import 'package:reso/business_logic/services/user_data_service.dart';
import 'package:reso/consts/theme.dart';
import 'package:reso/model/chat.dart';
import 'package:reso/model/offer.dart';
import 'package:reso/model/user_profile.dart';
import 'package:reso/ui/widgets/offer_heading.dart';

/// A screen for displaying all information about an offer
///
/// The [offer] parameter contains the required information.
class OfferDetail extends StatelessWidget {
  const OfferDetail({Key? key, required this.offer}) : super(key: key);

  final Offer offer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: SingleChildScrollView(
      child: Column(
        children: <Widget>[
          OfferHeading(
            offer: offer,
            offerColor: offerTypeToColor[offer.type]!,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                if (offer.imageRef != null)
                  Container(
                    height: 240,
                    margin: const EdgeInsets.only(top: 8.0),
                    decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8.0)),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: FirebaseImage(offer.imageRef!),
                        )),
                  ),
                const SizedBox(height: 16.0),
                Text(offer.description,
                    style: Theme.of(context).textTheme.bodyText2),
                const SizedBox(height: 16.0),
                RichText(
                    text: TextSpan(children: <TextSpan>[
                  TextSpan(
                      text: 'Preis: ',
                      style: Theme.of(context).textTheme.bodyText1),
                  TextSpan(
                      text: offer.price,
                      style: Theme.of(context).textTheme.bodyText2),
                ])),
                const SizedBox(height: 16.0),
                Wrap(
                    direction: Axis.horizontal,
                    runSpacing: 8.0,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          const Icon(Icons.person, size: 16.0),
                          const SizedBox(width: 4.0),
                          FutureBuilder<String>(
                              future: UserDataService.getUserProfile(
                                      offer.authorUid)
                                  .then(
                                      (UserProfile value) => value.displayName),
                              builder: (BuildContext context,
                                      AsyncSnapshot<String> snap) =>
                                  Text(snap.hasData ? snap.data! : 'L??dt...',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1)),
                        ],
                      ),
                      if (offer.dateCreated != null)
                        Row(
                          children: <Widget>[
                            const Icon(Icons.timer, size: 16.0),
                            const SizedBox(width: 4.0),
                            Text(DateFormat('kk:mm').format(offer.dateCreated!),
                                style: Theme.of(context).textTheme.bodyText1),
                          ],
                        ),
                      if (offer.location != null)
                        Row(
                          children: <Widget>[
                            const Icon(Icons.place, size: 16.0),
                            const SizedBox(width: 4.0),
                            Text(offer.location ?? 'NULL',
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
                      color: offerTypeToColor[offer.type],
                      borderRadius:
                          const BorderRadius.all(Radius.circular(8.0)),
                    ),
                    child: Center(
                      child: TextButton(
                        child: FutureBuilder<String>(
                            future: UserDataService.getUserProfile(
                                    offer.authorUid)
                                .then((UserProfile value) => value.displayName),
                            builder: (BuildContext context,
                                AsyncSnapshot<String> snap) {
                              return Text(
                                (snap.hasData ? snap.data! : 'L??dt...') +
                                    ' anschreiben',
                                style: Theme.of(context).textTheme.button,
                              );
                            }),
                        onPressed: () async {
                          final Chat? chat = await ChatService.getChat(
                            FirebaseAuth.instance.currentUser!,
                            offer,
                          );
                          ChatService.openChat(
                              context: context, chat: chat, offer: offer);
                        },
                      ),
                    )),
              ],
            ),
          ),
        ],
      ),
    )));
  }
}
