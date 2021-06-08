import 'package:flutter/material.dart';
import 'package:reso/model/message.dart';
import 'package:reso/ui/widgets/offer_heading.dart';
import 'package:reso/ui/widgets/styled_form_elements.dart';

class ChatDialogue extends StatefulWidget {
  const ChatDialogue({Key? key, required this.messages}) : super(key: key);

  final List<Message> messages;

  @override
  _ChatDialogueState createState() => _ChatDialogueState();
}

class _ChatDialogueState extends State<ChatDialogue> {
  final TextEditingController _messageController = TextEditingController();

  final String currentUserUid = '1';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Column(
      children: <Widget>[
        const OfferHeading(
            offerTitle: 'Programmieren',
            offerAuthor: 'Luca Beetz',
            profileImage: 'https://thispersondoesnotexist.com/image',
            offerColor: Colors.blue),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ListView.builder(
                itemCount: widget.messages.length,
                itemBuilder: (BuildContext context, int index) {
                  final Message message = widget.messages[index];

                  // Determine if the previous message was sent by same user
                  final bool ownMessage = message.senderUid == currentUserUid;
                  final bool messageStreak = index > 0 &&
                      widget.messages[index - 1].senderUid == message.senderUid;

                  // Do not display time sent if last message was sent by current
                  // user and sent at the same time
                  final bool dontDisplayTime = index != 0 &&
                      index < (widget.messages.length - 1) &&
                      widget.messages[index + 1].timeSent == message.timeSent &&
                      widget.messages[index + 1].senderUid == currentUserUid;

                  return Align(
                      alignment: ownMessage
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                          constraints: BoxConstraints(
                              maxWidth:
                                  MediaQuery.of(context).size.width * 0.75),
                          margin:
                              EdgeInsets.only(top: messageStreak ? 2.0 : 16.0),
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                              color: Theme.of(context).buttonColor,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(8.0))),
                          child: Column(
                            crossAxisAlignment: ownMessage
                                ? CrossAxisAlignment.end
                                : CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                message.text,
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                              if (!dontDisplayTime)
                                Padding(
                                  padding: const EdgeInsets.only(top: 4.0),
                                  child: Text(
                                    '18:37',
                                    style: Theme.of(context).textTheme.caption,
                                  ),
                                )
                            ],
                          )));
                }),
          ),
        ),
        const Divider(height: 0),
        Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Form(
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: StyledTextFormField(
                      hintText: 'Nachricht',
                      controller: _messageController,
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.send),
                  )
                ],
              ),
            )),
      ],
    )));
  }
}