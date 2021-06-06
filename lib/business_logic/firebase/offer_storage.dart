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
    OfferType type,
    void Function(FirebaseException e) errorCallback, {
    File? image,
    String? location,
    DateTime? time,
  }) async {
    final CollectionReference<Map<String, dynamic>> offers =
        FirebaseFirestore.instance.collection(OFFERS_COLLECTION);

    final FirebaseStorage storage = FirebaseStorage.instance;

    try {
      String? imageRef;
      if (image != null) {
        final File? compressedImage =
            await FlutterImageCompress.compressAndGetFile(
                image.absolute.path, '${image.absolute.path}_comp.jpg',
                quality: 5);

        if (compressedImage == null) {
          print('Image null');
          throw Exception('Unable to compress image');
        }

        imageRef =
            '${FirebaseAuth.instance.currentUser!.uid}/${compressedImage.hashCode}';

        await storage.ref(imageRef).putFile(compressedImage);
        imageRef =
            await FirebaseStorage.instance.ref(imageRef).getDownloadURL();
      }

      final Offer newOffer = Offer(
        title: title,
        description: description,
        price: price,
        type: type,
        authorUid: FirebaseAuth.instance.currentUser!.uid,
        time: time,
        location: location,
        imageRef: imageRef,
      );

      await offers.add(newOffer.toMap());
    } on FirebaseException catch (e) {
      errorCallback(e);
    } catch (e) {
      print('Exception during offer upload: ${e.toString()}');
    }
  }
}
