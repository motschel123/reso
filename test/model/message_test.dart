import 'package:flutter_test/flutter_test.dart';
import 'package:reso/consts/firestore.dart';
import 'package:reso/model/message.dart';

void main() {
  group('Message model', () {
    test('should create Map from Message', () {
      final Message message = Message(
          text: 'Hey',
          senderUid: 'ai3',
          timeSent: DateTime(2021, 6, 9, 19, 13));

      expect(message.toMap(), <String, dynamic>{
        MESSAGE_TEXT: 'Hey',
        MESSAGE_SENDER_UID: 'ai3',
        MESSAGE_TIME_SENT: DateTime(2021, 6, 9, 19, 13),
      });
    });
  });
}
