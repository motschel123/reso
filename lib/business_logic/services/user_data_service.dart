import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:reso/consts/firestore.dart';
import 'package:reso/model/user_profile.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class UserDataService {
  static FutureOr<UserProfile> getUserProfile(String uid) {
    final User currentUser = FirebaseAuth.instance.currentUser!;
    if (uid == currentUser.uid) {
      return UserProfile(
          displayName: currentUser.displayName!,
          imageUrl: currentUser.photoURL,
          uid: currentUser.uid);
    }

    return _firestore
        .collection(USERS_COLLECTION)
        .doc(uid)
        .get()
        .then((docSnap) {
      return UserProfile.fromDoc(docSnap);
    });
  }
}
