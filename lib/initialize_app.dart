import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

typedef OnError = void Function(Object error);

void _defaultOnError(Object error) {
  print(error.toString());
}

/// Using a [StatefulWidget] to ensure that initialization is only done once.
/// When using a [StatelessWidget] everytime it is rebuilt, it
/// could re-initialize everything.
class InitializeApp extends StatefulWidget {
  /// Initializes following backend features
  /// and **must** be built before the App:
  ///   - FirebaseApp
  ///
  /// The [child] is built after init is complete
  ///
  /// Use [onError] to handle a failed init and
  /// display an error message to the user
  ///
  /// Use [onLoading] to display progress to the user
  const InitializeApp({
    Key? key,
    required this.child,
    this.onError = _defaultOnError,
    this.onErrorChild = const Center(
      child: Text('Error'),
    ),
    this.onLoadingChild = const Center(
      child: CircularProgressIndicator(),
    ),
  }) : super(key: key);

  final Widget child;
  final OnError onError;
  final Widget onErrorChild;
  final Widget onLoadingChild;

  @override
  State<InitializeApp> createState() => _InitializeAppState();
}

class _InitializeAppState extends State<InitializeApp> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<FirebaseApp>(
      future: _initialization,
      builder: (BuildContext context, AsyncSnapshot<FirebaseApp> snapshot) {
        if (snapshot.hasError) {
          widget.onError(snapshot.error!);
          return widget.onErrorChild;
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return widget.child;
        }
        return widget.onLoadingChild;
      },
    );
  }
}
