import 'package:flutter/material.dart';
import 'package:reso/ui/widgets/styled_form_elements.dart';

enum ScreenState { logoPage, community, getToLKnow, ownEvents }

class LoggedOut extends StatelessWidget {
  LoggedOut({Key? key, required this.startLoginFlow}) : super(key: key);

  final void Function() startLoginFlow;
  ScreenState _currentState = ScreenState.community;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(child: SizedBox(), flex: 1),
              Expanded(child: MainPicture(), flex: 6),
              Expanded(child: SizedBox(), flex: 2),
              Expanded(child: WitchSidePoints(), flex: 1),
              Expanded(
                  child: StyledButtonLarge(
                      text: 'Jetzt loslegen',
                      color: Colors.blueGrey,
                      callback: startLoginFlow),
                  flex: 1),
              Expanded(child: SizedBox(), flex: 1),
            ],
          ),
        ),
      ),
    );
  }

  Widget WitchSidePoints() {
    return Column(
      children: [
        Expanded(child: SizedBox(), flex: 3),
        Expanded(
          flex: 1,
          child: Row(
            children: [
              Expanded(child: SizedBox(), flex: 1),
              Icon(
                Icons.brightness_1_rounded,
                color: checkStateForColor(ScreenState.logoPage),
                size: 10,
              ),
              SizedBox(width: 10),
              Icon(
                Icons.brightness_1_rounded,
                color: checkStateForColor(ScreenState.community),
                size: 10,
              ),
              SizedBox(width: 10),
              Icon(
                Icons.brightness_1_rounded,
                color: checkStateForColor(ScreenState.getToLKnow),
                size: 10,
              ),
              SizedBox(width: 10),
              Icon(
                Icons.brightness_1_rounded,
                color: checkStateForColor(ScreenState.ownEvents),
                size: 10,
              ),
              Expanded(child: SizedBox(), flex: 1),
            ],
          ),
        ),
        Expanded(child: SizedBox(), flex: 1),
      ],
    );
  }

  Widget MainPicture() {
    if (_currentState == ScreenState.logoPage) {
      return MaterialButton(
        onPressed: () {},
        color: Colors.red,
      );
    } else {
      return MaterialButton(
        onPressed: () {},
        color: Colors.blue,
      );
    }
  }

  void changeState() {}
  Color? checkStateForColor(ScreenState lol) {
    if (_currentState == lol) {
      return Colors.grey[800];
    } else {
      return Colors.grey[300];
    }
  }
}
