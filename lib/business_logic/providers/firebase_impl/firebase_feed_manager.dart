import 'dart:async';
import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:reso/business_logic/providers/feed_manager.dart';
import 'package:reso/consts/firestore.dart';
import 'package:reso/model/offer.dart';

class FirebaseFeedManager extends FeedManager {
  final List<Offer> _offers = <Offer>[];
  @override
  List<Offer> get offers => _offers;

  final Query<Map<String, dynamic>> _baseQuery =
      FirebaseFirestore.instance.collection(OFFERS_COLLECTION).limit(20);

  /// Stores the current [User] in order to personalize feed
  late User _currentUser;

  /// Stores the last [DocumentSnapshot] to query for documents after this
  DocumentSnapshot<Map<String, dynamic>>? _lastDocSnap;

  /// saves the current state to prevent, double fetching
  bool _fetching = false;

  @override
  void initFeedForUser(User currentUser, {ErrorCallback? errorCallback}) {
    _fetching = true;
    _offers.clear();
    _currentUser = currentUser;
    _baseQuery
        .get()
        // ignore: always_specify_types
        .then<void>((qSnap) => _mapAndAddOffer(qSnap))
        .onError<FirebaseAuthException>(
            (FirebaseAuthException e, StackTrace stacktrace) {
      if (errorCallback != null) {
        errorCallback.call(e, stacktrace);
      }
      throw e;
    }).whenComplete(() => _completedFetching());
  }

  @override
  void loadMoreOffers(int amount, {ErrorCallback? errorCallback}) {
    if (_lastDocSnap == null || _currentUser == null)
      throw Exception('Use initFeedForUser before calling loadMoreOffers');
    if (!_fetching) {
      _fetching = true;
      _baseQuery
          //.startAfterDocument(_lastDocSnap!)
          .limit(amount)
          .get()
          // ignore: always_specify_types
          .then<void>((qSnap) => _mapAndAddOffer(qSnap))
          .onError<FirebaseAuthException>(
              (FirebaseAuthException e, StackTrace stacktrace) {
        if (errorCallback != null) {
          errorCallback.call(e, stacktrace);
        }
        throw e;
      }).whenComplete(() => _completedFetching());
    }
  }

  /// maps the data from [QuerySnapshot] to a [List] of [Offer]'s and
  /// sets [_lastDocSnap] to the last [DocumentSnapshot]
  void _mapAndAddOffer(QuerySnapshot<Map<String, dynamic>> qSnap) {
    final List<Offer> mappedOffers = <Offer>[];
    for (final QueryDocumentSnapshot<Map<String, dynamic>> doc in qSnap.docs) {
      if (doc.exists && doc.data() != null) {
        mappedOffers.add(Offer.fromMap(doc.data()));
      }
    }
    _lastDocSnap = qSnap.docs.last;
    offers.addAll(mappedOffers);
    return;
  }

  void _completedFetching() {
    _fetching = false;
    notifyListeners();
  }
}
