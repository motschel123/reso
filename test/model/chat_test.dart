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
      final DocumentReference<Map<String, dynamic>> relatedOffer =
          await firestore.collection(OFFERS_COLLECTION).add(<String, dynamic>{
        OFFER_TYPE: OFFER_TYPE_FOOD,
        OFFER_TITLE: 'Outdoor walk',
        OFFER_DESCRIPTION: 'Short group walk',
        OFFER_PRICE: 'free',
        OFFER_AUTHOR_UID: '1a3',
        OFFER_AUTHOR_DISPLAY_NAME: 'Luca',
        OFFER_AUTHOR_IMAGE_URL: 'https://thispersondoesnotexist.com/image',
      });

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

    test('should create Chat from chatDoc', () async {
      final FakeFirebaseFirestore firestore = FakeFirebaseFirestore();
      // Add sample offer to firestore
      final DocumentReference<Map<String, dynamic>> relatedOffer =
          await firestore.collection(OFFERS_COLLECTION).add(<String, dynamic>{
        OFFER_TYPE: OFFER_TYPE_FOOD,
        OFFER_TITLE: 'Outdoor walk',
        OFFER_DESCRIPTION: 'Short group walk',
        OFFER_PRICE: 'free',
        OFFER_AUTHOR_UID: '1a3',
        OFFER_AUTHOR_DISPLAY_NAME: 'Luca',
        OFFER_AUTHOR_IMAGE_URL: 'https://thispersondoesnotexist.com/image',
      });

      // Add sample chat to firestore
      await firestore.collection(CHATS_COLLECTION).add(<String, dynamic>{
        CHAT_LATEST_DATE: DateTime(2021, 6, 11, 11, 4),
        CHAT_LATEST_MESSAGE_TEXT: 'Hey',
        CHAT_DATE_CREATED: DateTime(2021, 6, 11, 11, 4),
        CHAT_RELATED_OFFER: relatedOffer,
        CHAT_PEER_DATA: <String, dynamic>{},
      });

      final QuerySnapshot<Map<String, dynamic>> chatSnapshot =
          await firestore.collection(CHATS_COLLECTION).get();
      final Chat chat = Chat.fromChatDoc(chatSnapshot.docs.first);

      expect(chat.chatId, chatSnapshot.docs.first.id);
      expect(chat.dateCreated, DateTime(2021, 6, 11, 11, 4));
      expect(chat.latestDate, DateTime(2021, 6, 11, 11, 4));
      expect(chat.latestMessageText, 'Hey');
      expect(chat.relatedOffer, relatedOffer);
    });
  });
}
