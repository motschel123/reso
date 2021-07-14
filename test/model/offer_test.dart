import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:reso/consts/firestore.dart';
import 'package:reso/model/offer.dart';

void main() {
  group('Offer model parsing', () {
    final Offer offerAllFields = Offer(
      authorDisplayName: 'Max Mustermann',
      authorImageUrl: 'url',
      authorUid: '12345',
      title: 'Outdoor walk',
      description: 'Short group walk',
      type: OfferType.activity,
      price: 'free',
      dateCreated: DateTime(1234, 2),
      dateEvent: DateTime(1234, 3),
      imageRef: 'imageRef',
      imageUrl: 'imageUrl',
      location: 'location',
      offerId: 'Id12Offer',
    );

    const Offer offerNeededFields = Offer(
      type: OfferType.food,
      title: 'food',
      description: 'es gibt steak',
      price: '12345€',
      authorUid: 'my123Uid45',
      authorImageUrl: 'imageAuthorUrl',
      authorDisplayName: 'Michelle Musterfrau',
    );

    test('To Map', () {
      for (final Offer offer in <Offer>{offerAllFields, offerNeededFields}) {
        expect(offer.toMap(), <String, dynamic>{
          OFFER_TYPE: offer.type.toConst,
          OFFER_TITLE: offer.title,
          OFFER_DESCRIPTION: offer.description,
          OFFER_PRICE: offer.price,
          OFFER_AUTHOR_UID: offer.authorUid,
          OFFER_AUTHOR_DISPLAY_NAME: offer.authorDisplayName,
          OFFER_AUTHOR_IMAGE_URL: offer.authorImageUrl,
          OFFER_DATE_CREATED: offer.dateCreated?.toIso8601String(),
          OFFER_DATE_EVENT: offer.dateEvent?.toIso8601String(),
          OFFER_LOCATION: offer.location,
          OFFER_IMAGE_REFERENCE: offer.imageRef,
          OFFER_IMAGE_URL: offer.imageUrl,
        });
      }
    });

    test('From Map', () {
      for (final Offer o in <Offer>{offerAllFields, offerNeededFields}) {
        final Offer offer = Offer.fromMap(o.toMap(), o.offerId);

        expect(offer.type, o.type);
        expect(offer.title, o.title);
        expect(offer.description, o.description);
        expect(offer.price, o.price);
        expect(offer.authorUid, o.authorUid);
        expect(offer.authorDisplayName, o.authorDisplayName);
        expect(offer.authorImageUrl, o.authorImageUrl);
        expect(offer.dateCreated, o.dateCreated);
        expect(offer.dateEvent, o.dateEvent);
        expect(offer.imageRef, o.imageRef);
        expect(offer.imageUrl, o.imageUrl);
        expect(offer.location, o.location);
        expect(offer.offerId, o.offerId);
      }
    });

    test('From Map: Illegal data should throw FormatExceptions', () {
      for (MapEntry<String, dynamic> mapEntry in <MapEntry<String, dynamic>>{
        const MapEntry<String, dynamic>(OFFER_TYPE, 'NoOfferType'),
        const MapEntry<String, dynamic>(OFFER_TYPE, null),
        const MapEntry<String, dynamic>(OFFER_TITLE, 1337),
        const MapEntry<String, dynamic>(OFFER_TITLE, null),
        const MapEntry<String, dynamic>(OFFER_DESCRIPTION, 1337),
        const MapEntry<String, dynamic>(OFFER_DESCRIPTION, null),
        const MapEntry<String, dynamic>(OFFER_PRICE, null),
        const MapEntry<String, dynamic>(OFFER_AUTHOR_DISPLAY_NAME, null),
        const MapEntry<String, dynamic>(OFFER_AUTHOR_IMAGE_URL, null),
        const MapEntry<String, dynamic>(OFFER_AUTHOR_UID, null),
      }) {
        bool didThrow = false;
        final Map<String, dynamic> mappedOffer = offerNeededFields.toMap();
        mappedOffer.update(mapEntry.key, (dynamic _) => mapEntry.value);

        try {
          Offer.fromMap(mappedOffer, offerNeededFields.offerId);
        } on FormatException {
          didThrow = true;
        }

        expect(didThrow, equals(true));
      }
    });
  });
}
