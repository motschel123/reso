import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:reso/consts/firestore.dart';
import 'package:reso/model/user_profile.dart';

class Chat {
  const Chat({
    required this.chatId,
    required this.relatedOffer,
    required this.latestDate,
    required this.latestMessageText,
    required this.dateCreated,
    required this.peers,
  });

  final String chatId;
  final DateTime latestDate;
  final String latestMessageText;
  final DateTime dateCreated;
  final DocumentReference<Map<String, dynamic>> relatedOffer;
  final Map<String, UserProfile> peers;

  static Chat fromChatDoc(DocumentSnapshot<Map<String, dynamic>> docSnap) {
    DateTime latestDate;
    String latestMessageText;
    DateTime dateCreated;
    final CollectionReference<Map<String, dynamic>> messages;
    DocumentReference<Map<String, dynamic>> relatedOffer;
    final Map<String, UserProfile> peers = _getPeersData(docSnap);

    // get Data from chat document
    latestDate = (docSnap.data()?[CHAT_LATEST_DATE] as Timestamp).toDate();
    latestMessageText = docSnap.data()?[CHAT_LATEST_MESSAGE_TEXT] as String;
    dateCreated = (docSnap.data()?[CHAT_DATE_CREATED] as Timestamp).toDate();
    relatedOffer = docSnap.data()?[CHAT_RELATED_OFFER]
        as DocumentReference<Map<String, dynamic>>;

    return Chat(
      chatId: docSnap.id,
      relatedOffer: relatedOffer,
      latestDate: latestDate,
      latestMessageText: latestMessageText,
      dateCreated: dateCreated,
      peers: peers,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      CHAT_RELATED_OFFER: relatedOffer,
      CHAT_LATEST_DATE: latestDate,
      CHAT_LATEST_MESSAGE_TEXT: latestMessageText,
      CHAT_DATE_CREATED: dateCreated,
      CHAT_PEER_DATA: peers.map<String, Map<String, dynamic>>(
          (String key, UserProfile peerData) =>
              MapEntry<String, Map<String, dynamic>>(key, peerData.toMap())),
    };
  }

  static Map<String, UserProfile> _getPeersData(
      DocumentSnapshot<Map<String, dynamic>> docSnap) {
    // Map to fill and return
    final Map<String, UserProfile> peers = <String, UserProfile>{};
    // Data contained in documentSnapshot
    final Map<String, dynamic> peerData =
        docSnap.data()?[CHAT_PEER_DATA] as Map<String, dynamic>;

    // Create a UserProfile for each uid
    // and put it into peers map
    for (final String uid in peerData.keys) {
      final String displayName = peerData[USER_DISPLAY_NAME] as String;
      final String imageUrl = peerData[USER_IMAGE_URL] as String;

      peers.putIfAbsent(
        uid,
        () => UserProfile(
          uid: uid,
          displayName: displayName,
          imageUrl: imageUrl,
        ),
      );
    }

    return peers;
  }
}
