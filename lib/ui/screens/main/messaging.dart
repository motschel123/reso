import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reso/business_logic/providers/chat_manager.dart';
import 'package:reso/business_logic/services/chat_service.dart';
import 'package:reso/business_logic/services/offer_service.dart';
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
                        onPressed: () {
                          OfferService.getOffer(value.chats[index].offerId)
                              .then((Offer? offer) => offer == null
                                  ? throw const FormatException(
                                      "Offer doesn't exist or has no data")
                                  : ChatService.openChat(
                                      context: context,
                                      chat: value.chats[index],
                                      offer: offer));
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
