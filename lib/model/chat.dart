import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:reso/consts/firestore.dart';

import 'offer.dart';

class Chat {
  const Chat({
    required this.key,
    required this.offerId,
    required this.dateCreated,
    required this.peers,
    required this.databaseRef,
  });

  final String key;
  final DateTime dateCreated;
  final String offerId;
  final List<String> peers;
  final String databaseRef;

  static Chat fromMap(Map<String, dynamic> chatMap, String chatId) {
    DateTime dateCreated;
    String offerId;
    List<String> peers;
    String databaseRef;

    // get Data from chat document
    try {
      dateCreated = DateTime.parse(chatMap[CHAT_DATE_CREATED] as String);
    } catch (e) {
      throw FormatException("Couldn't parse dateCreated: $e");
    }

    try {
      offerId = chatMap[CHAT_OFFER_ID] as String;
    } catch (e) {
      throw FormatException("Couldn't parse offerId: $e");
    }

    try {
      peers =
          List.castFrom<dynamic, String>(chatMap[CHAT_PEERS] as List<dynamic>);
    } catch (e) {
      throw FormatException('List casting threw $e');
    }

    try {
      databaseRef = chatMap[CHAT_DATABASE_REF] as String;
    } catch (e) {
      throw FormatException("Couldn't parse databaseRef: $e");
    }

    return Chat(
      key: chatId,
      offerId: offerId,
      dateCreated: dateCreated,
      peers: peers,
      databaseRef: databaseRef,
    );
  }

  static Chat fromDatabase(DataSnapshot? snap) {
    if (snap == null) {
      throw const FormatException("chat data doesn't exist");
    }
    final Map<String, dynamic> data = snap.value as Map<String, dynamic>;

    return Chat(
        key: snap.key!,
        dateCreated: DateTime.parse(data[CHAT_DATE_CREATED] as String),
        offerId: data[CHAT_OFFER_ID] as String,
        peers: data[CHAT_PEERS] as List<String>,
        databaseRef: '');
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      CHAT_OFFER_ID: offerId,
      CHAT_DATE_CREATED: dateCreated.toIso8601String(),
      CHAT_PEERS: peers,
      CHAT_DATABASE_REF: databaseRef,
    };
  }
}

class NewDatabaseChat {
  const NewDatabaseChat(this.currentUser, this.offer);

  final User currentUser;
  final Offer offer;

  Map<String, dynamic> toMap() => <String, dynamic>{
        CHAT_DATE_CREATED: DateTime.now().toIso8601String(),
        CHAT_OFFER_ID: offer.offerId,
        CHAT_PEERS: <String>[currentUser.uid, offer.authorUid],
      };
}
