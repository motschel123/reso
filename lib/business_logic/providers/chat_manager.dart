import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:reso/consts/firestore.dart';
import 'package:reso/model/chat.dart';

class ChatManager with ChangeNotifier {
  ChatManager() : _currentUser = FirebaseAuth.instance.currentUser! {
    init();
  }

  @override
  List<Chat> get chats => _chats;
  List<Chat> _chats = <Chat>[];

  User _currentUser;
  StreamSubscription<List<Chat>>? _streamSub;

  void init() {
    // ignore: always_put_control_body_on_new_line
    _streamSub = FirebaseFirestore.instance
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

  @override
  void dispose() {
    _streamSub?.cancel();
    super.dispose();
  }
}
