import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reso/business_logic/providers/feed_manager.dart';
import 'package:reso/business_logic/providers/search_manager.dart';
import 'package:reso/consts/firestore.dart';
import 'package:reso/consts/theme.dart';
import 'package:reso/model/offer.dart';
import 'package:reso/ui/screens/offer_detail.dart';
import 'package:reso/ui/widgets/offer_card.dart';
import 'package:reso/ui/widgets/styled_form_elements.dart';

class SearchOffers extends StatefulWidget {
  const SearchOffers({Key? key}) : super(key: key);

  @override
  _SearchOffersState createState() => _SearchOffersState();
}

class _SearchOffersState extends State<SearchOffers> {
  final TextEditingController _searchTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SafeArea(
      child: Consumer<SearchManager>(
          builder: (BuildContext context, SearchManager searchManager, _) {
        return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: StyledTextFormField(
                          hintText: 'Angebot suchen',
                          controller: _searchTextController),
                    ),
                    const SizedBox(width: 8.0),
                    IconButton(
                      onPressed: () {
                        searchManager.searchOffers(_searchTextController.text);
                      },
                      icon: const Icon(Icons.category),
                    )
                  ],
                ),
              ),
              const Divider(height: 0),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  itemCount: searchManager.offers.length,
                  separatorBuilder: (BuildContext context, int index) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Divider(),
                    );
                  },
                  itemBuilder: (BuildContext context, int index) {
                    final Offer offer = searchManager.offers[index];

                    return OfferCard(
                      offer: offer,
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
            ]);
      }),
    ));
  }
}
