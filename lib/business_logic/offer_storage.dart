import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:reso/consts/firestore.dart';
import 'package:reso/model/offer.dart';

class OfferStorage {
  static Future<void> storeOffer(
    String title,
    String description,
    String price,
    OfferType type, {
    required void Function() successCallback,
    required void Function(FirebaseException e) errorCallback,
    File? image,
    String? location,
    DateTime? time,
  }) async {
    final CollectionReference<Map<String, dynamic>> offers =
        FirebaseFirestore.instance.collection(OFFERS_COLLECTION);

    final FirebaseStorage storage = FirebaseStorage.instance;

    try {
      final String imageRef = await _compressAndUploadImage(image!, storage);
      final String imageUrl =
          await FirebaseStorage.instance.ref(imageRef).getDownloadURL();

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

      await offers.add(newOffer.toMap());
      successCallback();
    } on FirebaseException catch (e) {
      errorCallback(e);
    }
  }

  static Future<void> updateOffer(
    Offer oldOffer,
    String title,
    String description,
    String price,
    OfferType type, {
    required void Function() successCallback,
    required void Function(FirebaseException e) errorCallback,
    File? image,
    String? location,
    DateTime? time,
  }) async {
    final CollectionReference<Map<String, dynamic>> offers =
        FirebaseFirestore.instance.collection(OFFERS_COLLECTION);

    try {
      String? imageRef, imageUrl;
      if (image != null) {
        final FirebaseStorage storage = FirebaseStorage.instance;
        // Delete old image in FireStorage if it exists
        if (oldOffer.imageRef != null) {
          await storage.ref(oldOffer.imageRef).delete();
        }

        imageRef = await _compressAndUploadImage(image, storage);
        imageUrl =
            await FirebaseStorage.instance.ref(imageRef).getDownloadURL();
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

      offers.doc(oldOffer.offerUid).update(updatedOffer.toMap());
      successCallback();
    } on FirebaseException catch (e) {
      errorCallback(e);
    }
  }

  static Future<void> deleteOffer(Offer offer,
      {required void Function() successCallback,
      required void Function(FirebaseException e) errorCallback}) async {
    final CollectionReference<Map<String, dynamic>> offers =
        FirebaseFirestore.instance.collection(OFFERS_COLLECTION);

    try {
      if (offer.imageRef != null) {
        final FirebaseStorage storage = FirebaseStorage.instance;

        await storage.ref(offer.imageRef).delete();
      }
      await offers.doc(offer.offerUid).delete();
      successCallback();
    } on FirebaseException catch (e) {
      errorCallback(e);
    }
  }
}

Future<String> _compressAndUploadImage(
    File image, FirebaseStorage storage) async {
  final File? compressedImage = await FlutterImageCompress.compressAndGetFile(
      image.absolute.path, '${image.absolute.path}_comp.jpg',
      quality: 5);

  if (compressedImage == null) {
    print('Image null');
    throw Exception('Unable to compress image');
  }

  final String imageRef =
      '${FirebaseAuth.instance.currentUser!.uid}/${compressedImage.hashCode}';

  await storage.ref(imageRef).putFile(compressedImage);

  return imageRef;
}
