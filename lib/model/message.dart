class Message {
  const Message(
      {required this.text,
      required this.receiverUid,
      required this.senderUid,
      required this.timeSent,
      required this.timeReceived});

  final String text;
  final String receiverUid, senderUid;
  final DateTime timeSent;
  final DateTime timeReceived;
}

final List<Message> sampleMessages = <Message>[
  Message(
      text:
          'Luca: Lorem ipsum dolor sit amet, consectetur adipiscing elit.\nAliquam risus nisi, placerat et tempor sit amet, porttitor vitae ...',
      receiverUid: '1',
      senderUid: '2',
      timeSent: DateTime(2021, 6, 7, 18, 35),
      timeReceived: DateTime(2021, 6, 7, 18, 36)),
  Message(
      text:
          'Ich: Lorem ipsum dolor sit amet, consectetur adipiscing elit.\nAliquam risus nisi, placerat et tempor sit amet, porttitor vitae ...',
      receiverUid: '2',
      senderUid: '1',
      timeSent: DateTime(2021, 6, 7, 18, 35),
      timeReceived: DateTime(2021, 6, 7, 18, 36)),
  Message(
      text: 'Hey',
      receiverUid: '2',
      senderUid: '1',
      timeSent: DateTime(2021, 6, 7, 18, 35),
      timeReceived: DateTime(2021, 6, 7, 18, 36)),
];
