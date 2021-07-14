import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:reso/consts/firestore.dart';

class UserProfile {
  UserProfile({
    required this.uid,
    required this.displayName,
    required this.imageUrl,
  });

  final String uid;
  final String displayName;
  final String? imageUrl;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      USER_DISPLAY_NAME: displayName,
      USER_UID: uid,
      USER_IMAGE_URL: imageUrl,
    };
  }

  static UserProfile fromMap(Map<String, dynamic> dataMap) {
    return UserProfile(
      uid: dataMap[USER_UID] as String,
      displayName: dataMap[USER_DISPLAY_NAME] as String,
      imageUrl: dataMap[USER_IMAGE_URL] as String?,
    );
  }

  static UserProfile fromDoc(DocumentSnapshot<Map<String, dynamic>> docSnap) {
    if (!docSnap.exists) {
      throw Exception("User Document doesn't exist");
    }
    if (docSnap.data() == null || docSnap.data()!.isEmpty)
      throw Exception('User Document has no data: ${docSnap.id}');

    final Map<String, dynamic> dataMap = docSnap.data()!;
    dataMap.addAll(<String, dynamic>{USER_UID: docSnap.id});

    return UserProfile.fromMap(dataMap);
  }
}
