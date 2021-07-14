import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:reso/business_logic/services/storage_service.dart';
import 'package:reso/consts/firestore.dart';
import 'package:reso/model/offer.dart';

final CollectionReference<Map<String, dynamic>> _offersCollection =
    FirebaseFirestore.instance.collection(OFFERS_COLLECTION);

class OfferService {
  static Future<Offer?> getOffer(final String offerId) async {
    DocumentSnapshot<Map<String, dynamic>> docSnap = await FirebaseFirestore
        .instance
        .collection(OFFERS_COLLECTION)
        .doc(offerId)
        .get();
    if (docSnap.exists && docSnap.data() != null) {
      return Offer.fromMap(docSnap.data()!, docSnap.id);
    }
    return null;
  }

  static Future<void> createOffer(
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
        imageUrl = await StorageService.getDownloadURL(imageRef);
      }

      final Map<String, dynamic> offerData = Offer(
        title: title,
        description: description,
        price: price,
        type: type,
        authorUid: FirebaseAuth.instance.currentUser!.uid,
        authorDisplayName: FirebaseAuth.instance.currentUser!.displayName ??
            'NO DISPLAYNAME IN USER',
        authorImageUrl: FirebaseAuth.instance.currentUser!.photoURL ??
            'https://i.pinimg.com/originals/b6/5c/d4/b65cd4b543da7bafc9b0878cce843416.jpg',
        dateCreated: DateTime.now(),
        dateEvent: dateEvent,
        location: location,
        imageRef: imageRef,
        imageUrl: imageUrl,
      ).toMap();

      await _offersCollection.add(offerData);
      successCallback?.call();
    } on FirebaseException catch (e) {
      errorCallback?.call(e);
    }
  }

  static Future<void> updateOffer(
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
        imageUrl = await StorageService.getDownloadURL(imageRef);

        // Delete old image in FireStorage if it exists
        if (oldOffer.imageRef != null) {
          await StorageService.deleteFile(imageRef);
        }
      }

      final Map<String, dynamic> offerData = Offer(
        title: title,
        description: description,
        price: price,
        type: type,
        authorUid: FirebaseAuth.instance.currentUser!.uid,
        authorDisplayName: FirebaseAuth.instance.currentUser!.displayName ??
            'NO DISPlAYNAME IN USER',
        authorImageUrl: FirebaseAuth.instance.currentUser!.photoURL ??
            'https://i.pinimg.com/originals/b6/5c/d4/b65cd4b543da7bafc9b0878cce843416.jpg',
        dateCreated: oldOffer.dateCreated,
        dateEvent: dateEvent,
        location: location,
        imageRef: imageRef ?? oldOffer.imageRef,
        imageUrl: imageUrl ?? oldOffer.imageUrl,
      ).toMap();

      offerData.update(OFFER_DATE_CREATED,
          (dynamic old) => old ?? DateTime.now().toIso8601String());

      await _offersCollection.doc(oldOffer.offerId).update(offerData);
      successCallback?.call();
    } on FirebaseException catch (e) {
      errorCallback?.call(e);
    }
  }

  static Future<void> deleteOffer(Offer offer,
      {void Function()? successCallback,
      void Function(FirebaseException e)? errorCallback}) async {
    final List<Future<dynamic>> futures = <Future<dynamic>>[];

    try {
      if (offer.imageRef != null) {
        futures.add(StorageService.deleteFile(offer.imageRef!));
      }
      futures.add(_offersCollection.doc(offer.offerId).delete());
      await Future.wait<dynamic>(futures);
      successCallback?.call();
    } on FirebaseException catch (e) {
      errorCallback?.call(e);
    }
  }
}
