import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:reso/consts/firestore.dart';

class Chat {
  const Chat({
    required this.chatId,
    required this.offerId,
    required this.dateCreated,
    required this.peers,
    required this.databaseRef,
  });

  final String chatId;
  final DateTime dateCreated;
  final String offerId;
  final List<String> peers;
  final String databaseRef;

  static Chat fromChatDoc(DocumentSnapshot<Map<String, dynamic>> docSnap) {
    DateTime dateCreated;
    String offerId;
    List<String> peers;
    String databaseRef;

    // get Data from chat document
    dateCreated = (docSnap.data()?[CHAT_DATE_CREATED] as Timestamp).toDate();
    offerId = docSnap.data()?[CHAT_OFFER_ID] as String;
    peers = (docSnap.data()?[CHAT_PEERS] as List<dynamic>).cast<String>();
    databaseRef = docSnap.data()?[CHAT_DATABASE_REF] as String;

    return Chat(
      chatId: docSnap.id,
      offerId: offerId,
      dateCreated: dateCreated,
      peers: peers,
      databaseRef: databaseRef,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      CHAT_OFFER_ID: offerId,
      CHAT_DATE_CREATED: dateCreated,
      CHAT_PEERS: peers,
      CHAT_DATABASE_REF: databaseRef,
    };
  }
}
