import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:reso/consts/firestore.dart';

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
      MESSAGE_TIME_SENT: timeSent,
    };
  }

  static Message fromDocSnap(DocumentSnapshot<Map<String, dynamic>> docSnap) {
    final String text = docSnap.data()?[MESSAGE_TEXT] as String;
    final String senderUid = docSnap.data()?[MESSAGE_SENDER_UID] as String;
    final DateTime timeSent =
        (docSnap.data()?[MESSAGE_TIME_SENT] as Timestamp).toDate();

    return Message(
      id: docSnap.id,
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
