import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:reso/consts/database.dart';
import 'package:reso/consts/firestore.dart';
import 'package:reso/model/chat.dart';
import 'package:reso/model/message.dart';
import 'package:reso/model/offer.dart';
import 'package:reso/ui/screens/chat_dialogue.dart';

export 'package:reso/model/chat.dart';

final HttpsCallable _createChatCallable =
    FirebaseFunctions.instanceFor(region: 'europe-west1').httpsCallable(
        'createChat',
        options: HttpsCallableOptions(timeout: const Duration(seconds: 10)));

class ChatService {
  /// Calls the backend to create a new Chat
  ///
  /// returns the documentId of the newly created ChatDocument
  static Future<String> _newChat(
      final User currentUser, final Offer offer, final Message message) async {
    if (currentUser.uid == offer.authorUid) {
      throw Exception("Can't create chat with self");
    }
    final HttpsCallableResult<String> result =
        await _createChatCallable.call<String>(<String, String>{
      'peer1': currentUser.uid,
      'peer2': offer.authorUid,
      'offerId': offer.offerId!,
      'messageText': message.text,
      'messageSenderUid': message.senderUid,
      'messageTimeSent': message.timeSent.toIso8601String(),
    }).onError((Object? error, StackTrace stackTrace) {
      print(error.toString());
      print(stackTrace);
      throw Exception("'createChat' function call had error");
    });
    return result.data;
  }

  static Future<Chat?> getChat(
      final User currentUser, final Offer offer) async {
    if (currentUser.uid == offer.authorUid) {
      throw Exception("Can't create chat with self");
    }
    final QuerySnapshot<Map<String, dynamic>> qSnap = await FirebaseFirestore
        .instance
        .collection(CHATS_COLLECTION)
        .where(CHAT_PEERS, arrayContains: currentUser.uid)
        .where(CHAT_OFFER_ID, isEqualTo: offer.offerId)
        .get();
    if (qSnap.docs.isEmpty) {
      return null;
    } else {
      return Chat.fromChatDoc(qSnap.docs.first);
    }
  }

  static Future<void> openChat(
      {required BuildContext context,
      required Chat? chat,
      required Offer offer}) {
    return Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (BuildContext context) => ChatDialogue(
          chat: chat,
          offer: offer,
        ),
      ),
    );
  }

  static Future<Chat> sendMessage(
      {required User currentUser,
      required Chat? chat,
      required Message message,
      required Offer offer}) async {
    final FirebaseDatabase _database = FirebaseDatabase(
        databaseURL:
            'https://reso-83572-default-rtdb.europe-west1.firebasedatabase.app/');

    _database
        .reference()
        .child(CHATS_PATH)
        .child(chat!.databaseRef)
        .push()
        .set(message.toMap());

    return chat;
  }
}
