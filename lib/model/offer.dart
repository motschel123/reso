import 'package:reso/consts/firestore.dart';

enum OfferType { product, service, food, activity }

/// Extension for converting an OfferType to a display string
///
/// This should later be changed to include locale dependent strings
extension StringExtension on OfferType {
  String get displayString {
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

  OfferType fromString(String offerString) {
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
        throw Exception('Parsing OfferType from String went wrong');
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
      OFFER_LOCATION: location,
      OFFER_IMAGE_REFERENCE: imageRef,
      OFFER_IMAGE_URL: imageUrl,
    };
  }

  static Offer fromMap(Map<String, dynamic> data, {String? offerId}) {
    assert(data[OFFER_TYPE] != null);
    assert(data[OFFER_TITLE] != null);
    assert(data[OFFER_DESCRIPTION] != null);
    assert(data[OFFER_PRICE] != null);
    assert(data[OFFER_AUTHOR_UID] != null);
    return Offer(
      type: OfferType.food.fromString(data[OFFER_TYPE] as String),
      title: data[OFFER_TITLE] as String,
      description: data[OFFER_DESCRIPTION] as String,
      price: data[OFFER_PRICE] as String,
      authorUid: data[OFFER_AUTHOR_UID] as String,
      authorDisplayName: data[OFFER_AUTHOR_DISPLAY_NAME] as String,
      authorImageUrl: data[OFFER_AUTHOR_IMAGE_URL] as String,
      imageRef: data[OFFER_IMAGE_REFERENCE] as String?,
      imageUrl: data[OFFER_IMAGE_URL] as String?,
      location: data[OFFER_LOCATION] as String?,
      dateCreated: DateTime.parse(data[OFFER_DATE_CREATED] as String),
      offerId: offerId,
    );
  }
}
