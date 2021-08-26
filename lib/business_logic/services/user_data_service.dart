import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:reso/business_logic/services/storage_service.dart';
import 'package:reso/consts/firestore.dart';
import 'package:reso/model/user_profile.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class UserDataService {
  static Future<UserProfile> getUserProfile(String uid) async {
    /*final User currentUser = FirebaseAuth.instance.currentUser!;
    if (uid == currentUser.uid) {
      // TODO: add picture upload to registration and add default link if no image is povided
      return UserProfile(
        displayName: currentUser.displayName!,
        imageRef: currentUser.photoURL!,
        uid: currentUser.uid,
      );
    }*/

    return _firestore.collection(USERS_COLLECTION).doc(uid).get().then(
        (DocumentSnapshot<Map<String, dynamic>> docSnap) =>
            UserProfile.fromDoc(docSnap));
  }

  static Future<bool> waitUserDocExists(String uid) async {
    return _firestore
        .collection(USERS_COLLECTION)
        .doc(uid)
        .snapshots()
        .any((DocumentSnapshot<Map<String, dynamic>> docSnap) => docSnap.exists)
        .onError<Object>((Object? error, StackTrace stackTrace) {
      throw FirebaseException(
          plugin: 'FirebaseAuth/FirebaseFunctions', message: error.toString());
    });
  }

  static Future<void> updateUserData(
      {String? newDisplayName, String? newImageRef}) async {
    // check user is signed in
    final User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      throw Exception('No user signed in to update data on');
    }
    if (newDisplayName == null && newImageRef == null) {
      return;
    }

    // data map for firestore update
    final Map<String, dynamic> updates = <String, dynamic>{};
    // future array to wait for all tasks to complete
    final List<Future<void>> futures = <Future<dynamic>>[];

    if (newDisplayName != null) {
      updates.addAll(<String, dynamic>{USER_DISPLAY_NAME: newDisplayName});
      futures.add(currentUser.updateDisplayName(newDisplayName));
    }

    if (newImageRef != null) {
      updates.addAll(<String, dynamic>{USER_IMAGE_REFERENCE: newImageRef});
      futures.add(StorageService.getImageUrl(newImageRef).then<Future<void>>(
        (String photoUrl) => currentUser.updatePhotoURL(photoUrl),
      ));
    }

    futures.add(
      FirebaseFirestore.instance
          .collection(USERS_COLLECTION)
          .doc(currentUser.uid)
          .update(updates),
    );

    return Future.wait(futures).then((_) => null);
  }
}
