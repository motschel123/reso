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
      chatId: chatId,
      offerId: offerId,
      dateCreated: dateCreated,
      peers: peers,
      databaseRef: databaseRef,
    );
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
