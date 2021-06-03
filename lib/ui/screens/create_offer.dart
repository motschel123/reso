import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reso/ui/widgets/styled_form_elements.dart';

/// A screen for creating a new offer
class CreateOffer extends StatefulWidget {
  const CreateOffer({Key? key}) : super(key: key);

  @override
  _CreateOfferState createState() => _CreateOfferState();
}

class _CreateOfferState extends State<CreateOffer> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  String _selectedOfferType = 'Produkt';
  String _selectedLocation = 'Kein Ort';

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  final ImagePicker _imagePicker = ImagePicker();
  File? _selectedImage;

  bool _checkboxSelected = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: _selectedDate ?? DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2101));

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
        context: context, initialTime: _selectedTime ?? TimeOfDay.now());

    if (picked != null) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  Future<void> _selectImage(ImageSource source) async {
    final PickedFile? pickedFile = await _imagePicker.getImage(source: source);

    setState(() {
      if (pickedFile != null) {
        _selectedImage = File(pickedFile.path);
        print(_selectedImage);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: SingleChildScrollView(
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: <Widget>[
              Text('Angebot erstellen',
                  style: Theme.of(context).textTheme.headline1),
              const SizedBox(height: 8.0),
              const Divider(height: 0),
              const SizedBox(height: 16.0),
              if (_selectedImage == null)
                Container(
                  height: 120,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                    border: Border.all(color: Theme.of(context).buttonColor),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.camera,
                            color: Theme.of(context).buttonColor),
                        onPressed: () => _selectImage(ImageSource.camera),
                      ),
                      IconButton(
                        icon: Icon(Icons.image,
                            color: Theme.of(context).buttonColor),
                        onPressed: () => _selectImage(ImageSource.gallery),
                      ),
                    ],
                  ),
                ),
              if (_selectedImage != null)
                GestureDetector(
                  onTap: () => _selectImage(ImageSource.gallery),
                  child: Container(
                      height: 120.0,
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8.0)),
                        image: DecorationImage(
                            image: FileImage(_selectedImage!),
                            fit: BoxFit.cover),
                      )),
                ),
              const SizedBox(height: 16.0),
              Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      StyledTextFormField(
                        hintText: 'Titel',
                        controller: _titleController,
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'Titel fehlt';
                          }
                        },
                      ),
                      const SizedBox(height: 8.0),
                      StyledTextFormField(
                        hintText: 'Beschreibung',
                        multiline: true,
                        controller: _descriptionController,
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'Beschreibung fehlt';
                          }
                        },
                      ),
                      const SizedBox(height: 8.0),
                      StyledTextFormField(
                        hintText: 'Preis',
                        controller: _priceController,
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'Preis fehlt';
                          }
                        },
                      ),
                      const SizedBox(height: 16.0),
                      Row(
                        children: <Widget>[
                          Expanded(
                              child: StyledDropdownButtonFormField(
                            items: const <String>[
                              'Produkt',
                              'Veranstaltung',
                              'Gericht',
                              'Dienstleistung'
                            ],
                            value: _selectedOfferType,
                            onChanged: (String? value) {
                              setState(() {
                                _selectedOfferType = value!;
                              });
                            },
                          )),
                          const SizedBox(width: 8.0),
                          Expanded(
                              child: StyledDropdownButtonFormField(
                            items: const <String>[
                              'Kein Ort',
                              'Erlangen Süd',
                              'Innenstadt',
                              'Bruck'
                            ],
                            value: _selectedLocation,
                            onChanged: (String? value) {
                              setState(() {
                                _selectedLocation = value!;
                              });
                            },
                          )),
                        ],
                      ),
                      const SizedBox(height: 8.0),
                      Row(
                        children: <Widget>[
                          Expanded(
                              child: StyledIconButtonSmall(
                            text: _selectedDate != null
                                ? MaterialLocalizations.of(context)
                                    .formatShortDate(_selectedDate!)
                                : 'Datum',
                            icon: Icons.delete,
                            onTap: () => _selectDate(context),
                            iconOnTap: () => <void>{
                              setState(() {
                                _selectedDate = null;
                              })
                            },
                          )),
                          const SizedBox(width: 8.0),
                          Expanded(
                              child: StyledIconButtonSmall(
                                  text: _selectedTime != null
                                      ? MaterialLocalizations.of(context)
                                          .formatTimeOfDay(_selectedTime!)
                                      : 'Uhrzeit',
                                  icon: Icons.delete,
                                  onTap: () => _selectTime(context),
                                  iconOnTap: () => <void>{
                                        setState(() {
                                          _selectedTime = null;
                                        })
                                      })),
                        ],
                      ),
                      const SizedBox(height: 16.0),
                      const Divider(height: 0),
                      const SizedBox(height: 16.0),
                      Row(
                        children: <Widget>[
                          Checkbox(
                              value: _checkboxSelected,
                              onChanged: (bool? value) {
                                setState(() {
                                  _checkboxSelected = value!;
                                });
                              }),
                          Flexible(
                            child: Text(
                              'Lorem ipsum dolor sit amet, consectetur\nadipiscing elit. Donec condimentum velit \nvitae nunc elementum ultricies. Nullam iaculis hendrerit.\nvitae nunc elementum ultricies. Nullam iaculis hendrerit.',
                              style: Theme.of(context).textTheme.bodyText2,
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 16.0),
                      StyledButtonLarge(
                          text: 'Angebot erstellen',
                          color: Colors.amber,
                          disabledColor: Theme.of(context).buttonColor,
                          enabled: _checkboxSelected,
                          callback: () {
                            if (_formKey.currentState!.validate()) {
                              print('Valid input');
                            }
                          }),
                    ],
                  )),
              const SizedBox(height: 16.0),
            ],
          )),
    )));
  }
}
