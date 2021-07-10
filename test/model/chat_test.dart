import 'package:flutter_test/flutter_test.dart';
import 'package:reso/consts/firestore.dart';
import 'package:reso/model/chat.dart';

void main() {
  group('Chat model parsing', () {
    const String testChatId = '1234567890';
    const String testOfferId = '987654321';
    final DateTime testDateCreated = DateTime(2002);
    const List<String> testPeers = <String>['111', '222'];
    const String testDatabaseRef = 'niceRef';

    final Chat chat = Chat(
      chatId: testChatId,
      offerId: testOfferId,
      dateCreated: testDateCreated,
      peers: testPeers,
      databaseRef: testDatabaseRef,
    );

    test('To Map', () {
      expect(
          chat.toMap(),
          equals(<String, dynamic>{
            CHAT_OFFER_ID: testOfferId,
            CHAT_DATE_CREATED: testDateCreated.toIso8601String(),
            CHAT_DATABASE_REF: testDatabaseRef,
            CHAT_PEERS: testPeers,
          }));
    });

    test('From Map', () {
      final Chat mappedChat = Chat.fromMap(chat.toMap(), chat.chatId);

      expect(mappedChat.chatId, equals(chat.chatId));
      expect(mappedChat.databaseRef, equals(chat.databaseRef));
      expect(mappedChat.dateCreated, equals(chat.dateCreated));
      expect(mappedChat.offerId, equals(chat.offerId));
      expect(mappedChat.peers, equals(chat.peers));
    });

    test('From Map: Illegal data should throw Exceptions', () {
      // try different illegal map data
      for (final MapEntry<String, dynamic> mapEntry
          in <MapEntry<String, dynamic>>{
        const MapEntry<String, dynamic>(CHAT_PEERS, null),
        const MapEntry<String, dynamic>(CHAT_PEERS, 'notAnListOfPeers'),
        const MapEntry<String, dynamic>(CHAT_DATABASE_REF, null),
        const MapEntry<String, dynamic>(CHAT_DATABASE_REF, 1337),
        const MapEntry<String, dynamic>(CHAT_DATE_CREATED, null),
        const MapEntry<String, dynamic>(CHAT_DATE_CREATED, 'badTime'),
        const MapEntry<String, dynamic>(CHAT_OFFER_ID, null),
        const MapEntry<String, dynamic>(CHAT_OFFER_ID, true),
      }) {
        bool didThrow = false;
        final Map<String, dynamic> chatMap = chat.toMap();

        chatMap.update(mapEntry.key, (dynamic _) => mapEntry.value);

        try {
          Chat.fromMap(chatMap, chat.chatId);
        } on FormatException catch (_) {
          didThrow = true;
        }

        expect(didThrow, equals(true));
      }
    });

    /*test('should create Chat from chatDoc', () async {
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
    });*/
  });
}
