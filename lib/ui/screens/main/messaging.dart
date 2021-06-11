import 'package:flutter/material.dart';
import 'package:reso/model/message.dart';
import 'package:reso/ui/screens/chat_dialogue.dart';
import 'package:reso/ui/widgets/offer_card.dart';

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text('Nachrichten',
                style: Theme.of(context).textTheme.headline1),
          ),
          const Divider(height: 0),
          Expanded(
              child: ListView.separated(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  itemCount: 5,
                  separatorBuilder: (BuildContext context, int index) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Divider(),
                    );
                  },
                  itemBuilder: (BuildContext context, int index) {
                    return OfferCard(
                      offerTitle: 'Vegetarische Pizza',
                      offerPrice: '3,00€',
                      offerDescription: 'Du: Hey',
                      offerAuthor: 'Luca Beetz',
                      profileImage: 'https://thispersondoesnotexist.com/image',
                      offerColor: Colors.amber,
                      onTap: () {
                        Navigator.of(context).push<ChatDialogue>(
                            MaterialPageRoute<ChatDialogue>(
                                builder: (BuildContext context) =>
                                    ChatDialogue(messages: sampleMessages)));
                      },
                    );
                  }))
        ],
      ),
    ));
  }
}
