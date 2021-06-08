import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reso/business_logic/providers/feed_manager.dart';
import 'package:reso/consts/theme.dart';
import 'package:reso/model/offer.dart';
import 'package:reso/ui/screens/offer_detail.dart';
import 'package:reso/ui/widgets/offer_card.dart';

class LiveFeed extends StatelessWidget {
  const LiveFeed({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Consumer<FirebaseFeedManager>(
            builder: (BuildContext context, FirebaseFeedManager feedManager,
                    _) =>
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0, bottom: 8.0),
                      child: Text('Dein Feed',
                          style: Theme.of(context).textTheme.headline1),
                    ),
                    const Divider(height: 0),
                    Expanded(
                      child: ListView.separated(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        itemCount: feedManager.offers.length,
                        separatorBuilder: (BuildContext context, int index) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            child: Divider(),
                          );
                        },
                        itemBuilder: (BuildContext context, int index) {
                          final Offer offer = feedManager.offers[index];

                          return OfferCard(
                            offerTitle: offer.title,
                            offerPrice: offer.price,
                            offerDescription: offer.description,
                            offerAuthor: offer.authorUid,
                            profileImage:
                                'https://thispersondoesnotexist.com/image',
                            offerColor: offerTypeToColor[offer.type]!,
                            offerImage: offer.imageUrl,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute<OfferDetail>(
                                    builder: (BuildContext context) =>
                                        OfferDetail(offer: offer)),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                )),
      ),
    );
  }
}
