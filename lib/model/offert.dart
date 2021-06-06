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
}
