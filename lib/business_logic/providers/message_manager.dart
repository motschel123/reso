import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:reso/consts/database.dart';
import 'package:reso/model/chat.dart';
import 'package:reso/model/message.dart';

final FirebaseDatabase _database = FirebaseDatabase(
    databaseURL:
        'https://reso-83572-default-rtdb.europe-west1.firebasedatabase.app/');

class MessageManager {
  MessageManager(this._chat)
      : messages = ValueNotifier<List<Message>>(<Message>[]) {
    if (_chat != null) {
      init();
    }
  }

  Future<void> init() async {
    //await _database.goOnline();
    _databaseRef =
        _database.reference().child(CHATS_PATH).child(_chat!.databaseRef);
    _databaseRef.keepSynced(true);

    _databaseRef.onValue.listen((Event event) {
      if (event.snapshot != null) {
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

  late final DatabaseReference _databaseRef;
  final Chat? _chat;
  final ValueNotifier<List<Message>> messages;
}
