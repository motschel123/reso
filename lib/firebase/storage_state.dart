import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:reso/model/offert.dart';

/// Helper class for adding and reading offers to and from Firebase
class StorageState extends ChangeNotifier {
  Future<void> addOffer(
    String title,
    String description,
    String price,
    void Function(FirebaseException e) errorCallback,
    OfferType type, {
    File? image,
    String? location,
    DateTime? dateTime,
  }) async {
    final CollectionReference<Map<String, dynamic>> offers =
        FirebaseFirestore.instance.collection('offers');

    final FirebaseStorage storage = FirebaseStorage.instance;

    try {
      String? imageRef;
      if (image != null) {
        print('uploading image');
        imageRef =
            '${FirebaseAuth.instance.currentUser!.uid}/${image.hashCode}';

        await storage.ref(imageRef).putFile(image);
      }

      await offers.add(<String, dynamic>{
        'title': title,
        'description': description,
        'price': price,
        'type': type.toString(),
        'location': location,
        'date': dateTime,
        'userId': FirebaseAuth.instance.currentUser!.uid,
        'image': imageRef,
      });
    } on FirebaseException catch (e) {
      errorCallback(e);
    } catch (e) {
      print('FireStore error: ${e.toString()}');
    }
  }
}