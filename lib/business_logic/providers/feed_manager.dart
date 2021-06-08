import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:reso/model/offer.dart';
export './firebase_impl/firebase_feed_manager.dart';

typedef ErrorCallback = void Function(Object error, StackTrace stackTrace);

/// call [initFeedForUser] to set the currentUser
///
/// If more feed [Offer]s are needed call [loadMoreOffers] with desired amount
abstract class FeedManager extends ChangeNotifier {
  List<Offer> get offers;

  /// Initialized a personalized feed for a given [User]
  ///
  /// Updates [offers] if new data is received, notifying listeners
  ///
  /// Calling [initFeedForUser] with a new [User] erases previous feed data
  void initFeedForUser(User currenUser, {ErrorCallback? errorCallback});

  /// Must only be called after [initFeedForUser]
  ///
  /// Loads [amount] more [Offer]s for the current feed
  void loadMoreOffers(int amount, {ErrorCallback? errorCallback});
}
