import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:reso/business_logic/services/storage_service.dart';
import 'package:reso/consts/firestore.dart';
import 'package:reso/model/offer.dart';

final CollectionReference<Map<String, dynamic>> _offersCollection =
    FirebaseFirestore.instance.collection(OFFERS_COLLECTION);

class OfferService {
  static Future<void> createOffer(
    String title,
    String description,
    String price,
    OfferType type, {
    File? image,
    String? location,
    DateTime? time,
    void Function()? successCallback,
    void Function(FirebaseException e)? errorCallback,
  }) async {
    try {
      String? imageUrl, imageRef;
      if (image != null) {
        imageRef = await StorageService.uploadImage(image);
        imageUrl = await StorageService.getDownloadURL(imageRef);
      }

      final Offer newOffer = Offer(
        title: title,
        description: description,
        price: price,
        type: type,
        authorUid: FirebaseAuth.instance.currentUser!.uid,
        dateCreated: time,
        location: location,
        imageRef: imageRef,
        imageUrl: imageUrl,
      );

      await _offersCollection.add(newOffer.toMap());
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
    DateTime? time,
    void Function()? successCallback,
    void Function(FirebaseException e)? errorCallback,
  }) async {
    String? imageUrl, imageRef;

    try {
      if (image != null) {
        imageRef = await StorageService.uploadImage(image);
        imageUrl = await StorageService.getDownloadURL(imageRef);

        // Delete old image in FireStorage if it exists
        if (oldOffer.imageRef != null) {
          await StorageService.deleteFile(imageRef);
        }
      }

      final Offer updatedOffer = Offer(
        title: title,
        description: description,
        price: price,
        type: type,
        authorUid: FirebaseAuth.instance.currentUser!.uid,
        dateCreated: time,
        location: location,
        imageRef: imageRef ?? oldOffer.imageRef,
        imageUrl: imageUrl ?? oldOffer.imageUrl,
      );

      await _offersCollection
          .doc(oldOffer.offerId)
          .update(updatedOffer.toMap());
      successCallback?.call();
    } on FirebaseException catch (e) {
      errorCallback?.call(e);
    }
  }

  static Future<void> deleteOffer(Offer offer,
      {void Function()? successCallback,
      void Function(FirebaseException e)? errorCallback}) async {
    List<Future<dynamic>> futures = <Future<dynamic>>[];

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
