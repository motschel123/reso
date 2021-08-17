import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:reso/business_logic/services/chat_service.dart';
import 'package:reso/consts/firestore.dart';
import 'package:reso/model/chat.dart';
import 'package:reso/model/message.dart';
import 'package:reso/model/offer.dart';

final FirebaseDatabase _database = FirebaseDatabase(
    databaseURL:
        'https://reso-83572-default-rtdb.europe-west1.firebasedatabase.app/');

class MessageManager {
  MessageManager(this._chat, this.offer)
      : messages = ValueNotifier<List<Message>>(<Message>[]) {
    _init();
  }

  final ValueNotifier<List<Message>> messages;

  Chat? _chat;
  final Offer offer;
  late final DatabaseReference _databaseRef;

  StreamSubscription<Event>? _prevStreamSub;

  Future<void> sendMessage(Message message) {
    return ChatService.sendMessage(
      currentUser: FirebaseAuth.instance.currentUser!,
      chat: _chat,
      message: message,
      offer: offer,
    ).then<void>((Chat newChat) => _updateChat(newChat));
  }

  void _init() {
    // ignore: always_put_control_body_ on_new_line
    if (_chat == null) return;

    _databaseRef =
        _database.reference().child(CHATS_COLLECTION).child(_chat!.databaseRef);
    _databaseRef.keepSynced(true);

    _prevStreamSub = _databaseRef.onValue.listen((Event event) {
      if (event.snapshot != null && event.snapshot.value != null) {
        final List<Message> newMessages = <Message>[];
        for (final Object? key
            in (event.snapshot.value as Map<Object?, Object?>).keys) {
          final Message message = Message.fromMap(
              event.snapshot.value[key] as Map<Object?, dynamic>,
              event.snapshot.key);
          newMessages.insert(0, message);
        }
        messages.value = newMessages;
      }
    });
  }

  void _updateChat(Chat newChat) {
    if (newChat != _chat) {
      _prevStreamSub?.cancel();
      messages.value.clear();
      _chat = newChat;
      _init();
    }
  }
}
