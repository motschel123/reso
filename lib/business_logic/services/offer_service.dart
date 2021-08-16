import 'dart:async';
import 'dart:collection';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:reso/business_logic/services/storage_service.dart';
import 'package:reso/consts/firestore.dart';
import 'package:reso/model/offer.dart';

final CollectionReference<Map<String, dynamic>> _offersCollection =
    FirebaseFirestore.instance.collection(OFFERS_COLLECTION);

final HashMap<String, Future<Offer?>> _offers =
    HashMap<String, Future<Offer?>>();

Future<DocumentSnapshot<Map<String, dynamic>>> _getOfferDoc(String offerId) =>
    FirebaseFirestore.instance.collection(OFFERS_COLLECTION).doc(offerId).get();

Offer? mapOfferDoc(DocumentSnapshot<Map<String, dynamic>> docSnap) =>
    (docSnap.exists && docSnap.data() != null)
        ? Offer.fromMap(docSnap.data()!, docSnap.id)
        : null;

Stream<QuerySnapshot<Map<String, dynamic>>> get getUserOffers =>
    FirebaseFirestore.instance
        .collection(OFFERS_COLLECTION)
        .where(OFFER_AUTHOR_UID,
            isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .snapshots();

Future<Offer?> getOffer(final String offerId) => _offers.putIfAbsent(
    offerId, () => _getOfferDoc(offerId).then<Offer?>(mapOfferDoc));

Future<void> createOffer(
  String title,
  String description,
  String price,
  OfferType type, {
  DateTime? dateEvent,
  File? image,
  String? location,
  void Function()? successCallback,
  void Function(FirebaseException e)? errorCallback,
}) async {
  try {
    String? imageUrl, imageRef;
    if (image != null) {
      imageRef = await StorageService.uploadImage(image);
      imageUrl = await StorageService.getImageUrl(imageRef);
    }

    final Map<String, dynamic> offerData = Offer(
      title: title,
      description: description,
      price: price,
      type: type,
      authorUid: FirebaseAuth.instance.currentUser!.uid,
      dateCreated: DateTime.now(),
      dateEvent: dateEvent,
      location: location,
      imageRef: imageRef,
    ).toMap();

    await _offersCollection.add(offerData);
    successCallback?.call();
  } on FirebaseException catch (e) {
    errorCallback?.call(e);
  }
}

Future<void> updateOffer(
  Offer oldOffer,
  String title,
  String description,
  String price,
  OfferType type, {
  File? image,
  String? location,
  DateTime? dateEvent,
  void Function()? successCallback,
  void Function(FirebaseException e)? errorCallback,
}) async {
  String? imageUrl, imageRef;

  if (oldOffer.offerId == null) {
    print('Can update offer that is not created!');
    return;
  }

  try {
    if (image != null) {
      imageRef = await StorageService.uploadImage(image);
      imageUrl = await StorageService.getImageUrl(imageRef);

      // Delete old image in FireStorage if it exists
      if (oldOffer.imageRef != null) {
        await StorageService.deleteImage(imageRef);
      }
    }

    final Map<String, dynamic> offerData = Offer(
      title: title,
      description: description,
      price: price,
      type: type,
      authorUid: FirebaseAuth.instance.currentUser!.uid,
      dateCreated: oldOffer.dateCreated,
      dateEvent: dateEvent,
      location: location,
      imageRef: imageRef ?? oldOffer.imageRef,
    ).toMap();

    offerData.update(OFFER_DATE_CREATED,
        (dynamic old) => old ?? DateTime.now().toIso8601String());

    await _offersCollection.doc(oldOffer.offerId).update(offerData);
    successCallback?.call();
  } on FirebaseException catch (e) {
    errorCallback?.call(e);
  }
}

Future<void> deleteOffer(Offer offer,
    {void Function()? successCallback,
    void Function(FirebaseException e)? errorCallback}) async {
  final List<Future<dynamic>> futures = <Future<dynamic>>[];

  try {
    if (offer.imageRef != null) {
      futures.add(StorageService.deleteImage(offer.imageRef!));
    }
    futures.add(_offersCollection.doc(offer.offerId).delete());
    await Future.wait<dynamic>(futures);
    successCallback?.call();
  } on FirebaseException catch (e) {
    errorCallback?.call(e);
  }
}
