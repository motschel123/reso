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

  static Message fromMap(Map<Object?, dynamic> map, String? id) {
    print(map);

    String text;
    try {
      text = map[MESSAGE_TEXT] as String;
    } catch (e) {
      throw FormatException("Couldn't parse message text: $e");
    }

    String senderUid;
    try {
      senderUid = map[MESSAGE_SENDER_UID] as String;
    } catch (e) {
      throw FormatException("Couldn't parse senderUid: $e");
    }

    DateTime timeSent;
    try {
      timeSent = DateTime.parse(map[MESSAGE_TIME_SENT] as String);
    } catch (e) {
      throw FormatException("Couldn't parse senderUid: $e");
    }

    return Message(
      id: id,
      text: text,
      senderUid: senderUid,
      timeSent: timeSent,
    );
  }
}

final List<Message> sampleMessages = <Message>[
  Message(
    text:
        'Luca: Lorem ipsum dolor sit amet, consectetur adipiscing elit.\nAliquam risus nisi, placerat et tempor sit amet, porttitor vitae ...',
    senderUid: '2',
    timeSent: DateTime(2021, 6, 7, 18, 35),
  ),
  Message(
    text:
        'Ich: Lorem ipsum dolor sit amet, consectetur adipiscing elit.\nAliquam risus nisi, placerat et tempor sit amet, porttitor vitae ...',
    senderUid: '1',
    timeSent: DateTime(2021, 6, 7, 18, 35),
  ),
  Message(
    text: 'Hey',
    senderUid: '1',
    timeSent: DateTime(2021, 6, 7, 18, 35),
  ),
];
