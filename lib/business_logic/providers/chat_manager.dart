import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:reso/consts/firestore.dart';
import 'package:reso/model/chat.dart';

class ChatManager with ChangeNotifier {
  ChatManager() : _currentUser = FirebaseAuth.instance.currentUser! {}

  @override
  List<Chat> get chats => _chats;
  List<Chat> _chats = <Chat>[];

  StreamSubscription<List<Chat>>? _prevStreamSub;
  User _currentUser;

  void init() {
    // ignore: always_put_control_body_on_new_line
    if (_prevStreamSub != null) _prevStreamSub!.cancel();

    _prevStreamSub = FirebaseFirestore.instance
        .collection(CHATS_COLLECTION)
        .where(CHAT_PEERS, arrayContains: _currentUser.uid)
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
