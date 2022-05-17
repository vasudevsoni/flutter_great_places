import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:location/location.dart';

import '../helpers/location_helper.dart';

class LocationInput extends StatefulWidget {
  final Function onSelectPlace;
  const LocationInput({
    Key key,
    @required this.onSelectPlace,
  }) : super(key: key);

  @override
  State<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  String _previewImageUrl;
  bool _isLoading = false;

  Future<void> _getCurrentUserLocation() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final locData = await Location().getLocation();
      final previewUrl = LocationHelper.generateLocationPreviewImage(
        latitude: locData.latitude,
        longitude: locData.longitude,
      );
      setState(() {
        _isLoading = false;
        _previewImageUrl = previewUrl;
      });
      widget.onSelectPlace(locData.latitude, locData.longitude);
    } catch (error) {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          alignment: Alignment.center,
          height: 200,
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: Colors.grey,
            ),
          ),
          child: _previewImageUrl == null
              ? const Text(
                  'No Location Chosen',
                  textAlign: TextAlign.center,
                )
              : Image.network(
                  _previewImageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
        ),
        TextButton.icon(
          onPressed: _isLoading ? null : _getCurrentUserLocation,
          icon: Icon(Ionicons.location_outline),
          label:
              _isLoading ? Text('Hold on...') : Text('Pick current location'),
        ),
      ],
    );
  }
}
