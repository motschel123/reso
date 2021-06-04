import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

/// Defines the [Function] type which is called if an error occurse
typedef OnError = void Function(Object error);

/// The default [OnError] Function, which prints the error, stacktrace and
/// throws the error afterwards
void _defaultOnError(Object error) {
  print('Firebase Initialization error: ' + error.toString());
  print('Current StackStrace : \n' + StackTrace.current.toString());
  throw error;
}

/// Using a [StatefulWidget] to ensure that initialization is only done once.
/// When using a [StatelessWidget] everytime it is rebuilt, it
/// could re-initialize everything.
class InitializeApp extends StatefulWidget {
  /// Initializes following backend features
  /// and **must** be built before the App:
  ///   - FirebaseApp
  ///
  /// All [Provider]s in [providers] will be globally accessable.
  ///
  /// The [app] is built after init is complete
  ///
  /// Use [onError] to handle a failed init and
  /// display an error message to the user
  ///
  /// Use [onLoading] to display progress to the user
  const InitializeApp({
    Key? key,
    required this.app,
    this.providers = const <SingleChildWidget>[],
    this.onError = _defaultOnError,
    this.errorChild = const Center(
      child: Text('Error'),
    ),
    this.loadingChild = const Center(
      child: CircularProgressIndicator(),
    ),
  }) : super(key: key);

  final Widget app;
  final List<SingleChildWidget> providers;
  final OnError onError;
  final Widget errorChild;
  final Widget loadingChild;

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
          return widget.errorChild;
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return MultiProvider(
              providers: widget.providers,
              builder: (BuildContext context, _) => widget.app);
        }
        return widget.loadingChild;
      },
    );
  }
}
