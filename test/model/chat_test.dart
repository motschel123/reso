import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:reso/consts/firestore.dart';
import 'package:reso/model/chat.dart';
import 'package:reso/model/user_profile.dart';

void main() {
  group('Chat model', () {
    test('should create Map from Chat', () async {
      final FakeFirebaseFirestore firestore = FakeFirebaseFirestore();
      await firestore.collection(OFFERS_COLLECTION).add(<String, dynamic>{
        OFFER_TYPE: OFFER_TYPE_FOOD,
        OFFER_TITLE: 'Outdoor walk',
        OFFER_DESCRIPTION: 'Short group walk',
        OFFER_PRICE: 'free',
        OFFER_AUTHOR_UID: '1a3',
        OFFER_AUTHOR_DISPLAY_NAME: 'Luca',
        OFFER_AUTHOR_IMAGE_URL: 'https://thispersondoesnotexist.com/image',
      });
      final QuerySnapshot<Map<String, dynamic>> snapshot =
          await firestore.collection(OFFERS_COLLECTION).get();
      final DocumentReference<Map<String, dynamic>> relatedOffer =
          snapshot.docs.first.reference;

      final Chat chat = Chat(
          chatId: '1ad',
          relatedOffer: relatedOffer,
          latestDate: DateTime(2021, 6, 11, 10, 44),
          latestMessageText: 'Hey',
          dateCreated: DateTime(2021, 6, 11, 10, 44),
          peers: <String, UserProfile>{});

      expect(chat.toMap(), <String, dynamic>{
        CHAT_RELATED_OFFER: relatedOffer,
        CHAT_LATEST_DATE: DateTime(2021, 6, 11, 10, 44),
        CHAT_LATEST_MESSAGE_TEXT: 'Hey',
        CHAT_DATE_CREATED: DateTime(2021, 6, 11, 10, 44),
        CHAT_PEER_DATA: <String, dynamic>{},
      });
    });
  });
}
