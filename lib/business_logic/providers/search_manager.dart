import 'package:algolia/algolia.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:reso/business_logic/services/algolia_service.dart';
import 'package:reso/model/offer.dart';

class SearchManager with ChangeNotifier {
  SearchManager({FirebaseFirestore? firebaseFirestore, User? user})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance,
        _currentUser = user ?? FirebaseAuth.instance.currentUser! {}

  final FirebaseFirestore _firebaseFirestore;
  // ignore: unused_field
  final User _currentUser;
  late final Query<Map<String, dynamic>> _baseQuery;

  List<Offer> get offers => _offers;
  List<Offer> _offers = <Offer>[];

  /// saves the current state to prevent, double fetching
  bool _fetching = false;

  Future<void> searchOffers(String searchText) async {
    if (!_fetching) {
      _fetching = true;
      final List<Offer> foundOffers = <Offer>[];

      final AlgoliaQuerySnapshot snap = await AlgoliaService.algolia.instance
          .index('offers')
          .query(searchText)
          .getObjects();

      for (final AlgoliaObjectSnapshot element in snap.hits) {
        foundOffers.add(Offer.fromMap(element.data, element.index));
      }

      _offers = foundOffers;
      _fetching = false;
      notifyListeners();
    }
  }
}
