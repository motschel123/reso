import 'package:algolia/algolia.dart';
import 'package:flutter/material.dart';
import 'package:reso/business_logic/services/algolia_service.dart';
import 'package:reso/model/offer.dart';

class SearchManager with ChangeNotifier {
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
