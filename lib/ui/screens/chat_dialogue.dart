import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:reso/business_logic/providers/message_manager.dart';
import 'package:reso/consts/theme.dart';
import 'package:reso/model/message.dart';
import 'package:reso/ui/widgets/message_input.dart';
import 'package:reso/ui/widgets/offer_heading.dart';

class ChatDialogue extends StatelessWidget {
  ChatDialogue({Key? key, required this.messageManager}) : super(key: key);

  static const String routeId = 'chat_dialogue';

  final MessageManager messageManager;
  final User currentUser = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: <Widget>[
          OfferHeading(
            offer: messageManager.offer,
            offerColor: offerTypeToColor[messageManager.offer.type]!,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ValueListenableBuilder<List<Message>>(
                valueListenable: messageManager.messages,
                builder: (BuildContext context, List<Message> messages, _) =>
                    ListView.builder(
                        reverse: true,
                        itemCount: messages.length,
                        itemBuilder: (BuildContext context, int index) {
                          final Message message = messages[index];
                          // Determine if the previous message was sent by same user
                          final bool ownMessage =
                              message.senderUid == currentUser.uid;
                          final bool messageStreak = index > 0 &&
                              messages[index - 1].senderUid ==
                                  message.senderUid;

                          // Do not display time sent if last message was sent by current
                          // user and sent at the same time
                          final bool dontDisplayTime =
                              index < (messages.length - 1) &&
                                  messages[index + 1]
                                      .timeSent
                                      .isSameDate(message.timeSent) &&
                                  messages[index + 1].senderUid ==
                                      message.senderUid;

                          return Align(
                              alignment: ownMessage
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                              child: Container(
                                  constraints: BoxConstraints(
                                      maxWidth:
                                          MediaQuery.of(context).size.width *
                                              0.75),
                                  margin: EdgeInsets.only(
                                      top: messageStreak ? 2.0 : 16.0),
                                  padding: const EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                      color: Theme.of(context).buttonColor,
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(8.0))),
                                  child: Column(
                                    crossAxisAlignment: ownMessage
                                        ? CrossAxisAlignment.end
                                        : CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        message.text,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1,
                                      ),
                                      if (!dontDisplayTime)
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 4.0),
                                          child: Text(
                                            DateFormat('kk:mm')
                                                .format(message.timeSent),
                                            style: Theme.of(context)
                                                .textTheme
                                                .caption,
                                          ),
                                        )
                                    ],
                                  )));
                        }),
              ),
            ),
          ),
          const Divider(height: 0),
          MessageInput(onSendButtonPressed: (String text) {
            final Message message = Message(
              text: text,
              senderUid: FirebaseAuth.instance.currentUser!.uid,
              timeSent: DateTime.now(),
            );
            return messageManager.sendMessage(message);
          }),
        ],
      )),
    );
  }
}
