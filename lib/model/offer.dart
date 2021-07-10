import 'package:reso/consts/firestore.dart';

enum OfferType { product, service, food, activity }

/// Extension for converting an OfferType to a display string
///
/// This should later be changed to include locale dependent strings
extension StringExtension on OfferType {
  String get toDisplayString {
    switch (this) {
      case OfferType.product:
        return 'Produkt';
      case OfferType.service:
        return 'Dienstleistung';
      case OfferType.food:
        return 'Gericht';
      case OfferType.activity:
        return 'Aktivität';
    }
  }

  String get toConst {
    switch (this) {
      case OfferType.product:
        return OFFER_TYPE_PRODUCT;
      case OfferType.service:
        return OFFER_TYPE_SERVICE;
      case OfferType.food:
        return OFFER_TYPE_FOOD;
      case OfferType.activity:
        return OFFER_TYPE_ACTIVITY;
    }
  }

  OfferType fromConst(String offerString) {
    switch (offerString) {
      case OFFER_TYPE_PRODUCT:
        return OfferType.product;
      case OFFER_TYPE_SERVICE:
        return OfferType.service;
      case OFFER_TYPE_FOOD:
        return OfferType.food;
      case OFFER_TYPE_ACTIVITY:
        return OfferType.activity;
      default:
        throw Exception(
            'Parsing OfferType from String went wrong: String == $offerString');
    }
  }
}

class Offer {
  const Offer({
    required this.type,
    required this.title,
    required this.description,
    required this.price,
    required this.authorUid,
    required this.authorImageUrl,
    required this.authorDisplayName,
    this.dateCreated,
    this.dateEvent,
    this.location,
    this.imageRef,
    this.imageUrl,
    this.offerId,
  });
  final OfferType type;
  final String title, price, description;
  final String authorUid, authorImageUrl, authorDisplayName;
  final DateTime? dateCreated, dateEvent;
  final String? location, imageUrl, imageRef;
  final String? offerId;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      OFFER_TYPE: type.toConst,
      OFFER_TITLE: title,
      OFFER_DESCRIPTION: description,
      OFFER_PRICE: price,
      OFFER_AUTHOR_UID: authorUid,
      OFFER_AUTHOR_DISPLAY_NAME: authorDisplayName,
      OFFER_AUTHOR_IMAGE_URL: authorImageUrl,
      OFFER_DATE_CREATED: dateCreated?.toIso8601String(),
      OFFER_DATE_EVENT: dateEvent?.toIso8601String(),
      OFFER_LOCATION: location,
      OFFER_IMAGE_REFERENCE: imageRef,
      OFFER_IMAGE_URL: imageUrl,
    };
  }

  static Offer fromMap(Map<String, dynamic> data, String? offerId) {
    assert(data[OFFER_TYPE] != null);
    assert(data[OFFER_TITLE] != null);
    assert(data[OFFER_DESCRIPTION] != null);
    assert(data[OFFER_PRICE] != null);
    assert(data[OFFER_AUTHOR_UID] != null);

    final String? dateCreatedString =
        _parse<String?>(data, OFFER_DATE_CREATED, 'dateCreated');

    final String? dateEventString =
        _parse<String?>(data, OFFER_DATE_EVENT, 'dateEvent');

    return Offer(
      type: OfferType.food.fromConst(_parse<String>(data, OFFER_TYPE, 'type')),
      title: _parse<String>(data, OFFER_TITLE, 'title'),
      description: _parse<String>(data, OFFER_DESCRIPTION, 'description'),
      price: _parse<String>(data, OFFER_PRICE, 'price'),
      authorUid: _parse<String>(data, OFFER_AUTHOR_UID, 'authorUid'),
      authorDisplayName:
          _parse<String>(data, OFFER_AUTHOR_DISPLAY_NAME, 'authorDisplayName'),
      authorImageUrl:
          _parse<String>(data, OFFER_AUTHOR_IMAGE_URL, 'authorImageUrl'),
      imageRef: _parse<String?>(data, OFFER_IMAGE_REFERENCE, 'imageRef'),
      imageUrl: _parse<String?>(data, OFFER_IMAGE_URL, 'imageUrl'),
      location: _parse<String?>(data, OFFER_LOCATION, 'location'),
      dateCreated:
          dateCreatedString != null ? DateTime.parse(dateCreatedString) : null,
      dateEvent:
          dateEventString != null ? DateTime.parse(dateEventString) : null,
      offerId: offerId,
    );
  }

  static T _parse<T>(Map<String, dynamic> map, String key, String errName) {
    try {
      return map[key] as T;
    } catch (e) {
      throw FormatException("Couldn't parse $errName: $e");
    }
  }
}
