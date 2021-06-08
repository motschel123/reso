import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:reso/consts/firestore.dart';
import 'package:reso/model/chat.dart';

class ChatManager {
  final ValueNotifier<List<Chat>> chatNotifier =
      ValueNotifier<List<Chat>>(<Chat>[]);

  late StreamSubscription<List<Chat>> _prevStreamSub;

  void listenToUserChatChanges(User currentUser) {
    _prevStreamSub.cancel();

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
    ).listen((List<Chat> chat) {
      chatNotifier.value = chat;
    });
  }
}
