import 'package:flutter/material.dart';

/// A custom styled TextFormField
///
/// The parameters [hintText] and [controller] are required.
///
/// [multiline] controls whether the TextFormField accepts multiple lines of input
/// The keyboardType of the TextFormField can optionally be set with [keyboardType]
/// and the input can be obscured by settings [obscuredText] to true.
class StyledTextFormField extends StatelessWidget {
  const StyledTextFormField(
      {Key? key,
      required this.hintText,
      required this.controller,
      this.multiline = false,
      this.obscureText = false,
      this.keyboardType = TextInputType.text})
      : super(key: key);

  final TextEditingController controller;

  final String hintText;

  final bool multiline, obscureText;

  final TextInputType keyboardType;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      cursorColor: Colors.black.withOpacity(0.5),
      style: Theme.of(context).textTheme.bodyText1,
      maxLines: multiline ? null : 1,
      keyboardType: multiline ? TextInputType.multiline : keyboardType,
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
          hintText: hintText,
          hintStyle: Theme.of(context).textTheme.bodyText2,
          isDense: true,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black.withOpacity(0.5)),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black.withOpacity(0.1)),
          ),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          )),
    );
  }
}

/// A custom styled DropdownButtonFormField
///
/// The parameters [items] and [value] are required and set the available items
/// as well as the currently selected item
///
/// [onChanged] must not be null and is called whenever the selected item changes
class StyledDropdownButtonFormField extends StatelessWidget {
  const StyledDropdownButtonFormField(
      {Key? key,
      required this.items,
      required this.value,
      required this.onChanged})
      : super(key: key);

  final List<String> items;

  final String value;

  final void Function(String?) onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: value,
      icon: Icon(Icons.arrow_drop_down, color: Colors.black.withOpacity(0.1)),
      iconSize: 20,
      elevation: 4,
      style: Theme.of(context).textTheme.bodyText2,
      decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black.withOpacity(0.5)),
          ),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black.withOpacity(0.1))),
          border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(4.0)))),
      onChanged: onChanged,
      items: items.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}

/// A large, custom styled Button
///
/// The parameters [text], [color] and [callback] are required and define the
/// label, background color and onTap callback of the Button
class StyledButtonLarge extends StatelessWidget {
  const StyledButtonLarge(
      {Key? key,
      required this.text,
      required this.color,
      required this.callback})
      : super(key: key);

  final String text;
  final Color color;
  final Function callback;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => callback,
      child: Container(
          height: 42.0,
          decoration: BoxDecoration(
            color: color,
            borderRadius: const BorderRadius.all(Radius.circular(8.0)),
          ),
          child: Center(
            child: Text(
              text,
              style: Theme.of(context).textTheme.button,
            ),
          )),
    );
  }
}
