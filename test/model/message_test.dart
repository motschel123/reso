import 'package:flutter_test/flutter_test.dart';
import 'package:reso/consts/firestore.dart';
import 'package:reso/model/message.dart';

void main() {
  group('Message model parsing', () {
    final Message message =
        Message(text: 'Hey', senderUid: 'ai3', timeSent: DateTime(2021));
    final Message messageId = Message(
        text: 'Message Id', senderUid: 'sender12345', timeSent: DateTime(2020));

    test('To Map', () {
      expect(
          message.toMap(),
          equals(<String, dynamic>{
            MESSAGE_TEXT: 'Hey',
            MESSAGE_SENDER_UID: 'ai3',
            MESSAGE_TIME_SENT: DateTime(2021).toIso8601String(),
          }));
    });

    test('From Map', () {
      Message mappedMessage = Message.fromMap(message.toMap(), message.id);

      expect(mappedMessage.senderUid, equals(message.senderUid));
      expect(mappedMessage.text, equals(message.text));
      expect(mappedMessage.timeSent, equals(message.timeSent));

      mappedMessage = Message.fromMap(messageId.toMap(), message.id);

      expect(mappedMessage.senderUid, equals(messageId.senderUid));
      expect(mappedMessage.text, equals(messageId.text));
      expect(mappedMessage.timeSent, equals(messageId.timeSent));
      expect(mappedMessage.id, equals(messageId.id));
    });

    test('From Map: Illegal data should throw Exceptions', () {
      // try different illegal map data
      for (final MapEntry<String, dynamic> mapEntry
          in <MapEntry<String, dynamic>>{
        const MapEntry<String, dynamic>(MESSAGE_SENDER_UID, null),
        const MapEntry<String, dynamic>(MESSAGE_SENDER_UID, 1337),
        const MapEntry<String, dynamic>(MESSAGE_TEXT, null),
        const MapEntry<String, dynamic>(MESSAGE_TEXT, 1337),
        const MapEntry<String, dynamic>(MESSAGE_TIME_SENT, null),
        const MapEntry<String, dynamic>(MESSAGE_TIME_SENT, 'badTime'),
      }) {
        bool didThrow = false;
        bool didThrowId = false;
        final Map<String, dynamic> messageIdMap = messageId.toMap();
        final Map<String, dynamic> messageMap = message.toMap();

        messageIdMap.update(mapEntry.key, (dynamic _) => mapEntry.value);
        messageMap.update(mapEntry.key, (dynamic _) => mapEntry.value);

        try {
          Message.fromMap(messageIdMap, messageId.id);
        } on FormatException catch (_) {
          didThrowId = true;
        }
        try {
          Message.fromMap(messageMap, messageId.id);
        } on FormatException catch (_) {
          didThrow = true;
        }

        expect(didThrow, equals(true));
        expect(didThrowId, equals(true));
      }
    });
  });
}
