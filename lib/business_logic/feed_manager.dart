import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:reso/consts/firestore.dart';
import 'package:reso/model/offer.dart';

class FeedManager extends ChangeNotifier {
  FeedManager() {
    FirebaseFirestore.instance
        .collection(OFFERS_COLLECTION)
        .snapshots()
        .map<List<Offer>>((QuerySnapshot<Map<String, dynamic>> qSnap) {
      final List<Offer> offers = <Offer>[];
      for (final QueryDocumentSnapshot<Map<String, dynamic>> doc
          in qSnap.docs) {
        if (doc.exists && doc.data() != null) {
          offers.add(Offer.fromMap(doc.data()));
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
