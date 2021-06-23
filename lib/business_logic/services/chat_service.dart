import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:reso/consts/firestore.dart';
import 'package:reso/model/chat.dart';
import 'package:reso/model/message.dart';
import 'package:reso/model/offer.dart';

export 'package:reso/model/chat.dart';

final HttpsCallable _createChatCallable =
    FirebaseFunctions.instanceFor(region: 'europe-west1').httpsCallable(
        'createChat',
        options: HttpsCallableOptions(timeout: const Duration(seconds: 10)));

class ChatService {
  /// Calls the backend to create a new Chat
  ///
  /// returns the documentId of the newly created ChatDocument
  static Future<String?> _newChat(
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
      'messageTimeSent': Timestamp.fromDate(message.timeSent).toString(),
    }).onError((Object? error, StackTrace stackTrace) {
      print(error.toString());
      print(stackTrace);
      throw Exception("'createChat' function call had error");
    });
    return result.data;
  }

  static Future<Chat?> getChat(
      final User currentUser, final Offer offer) async {
    QuerySnapshot<Map<String, dynamic>> qSnap = await FirebaseFirestore.instance
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
}
