import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_image/firebase_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reso/business_logic/services/offer_service.dart';
import 'package:reso/model/offer.dart';
import 'package:reso/ui/widgets/styled_form_elements.dart';

/// A screen for creating a new offer
class CreateOffer extends StatefulWidget {
  const CreateOffer({Key? key, this.editingOffer}) : super(key: key);

  final Offer? editingOffer;

  @override
  _CreateOfferState createState() => _CreateOfferState();
}

class _CreateOfferState extends State<CreateOffer> {
  @override
  void initState() {
    super.initState();
    if (widget.editingOffer != null) {
      final Offer _offer = widget.editingOffer!;

      _titleController.text = _offer.title;
      _descriptionController.text = _offer.description;
      _priceController.text = _offer.price;

      _selectedOfferType = _offer.type;
      _selectedLocation = _offer.location ?? 'Kein Ort';

      if (_offer.dateCreated != null) {
        _selectedDate = _offer.dateCreated;
        _selectedTime =
            TimeOfDay(hour: _selectedDate!.hour, minute: _selectedDate!.minute);
      }
    }
  }

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  OfferType _selectedOfferType = OfferType.product;
  String _selectedLocation = 'Kein Ort';

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  final ImagePicker _imagePicker = ImagePicker();
  File? _selectedImage;

  bool _checkboxSelected = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _createOrUpdateOffer(BuildContext context) {
    DateTime? dateTime;

    // Combine selected time and date into one DateTime object if both are set
    if (_selectedDate != null && _selectedTime != null) {
      dateTime = DateTime(_selectedDate!.year, _selectedDate!.month,
          _selectedDate!.day, _selectedTime!.hour, _selectedTime!.minute);
    } else if (_selectedTime != null) {
      // Default to current date
      final DateTime now = DateTime.now();
      dateTime = DateTime(now.year, now.month, now.day, _selectedTime!.hour,
          _selectedTime!.minute);
    }

    if (widget.editingOffer == null) {
      createOffer(
        _titleController.text,
        _descriptionController.text,
        _priceController.text,
        _selectedOfferType,
        successCallback: () {
          Navigator.of(context).pop();
        },
        errorCallback: (FirebaseException e) {
          print('Error creating offer, error: ${e.message}');
        },
        image: _selectedImage,
        location: _selectedLocation,
      );
    } else {
      // Todo(motschel123): Update values of existing offer
      updateOffer(
          widget.editingOffer!,
          _titleController.text,
          _descriptionController.text,
          _priceController.text,
          _selectedOfferType, successCallback: () {
        Navigator.of(context).pop();
      }, errorCallback: (FirebaseException e) {
        print('Error creating offer, error: ${e.message}');
      },
          image: _selectedImage,
          location: _selectedLocation,
          dateEvent: dateTime ?? _selectedDate);
    }
  }

  // TODO(motschel123): Implement delete Offer method
  void _deleteOffer(BuildContext context) {
    deleteOffer(widget.editingOffer!,
        successCallback: () => Navigator.of(context).pop(),
        errorCallback: (FirebaseException e) {
          print('Error deleting offer, error: ${e.message}');
        });
  }

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
    final XFile? xFile = await _imagePicker.pickImage(source: source);

    setState(() {
      if (xFile != null) {
        _selectedImage = File(xFile.path);
        print(_selectedImage);
      } else {
        print('No image selected.');
      }
    });
  }

  Widget _buildImageSelection(BuildContext context) {
    if (_selectedImage != null) {
      return GestureDetector(
        onTap: () => _selectImage(ImageSource.gallery),
        child: Container(
            height: 240.0,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(8.0)),
              image: DecorationImage(
                  image: FileImage(_selectedImage!), fit: BoxFit.cover),
            )),
      );
    } else if (widget.editingOffer?.imageRef != null) {
      return GestureDetector(
        onTap: () => _selectImage(ImageSource.gallery),
        child: Container(
            height: 240.0,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(8.0)),
              image: DecorationImage(
                  image: FirebaseImage(widget.editingOffer!.imageRef!),
                  fit: BoxFit.cover),
            )),
      );
    } else {
      return Container(
        height: 120,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(8.0)),
          border: Border.all(color: Theme.of(context).buttonColor),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.camera, color: Theme.of(context).buttonColor),
              onPressed: () => _selectImage(ImageSource.camera),
            ),
            IconButton(
              icon: Icon(Icons.image, color: Theme.of(context).buttonColor),
              onPressed: () => _selectImage(ImageSource.gallery),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: SingleChildScrollView(
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                  widget.editingOffer == null
                      ? 'Angebot erstellen'
                      : 'Angebot bearbeiten',
                  style: Theme.of(context).textTheme.headline1),
              const SizedBox(height: 8.0),
              const Divider(height: 0),
              const SizedBox(height: 16.0),
              _buildImageSelection(context),
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
                              child: StyledDropdownButtonFormField<OfferType>(
                            items: OfferType.values,
                            value: _selectedOfferType,
                            onChanged: (OfferType? value) {
                              setState(() {
                                _selectedOfferType = value!;
                              });
                            },
                            toDisplayString: (OfferType value) {
                              return value.toDisplayString;
                            },
                          )),
                          const SizedBox(width: 8.0),
                          Expanded(
                              child: StyledDropdownButtonFormField<String>(
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
                              child: StyledTextIconButtonSmall(
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
                              child: StyledTextIconButtonSmall(
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
                          text: widget.editingOffer == null
                              ? 'Angebot erstellen'
                              : 'Angebot bearbeiten',
                          color: Colors.amber,
                          disabledColor: Theme.of(context).buttonColor,
                          enabled: _checkboxSelected,
                          callback: () {
                            if (_formKey.currentState!.validate()) {
                              _createOrUpdateOffer(context);
                            }
                          }),
                      if (widget.editingOffer != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: StyledButtonLarge(
                              text: 'Angebot löschen',
                              color: Colors.red,
                              callback: () {
                                if (_formKey.currentState!.validate()) {
                                  _deleteOffer(context);
                                }
                              }),
                        ),
                    ],
                  )),
              const SizedBox(height: 16.0),
            ],
          )),
    )));
  }
}
