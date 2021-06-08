import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:reso/model/chat.dart';
export './firebase_impl/firebase_chat_manager.dart';

abstract class ChatManager extends ChangeNotifier {
  List<Chat> get chats;

  /// Starts listening/querying for chats linked to given [User]
  ///
  /// Updates [chatNotifier.value] if new data is received, notifying listeners
  ///
  /// Calling [listenToUserChatChanges] with a new [User] should cancel previous listening/querying
  void listenToUserChats(User currentUser);
}
