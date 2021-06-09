import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:reso/business_logic/services/user_data_service.dart';
import 'package:reso/consts/firestore.dart';
import 'package:reso/model/user_profile.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class ChatService {
  static Future<DocumentReference<Map<String, dynamic>>> newChat(
      final User currentUser, final String partnerUid) async {
    final int cmp = currentUser.uid.compareTo(partnerUid);
    String uid1;
    String uid2;
    Future<Map<String, dynamic>> user1Profile;
    Future<Map<String, dynamic>> user2Profile;
    if (cmp == 0) {
      throw Exception("Can't create chat with self.");
    }

    if (cmp < 0) {
      uid1 = currentUser.uid;
      uid2 = partnerUid;
    } else {
      uid1 = partnerUid;
      uid2 = currentUser.uid;
    }

    user1Profile = UserDataService.getUserProfile(uid1)
        .then((UserProfile user) => user.toMap());
    //.then<Map<String, dynamic>>((UserProfile uProfile) => uProfile.toMap());
    user2Profile = UserDataService.getUserProfile(uid2)
        .then((UserProfile user) => user.toMap());

    final Map<String, dynamic> wData1 = await user1Profile;
    final Map<String, dynamic> wData2 = await user2Profile;

    final Map<String, dynamic> data = <String, dynamic>{
      CHAT_UIDS: <String>[uid1, uid2],
      CHAT_PEERS: <String, Map<String, dynamic>>{uid1: wData1, uid2: wData2},
      CHAT_LATEST_MESSAGE_TEXT: '',
      CHAT_LATEST_DATE: FieldValue.serverTimestamp(),
      CHAT_DATE_CREATED: FieldValue.serverTimestamp(),
    };

    if (wData1 == null || wData1.isEmpty || wData2 == null || wData2.isEmpty) {
      throw Exception('Fetching UserProfiles went wrong');
    }
    return _firestore.collection(CHATS_COLLECTION).add(data);
  }
}
