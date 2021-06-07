import 'package:cloud_firestore/cloud_firestore.dart';
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
    this.time,
    this.location,
    this.imageRef,
    this.imageUrl,
    this.offerUid,
  });

  final OfferType type;
  final String title, price, description;
  final String authorUid;
  final DateTime? time;
  final String? location, imageRef, imageUrl;
  final String? offerUid;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      OFFER_TYPE: type.toConst,
      OFFER_TITLE: title,
      OFFER_DESCRIPTION: description,
      OFFER_PRICE: price,
      OFFER_AUTHOR_UID: authorUid,
      OFFER_TIME: time,
      OFFER_LOCATION: location,
      OFFER_IMAGE_REFERENCE: imageRef,
      OFFER_IMAGE_URL: imageUrl,
    };
  }

  static Offer fromMap(Map<String, dynamic> data, {String? offerUid}) {
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
      imageRef: data[OFFER_IMAGE_REFERENCE] as String?,
      imageUrl: data[OFFER_IMAGE_URL] as String?,
      location: data[OFFER_LOCATION] as String?,
      time: (data[OFFER_TIME] as Timestamp?)?.toDate(),
      offerUid: offerUid,
    );
  }
}
