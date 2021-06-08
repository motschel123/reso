import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:reso/business_logic/providers/chat_manager.dart';
import 'package:reso/consts/firestore.dart';
import 'package:reso/model/chat.dart';

class FirebaseChatManager extends ChatManager {
  late StreamSubscription<List<Chat>> _prevStreamSub;

  @override
  List<Chat> get chats => _chats;
  List<Chat> _chats = <Chat>[];

  @override
  void listenToUserChats(User currentUser) {
    // ignore: always_put_control_body_on_new_line
    if (_prevStreamSub != null) _prevStreamSub.cancel();

    _prevStreamSub = FirebaseFirestore.instance
        .collection(CHATS_COLLECTION)
        .where(CHAT_PEERS, arrayContains: currentUser.uid)
        .orderBy(CHAT_LATEST_DATE)
        .snapshots()
        .map<List<Chat>>(
      (QuerySnapshot<Map<String, dynamic>> qSnap) {
        final List<Chat> chats = <Chat>[];
        for (final QueryDocumentSnapshot<Map<String, dynamic>> docSnap
            in qSnap.docs) {
          chats.add(Chat.fromChatDoc(docSnap));
        }
        return chats;
      },
    ).listen((List<Chat> newChats) {
      _chats = newChats;
      notifyListeners();
    });
  }
}
