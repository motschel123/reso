import 'package:flutter/material.dart';
import 'package:reso/business_logic/services/offer_service.dart';
import 'package:reso/model/chat.dart';
import 'package:reso/model/offer.dart';
import 'package:reso/ui/widgets/default_profile_image.dart';

class ChatCard extends StatelessWidget {
  const ChatCard({Key? key, required this.chat, this.onTap}) : super(key: key);

  final void Function()? onTap;
  final Chat chat;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: Column(children: <Widget>[
        Row(
          children: <Widget>[
            Stack(children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: FutureBuilder<Offer?>(
                  future: getOffer(chat.offerId),
                  builder: (BuildContext context,
                          AsyncSnapshot<Offer?> snapshot) =>
                      (snapshot.hasData && snapshot.data != null)
                          ? CircleAvatar(
                              backgroundImage:
                                  NetworkImage(snapshot.data!.authorImageUrl),
                              backgroundColor: Colors.amber,
                              radius: 28.0,
                            )
                          : const DefaultProfileImage(),
                ),
              ),
            ]),
            const SizedBox(width: 8.0),
            Expanded(
                child: GestureDetector(
              onTap: onTap,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('TITEL', style: Theme.of(context).textTheme.headline2),
                  Text('AUTHOR', style: Theme.of(context).textTheme.subtitle1)
                ],
              ),
            )),
          ],
        ),
        const SizedBox(height: 16.0),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Divider(height: 0),
        ),
      ]),
    );
  }
}
