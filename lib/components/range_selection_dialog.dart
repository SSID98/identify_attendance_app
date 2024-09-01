import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class RangeSelectionDialog extends StatefulWidget {
  @override
  _RangeSelectionDialogState createState() => _RangeSelectionDialogState();
}

class _RangeSelectionDialogState extends State<RangeSelectionDialog> {
  double _currentRange = 50.0; // Default range in meters
  double? _latitude;
  double? _longitude;

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _showError('Location services are disabled.');
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _showError('Location permissions are denied');
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      _showError(
          'Location permissions are permanently denied, we cannot request permissions.');
      return;
    }

    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      if (!mounted) return; // Check if the widget is still mounted
      setState(() {
        _latitude = position.latitude;
        _longitude = position.longitude;
      });
      print('Lecturer Position: Lat=$_latitude, Lon=$_longitude');
    } catch (e) {
      _showError('Failed to get current location: $e');
    }
  }

  void _showError(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Select Range'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Select range in meters:'),
          Slider(
            value: _currentRange,
            min: 50,
            max: 500,
            divisions: 9,
            label: _currentRange.round().toString(),
            onChanged: (double value) {
              setState(() {
                _currentRange = value;
              });
            },
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            if (_latitude != null && _longitude != null) {
              Navigator.of(context).pop({
                'radius': _currentRange,
                'latitude': _latitude,
                'longitude': _longitude,
              });
            } else {
              _showError('Unable to get current location');
            }
          },
          child: Text('OK'),
        ),
      ],
    );
  }
}
