import 'package:firebase_database/firebase_database.dart';
import 'package:reso/consts/database.dart';
import 'package:reso/model/chat.dart';
import 'package:reso/model/message.dart';

final FirebaseDatabase _database = FirebaseDatabase(
    databaseURL:
        'https://reso-83572-default-rtdb.europe-west1.firebasedatabase.app/');

class MessageManager {
  MessageManager(this.chat) : messages = <Message>[] {
    init();
  }

  Future<void> init() async {
    await _database.goOnline();
    databaseRef =
        _database.reference().child(CHATS_PATH).child(chat.databaseRef);

    databaseRef.keepSynced(true);

    databaseRef.get().then((DataSnapshot? dataSnap) {
      if (dataSnap != null) {
        print(dataSnap.value);
      }
    });

    databaseRef.onValue.listen((Event event) {
      print(event.snapshot);
    });
  }

  late final DatabaseReference databaseRef;
  final Chat chat;
  final List<Message> messages;
}
