import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:reso/business_logic/services/offer_service.dart';
import 'package:reso/model/offer.dart';

class ProfileManager extends ChangeNotifier {
  ProfileManager() {
    getUserOffers.map<List<Offer>>((QuerySnapshot<Map<String, dynamic>> qSnap) {
      final List<Offer> offers = <Offer>[];
      for (final QueryDocumentSnapshot<Map<String, dynamic>> doc
          in qSnap.docs) {
        if (doc.exists && doc.data() != null) {
          offers.add(Offer.fromMap(doc.data(), doc.id));
        }
      }
      return offers;
    }).listen((List<Offer> offers) {
      _offers = offers;
      notifyListeners();
    });
  }

  List<Offer> _offers = <Offer>[];
  List<Offer> get offers => _offers;
}
