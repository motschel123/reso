import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:provider/provider.dart';
import 'package:reso/business_logic/providers/feed_manager.dart';
import 'package:reso/consts/firestore.dart';
import 'package:reso/ui/screens/main/live_feed.dart';

void main() {
  group('Live Feed', () {
    testWidgets('should show single offer', (WidgetTester tester) async {
      await mockNetworkImagesFor(() async {
        final FakeFirebaseFirestore firestore = FakeFirebaseFirestore();
        await firestore.collection(OFFERS_COLLECTION).add(<String, dynamic>{
          OFFER_TYPE: OFFER_TYPE_FOOD,
          OFFER_TITLE: 'Outdoor walk',
          OFFER_DESCRIPTION: 'Short group walk',
          OFFER_PRICE: 'free',
          OFFER_AUTHOR_UID: '1a3',
        });

        await tester.pumpWidget(ChangeNotifierProvider<FeedManager>(
            create: (_) =>
                FeedManager(firebaseFirestore: firestore, user: MockUser()),
            child: const MaterialApp(home: LiveFeed())));

        await tester.idle();
        await tester.pump();

        expect(find.text('Outdoor walk'), findsOneWidget);
      });
    });
  });
}
