import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reso/business_logic/providers/chat_manager.dart';
import 'package:reso/business_logic/services/chat_service.dart';
import 'package:reso/consts/firestore.dart';
import 'package:reso/model/offer.dart';

class Messaging extends StatefulWidget {
  const Messaging({Key? key}) : super(key: key);

  @override
  _MessagingState createState() => _MessagingState();
}

class _MessagingState extends State<Messaging> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Consumer<ChatManager>(
        builder: (BuildContext context, ChatManager value, _) => Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text('Nachrichten', style: Theme.of(context).textTheme.headline1),
            Expanded(
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: value.chats.length,
                  itemBuilder: (BuildContext context, int index) => TextButton(
                        onPressed: () async {
                          final DocumentSnapshot<Map<String, dynamic>>
                              offerDoc = await FirebaseFirestore.instance
                                  .doc(OFFERS_COLLECTION +
                                      '/' +
                                      value.chats[index].offerId)
                                  .get();
                          if (offerDoc.data() == null) {
                            throw Exception(
                                'offerDoc (${offerDoc.id}) has no data');
                          } else {
                            final Offer offer = Offer.fromMap(offerDoc.data()!);

                            ChatService.openChat(
                                context: context,
                                chat: value.chats[index],
                                offer: offer);
                          }
                        },
                        child: Text(value.chats[index].chatId),
                      )),
            ),
          ],
        ),
      ),
    )));
  }
}
