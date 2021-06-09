import 'package:flutter_test/flutter_test.dart';
import 'package:reso/consts/firestore.dart';
import 'package:reso/model/offer.dart';

void main() {
  group('Offer model', () {
    test('should create Map from Offer', () {
      const Offer offer = Offer(
          type: OfferType.activity,
          title: 'Outdoor walk',
          description: 'Short group walk',
          price: 'free',
          authorUid: '1a3',
          authorDisplayName: 'Luca',
          authorImageUrl: 'imageUrl');

      expect(offer.toMap(), <String, dynamic>{
        OFFER_TYPE: OFFER_TYPE_ACTIVITY,
        OFFER_TITLE: 'Outdoor walk',
        OFFER_DESCRIPTION: 'Short group walk',
        OFFER_PRICE: 'free',
        OFFER_AUTHOR_UID: '1a3',
        OFFER_AUTHOR_DISPLAY_NAME: 'Luca',
        OFFER_AUTHOR_IMAGE_URL: 'imageUrl',
        OFFER_DATE_CREATED: null,
        OFFER_LOCATION: null,
        OFFER_IMAGE_REFERENCE: null,
        OFFER_IMAGE_URL: null,
      });
    });

    test('should create Offer from Map', () {
      const Map<String, dynamic> offerMap = <String, dynamic>{
        OFFER_TYPE: OFFER_TYPE_FOOD,
        OFFER_TITLE: 'Outdoor walk',
        OFFER_DESCRIPTION: 'Short group walk',
        OFFER_PRICE: 'free',
        OFFER_AUTHOR_UID: '1a3',
        OFFER_AUTHOR_DISPLAY_NAME: 'Luca',
        OFFER_AUTHOR_IMAGE_URL: 'imageUrl',
      };

      final Offer offer = Offer.fromMap(offerMap);

      expect(offer.type, OfferType.food);
      expect(offer.title, 'Outdoor walk');
      expect(offer.description, 'Short group walk');
      expect(offer.price, 'free');
      expect(offer.authorUid, '1a3');
      expect(offer.authorDisplayName, 'Luca');
      expect(offer.authorImageUrl, 'imageUrl');
    });

    test('should not create Offer if Map misses required elements', () {
      const Map<String, dynamic> offerMap = <String, dynamic>{
        OFFER_TYPE: 'Outdoor walk',
        OFFER_TITLE: 'Short group walk',
      };

      throwsA(() {
        Offer.fromMap(offerMap);
      });
    });
  });
}
