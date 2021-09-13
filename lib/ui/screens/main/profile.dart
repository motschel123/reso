import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reso/business_logic/providers/auth_manager.dart';
import 'package:reso/business_logic/providers/profile_manager.dart';
import 'package:reso/consts/theme.dart';
import 'package:reso/ui/screens/create_offer.dart';
import 'package:reso/model/offer.dart';
import 'package:reso/ui/screens/offer_detail.dart';
import 'package:reso/ui/widgets/offer_card.dart';

class Profile extends StatelessWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Consumer<ProfileManager>(
          builder: (BuildContext context, ProfileManager profileManager, _) =>
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Divider(height: 0),
                  Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      itemCount: profileManager.offers.length,
                      separatorBuilder: (BuildContext context, int index) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          child: Divider(),
                        );
                      },
                      itemBuilder: (BuildContext context, int index) {
                        final Offer offer = profileManager.offers[index];

                        return OfferCard(
                          offer: offer,
                          offerColor: offerTypeToColor[offer.type]!,
                          imageIcon:
                              const Icon(Icons.edit, color: Colors.white),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute<CreateOffer>(
                                  builder: (BuildContext context) =>
                                      OfferDetail(offer: offer)),
                            );
                          },
                          onIconTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute<CreateOffer>(
                                  builder: (BuildContext context) =>
                                      CreateOffer(editingOffer: offer)),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              )),
    );
  }
}
