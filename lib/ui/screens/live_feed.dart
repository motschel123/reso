import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reso/business_logic/feed_manager.dart';
import 'package:reso/consts/theme.dart';
import 'package:reso/ui/widgets/offer_card.dart';

class LiveFeed extends StatelessWidget {
  const LiveFeed({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Consumer<FeedManager>(
            builder: (BuildContext context, FeedManager feedManager, _) =>
                ListView.separated(
                  itemCount: feedManager.offers.length,
                  separatorBuilder: (BuildContext context, int index) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Divider(),
                    );
                  },
                  itemBuilder: (BuildContext context, int index) {
                    return OfferCard(
                      offerTitle: feedManager.offers[index].title,
                      offerPrice: feedManager.offers[index].price,
                      offerDescription: feedManager.offers[index].description,
                      offerAuthor: feedManager.offers[index].authorUid,
                      profileImage: 'https://thispersondoesnotexist.com/image',
                      offerColor:
                          offerTypeToColor[feedManager.offers[index].type]!,
                    );
                  },
                )),
      ),
    );
  }
}
