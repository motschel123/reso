import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:reso/consts/firestore.dart';
import 'package:reso/model/offer.dart';

class SearchManager with ChangeNotifier {
  SearchManager({FirebaseFirestore? firebaseFirestore, User? user})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance,
        _currentUser = user ?? FirebaseAuth.instance.currentUser! {
    _initFeed();
  }

  /// Provide mock Firestore instance for testing
  // FeedManager({FirebaseFirestore firebaseFirestore})
  //     : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance,
  //     _currentUser = FirebaseAuth.instance.currentUser!;
  //     {

  //   _initFeed();
  // }

  late final FirebaseFirestore _firebaseFirestore;

  static const int _defaultAmount = 20;

  List<Offer> get offers => _offers;
  late final List<Offer> _offers;

  // ignore: unused_field
  final User _currentUser;

  late final Query<Map<String, dynamic>> _baseQuery =
      _firebaseFirestore.collection(OFFERS_COLLECTION).limit(_defaultAmount);

  /// Stores the last [DocumentSnapshot] to query for documents after this
  DocumentSnapshot<Map<String, dynamic>>? _lastDocSnap;

  /// saves the current state to prevent, double fetching
  bool _fetching = false;

  FutureOr<void> _initFeed() {
    _fetching = true;
    _offers = <Offer>[];
    return _baseQuery
        .get()
        // ignore: always_specify_types
        .then<void>((qSnap) => _mapAndAddOffer(qSnap))
        .whenComplete(() => _completedFetching());
  }

  FutureOr<void> loadMoreOffers(int? amount) {
    if (_offers == null) {
      throw Exception('Feed not initialized!');
    }
    if (_lastDocSnap == null) {
      throw Exception('No previous offers found');
    }
    if (_fetching) {
      throw AlreadyFetchingException();
    }
    _fetching = true;
    return _baseQuery
        .startAfterDocument(_lastDocSnap!)
        .limit(amount ?? _defaultAmount)
        .get()
        // ignore: always_specify_types
        .then<void>((qSnap) => _mapAndAddOffer(qSnap))
        .whenComplete(() => _completedFetching());
  }

  /// maps the data from [QuerySnapshot] to a [List] of [Offer]'s and
  /// sets [_lastDocSnap] to the last [DocumentSnapshot]
  void _mapAndAddOffer(QuerySnapshot<Map<String, dynamic>> qSnap) {
    final List<Offer> mappedOffers = <Offer>[];
    for (final QueryDocumentSnapshot<Map<String, dynamic>> doc in qSnap.docs) {
      if (doc.exists && doc.data() != null) {
        try {
          final Offer newOffer = Offer.fromMap(doc.data(), doc.id);
          mappedOffers.add(newOffer);
        } on Exception catch (e) {
          print(e);
          print('Related doc data: ' + doc.data().toString());
        } on Error catch (e) {
          print(e);
          print('Related doc data: ' + doc.data().toString());
        }
      }
    }

    _offers.addAll(mappedOffers);
    return;
  }

  void _completedFetching() {
    _fetching = false;
    notifyListeners();
  }
}

class AlreadyFetchingException with Exception {
  AlreadyFetchingException([String? message])
      : message = message ?? 'Already fetching';
  final String message;
}
