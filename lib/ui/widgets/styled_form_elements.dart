import 'package:flutter/material.dart';

/// A custom styled TextFormField
///
/// The parameters [hintText] and [controller] are required.
///
/// [multiline] controls whether the TextFormField accepts multiple lines of input
/// The keyboardType of the TextFormField can optionally be set with [keyboardType]
/// and the input can be obscured by settings [obscuredText] to true.
///
/// The input of the TextFormField can optionally be validated by passing a function
/// to [validator] and an icon can be added by passing it to [suffixIcon].
class StyledTextFormField extends StatelessWidget {
  const StyledTextFormField(
      {Key? key,
      required this.hintText,
      required this.controller,
      this.multiline = false,
      this.obscureText = false,
      this.keyboardType = TextInputType.text,
      this.validator,
      this.suffixIcon})
      : super(key: key);

  final TextEditingController controller;

  final String hintText;

  final bool multiline, obscureText;

  final TextInputType keyboardType;

  final String? Function(String?)? validator;

  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        style: Theme.of(context).textTheme.bodyText1,
        maxLines: multiline ? null : 1,
        minLines: multiline ? 3 : 1,
        keyboardType: multiline ? TextInputType.multiline : keyboardType,
        controller: controller,
        obscureText: obscureText,
        validator: validator,
        decoration: InputDecoration(
          suffixIcon: suffixIcon,
          hintText: hintText,
          hintStyle: Theme.of(context).textTheme.bodyText2,
        ));
  }
}

/// A custom styled DropdownButtonFormField
///
/// The parameters [items] and [value] are required and set the available items
/// as well as the currently selected item
///
/// [onChanged] must not be null and is called whenever the selected item changes
///
/// The input of the DropdownButton can optionally be validated by passing a
/// funciton to [validator]
class StyledDropdownButtonFormField<T> extends StatelessWidget {
  const StyledDropdownButtonFormField(
      {Key? key,
      required this.items,
      required this.value,
      required this.onChanged,
      this.validator,
      this.toDisplayString})
      : super(key: key);

  final List<T> items;

  final T value;

  final void Function(T?) onChanged;

  final String? Function(T?)? validator;

  final String Function(T)? toDisplayString;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      value: value,
      icon: Icon(Icons.arrow_drop_down, color: Colors.black.withOpacity(0.1)),
      iconSize: 20,
      elevation: 4,
      style: Theme.of(context).textTheme.bodyText2,
      validator: validator,
      decoration: const InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      ),
      onChanged: onChanged,
      items: items.map<DropdownMenuItem<T>>((T value) {
        return DropdownMenuItem<T>(
          value: value,
          child: Text(toDisplayString == null
              ? value.toString()
              : toDisplayString!(value)),
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
      required this.callback,
      this.enabled = true,
      this.disabledColor = Colors.grey})
      : super(key: key);

  final String text;
  final Color color;
  final Color disabledColor;
  final void Function()? callback;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: enabled ? callback : null,
        child: AnimatedContainer(
          curve: Curves.easeInOut,
          duration: const Duration(milliseconds: 200),
          child: Container(
              height: 42.0,
              decoration: BoxDecoration(
                color: enabled ? color : disabledColor,
                borderRadius: const BorderRadius.all(Radius.circular(8.0)),
              ),
              child: Center(
                child: Text(
                  text,
                  style: Theme.of(context).textTheme.button,
                ),
              )),
        ));
  }
}

/// Small Button with suffix icon
///
/// The parameters [text] and [icon] set the text and icon of the button and
/// callbacks for both can be set using [onTap] and [iconOnTap].
class StyledIconButtonSmall extends StatelessWidget {
  const StyledIconButtonSmall(
      {Key? key,
      required this.text,
      required this.icon,
      required this.borderColor,
      required this.onTap,
      required this.iconOnTap})
      : super(key: key);

  final String text;

  final Icon icon;
  final Color borderColor;

  final void Function()? onTap;
  final void Function()? iconOnTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4.0),
              border: Border.all(color: borderColor)),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Text(text),
                ),
              ),
              GestureDetector(onTap: iconOnTap, child: icon),
            ],
          )),
    );
  }
}
