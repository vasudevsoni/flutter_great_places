import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/place.dart';
import '../widgets/image_input.dart';
import '../providers/places.dart';
import '../widgets/location_input.dart';

class AddPlaceScreen extends StatefulWidget {
  static const routeName = '/add-place';
  const AddPlaceScreen({Key key}) : super(key: key);

  @override
  State<AddPlaceScreen> createState() => _AddPlaceScreenState();
}

class _AddPlaceScreenState extends State<AddPlaceScreen> {
  final _titleController = TextEditingController();
  File _pickedImage;
  PlaceLocation _pickedLocation;
  bool _isLoading = false;

  void _selectImage(File pickedImage) {
    _pickedImage = pickedImage;
  }

  void _selectPlace(double lat, double lon) {
    _pickedLocation = PlaceLocation(latitude: lat, longitude: lon);
  }

  void _savePlace() {
    if (_titleController.text.isEmpty ||
        _pickedImage == null ||
        _pickedLocation == null) {
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all details to add this place'),
        ),
      );
    } else {
      setState(() {
        _isLoading = true;
      });
      Provider.of<GreatPlaces>(context, listen: false)
          .addPlace(_titleController.text, _pickedImage, _pickedLocation);
      setState(() {
        _isLoading = false;
      });
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    TextField(
                      decoration: const InputDecoration(labelText: 'title'),
                      controller: _titleController,
                    ),
                    ImageInput(onSelectImage: _selectImage),
                    const SizedBox(
                      height: 10,
                    ),
                    LocationInput(onSelectPlace: _selectPlace),
                  ],
                ),
              ),
            ),
            ElevatedButton(
              onPressed: _isLoading ? null : _savePlace,
              child: _isLoading
                  ? const Text('Adding place. Hold on...')
                  : const Text('Add place'),
            ),
          ],
        ),
      ),
    );
  }
}
