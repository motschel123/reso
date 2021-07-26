import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:reso/model/offer.dart';
import 'package:reso/ui/screens/offer_detail.dart';

void main() {
  group('Offer Detail', () {
    testWidgets('should display information about offer',
        (WidgetTester tester) async {
      await mockNetworkImagesFor(() async {
        const Offer offer = Offer(
            type: OfferType.activity,
            title: 'Outdoor walk',
            description: 'Short group walk',
            price: 'free',
            authorUid: '1a3',
            authorDisplayName: 'Luca',
            authorImageUrl: 'https://thispersondoesnotexist.com/image');

        await tester
            .pumpWidget(const MaterialApp(home: OfferDetail(offer: offer)));

        await tester.idle();
        await tester.pump();

        expect(find.text('Outdoor walk'), findsOneWidget);
        expect(find.text('Short group walk'), findsOneWidget);
        expect(
            find.byWidgetPredicate((Widget widget) =>
                widget is RichText &&
                widget.text.toPlainText() == 'Preis: free'),
            findsOneWidget);
        expect(find.text('Luca'), findsWidgets);
      });
    });
  });
}
