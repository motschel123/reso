import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:reso/consts/firestore.dart';

extension MinuteOnlyCompare on DateTime {
  bool isSameDate(DateTime other) {
    return year == other.year &&
        month == other.month &&
        day == other.day &&
        hour == other.hour &&
        minute == other.minute;
  }
}

class Message {
  Message({
    this.id,
    required this.text,
    required this.senderUid,
    required this.timeSent,
  });
  final String text;
  final String senderUid;
  final DateTime timeSent;
  final String? id;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      MESSAGE_TEXT: text,
      MESSAGE_SENDER_UID: senderUid,
      MESSAGE_TIME_SENT: timeSent.toIso8601String(),
    };
  }

  static Message fromMap(Map<Object?, Object?> map) {
    print(map);
    if (!map.containsKey(MESSAGE_TEXT)) {
      throw Exception("Couldn't parse text");
    }
    if (!map.containsKey(MESSAGE_SENDER_UID)) {
      throw Exception("Couldn't parse senderUid");
    }
    if (!map.containsKey(MESSAGE_TIME_SENT)) {
      throw Exception("Couldn't parse timeSent");
    }
    return Message(
      text: map[MESSAGE_TEXT]! as String,
      senderUid: map[MESSAGE_SENDER_UID]! as String,
      timeSent: DateTime.parse(map[MESSAGE_TIME_SENT]! as String),
    );
  }
}
