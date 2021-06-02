import 'package:flutter/material.dart';
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
  String _selectedLocation = 'Innenstadt';

  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();

  bool _checkboxSelected = false;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: _selectedDate,
        firstDate: DateTime.now(),
        lastDate: DateTime(2101));

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked =
        await showTimePicker(context: context, initialTime: _selectedTime);

    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: <Widget>[
                    Text('Angebot erstellen',
                        style: Theme.of(context).textTheme.headline1),
                    const SizedBox(height: 8.0),
                    const Divider(height: 0),
                    const SizedBox(height: 16.0),
                    Container(
                      height: 120,
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(
                                'https://www.twopeasandtheirpod.com/wp-content/uploads/2021/03/Veggie-Pizza-8-500x375.jpg'),
                          )),
                    ),
                    const SizedBox(height: 16.0),
                    Form(
                        child: Column(
                      children: <Widget>[
                        StyledTextFormField(
                          hintText: 'Titel',
                          controller: _titleController,
                        ),
                        const SizedBox(height: 8.0),
                        StyledTextFormField(
                          hintText: 'Beschreibung',
                          multiline: true,
                          controller: _descriptionController,
                        ),
                        const SizedBox(height: 8.0),
                        StyledTextFormField(
                          hintText: 'Preis',
                          controller: _priceController,
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
                              child: InkWell(
                                onTap: () => _selectDate(context),
                                child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0, vertical: 16.0),
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(4.0),
                                        border: Border.all(
                                            color:
                                                Colors.black.withOpacity(0.1))),
                                    child: Text(
                                        MaterialLocalizations.of(context)
                                            .formatShortDate(_selectedDate))),
                              ),
                            ),
                            const SizedBox(width: 8.0),
                            Expanded(
                              child: InkWell(
                                onTap: () => _selectTime(context),
                                child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0, vertical: 16.0),
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(4.0),
                                        border: Border.all(
                                            color:
                                                Colors.black.withOpacity(0.1))),
                                    child: Text(
                                        MaterialLocalizations.of(context)
                                            .formatTimeOfDay(_selectedTime))),
                              ),
                            )
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
                            Text(
                              'Lorem ipsum dolor sit amet, consectetur\nadipiscing elit. Donec condimentum velit \nvitae nunc elementum ultricies. Nullam iaculis hendrerit.\nvitae nunc elementum ultricies. Nullam iaculis hendrerit.',
                              style: Theme.of(context).textTheme.bodyText2,
                            )
                          ],
                        ),
                        const SizedBox(height: 16.0),
                        Container(
                            height: 42.0,
                            decoration: const BoxDecoration(
                              color: Colors.amber,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0)),
                            ),
                            child: Center(
                              child: Text(
                                'Angebot erstellen',
                                style: Theme.of(context).textTheme.button,
                              ),
                            )),
                      ],
                    )),
                  ],
                ))));
  }
}
