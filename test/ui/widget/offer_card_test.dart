import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:reso/model/offer.dart';
import 'package:reso/ui/widgets/offer_card.dart';

void main() {
  group('OfferCard test', () {
    testWidgets('should display offer infos', (WidgetTester tester) async {
      const Offer sampleOffer = Offer.sample;
      await mockNetworkImagesFor(() async {
        await tester
            .pumpWidget(MaterialApp(home: OfferCard(offer: sampleOffer)));

        await tester.idle();
        await tester.pump();

        expect(find.text(sampleOffer.title), findsOneWidget);
        expect(find.text(sampleOffer.description), findsOneWidget);
        expect(
            find.byWidgetPredicate((Widget widget) =>
                widget is RichText &&
                widget.text.toPlainText() == sampleOffer.price),
            findsOneWidget);
      });
    });
  });
}
