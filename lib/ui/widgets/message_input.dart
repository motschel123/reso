import 'package:flutter/material.dart';
import 'package:reso/ui/widgets/styled_form_elements.dart';

class MessageInput extends StatefulWidget {
  const MessageInput({Key? key, required this.onSendButtonPressed})
      : super(key: key);

  final Future<dynamic> Function(String message)? onSendButtonPressed;

  @override
  State<StatefulWidget> createState() => _MessageInputState();
}

class _MessageInputState extends State<MessageInput> {
  final TextEditingController _messageController = TextEditingController();

  bool sending = false;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
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
              if (sending)
                const CircularProgressIndicator()
              else
                IconButton(
                  onPressed: () async {
                    final String text;
                    if ((text = _messageController.text.trim()).isNotEmpty) {
                      setState(() {
                        sending = true;
                      });
                      widget.onSendButtonPressed?.call(text).whenComplete(() {
                        setState(() {
                          sending = false;
                        });
                        _messageController.clear();
                      });
                    }
                    _messageController.clear();
                  },
                  icon: const Icon(Icons.send),
                )
            ],
          ),
        ));
  }
}
