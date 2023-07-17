import 'dart:convert';

import 'package:favorite_places/models/place.dart';
import 'package:favorite_places/screens/map.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;

class LocationInput extends StatefulWidget {
  const LocationInput({super.key, required this.onSelectLocation});

  final void Function(PlaceLocation location) onSelectLocation;
  @override
  State<LocationInput> createState() {
    return _LocationInputState();
  }
}

class _LocationInputState extends State<LocationInput> {
  PlaceLocation? pickedLocation;
  var isGettinLocation = false;

  String get locationImage {
    if (pickedLocation == null) {
      return '';
    }
    final lat = pickedLocation!.latitude;
    final lng = pickedLocation!.longitude;
    return 'https://maps.googleapis.com/maps/api/staticmap?center=$lat,$lng=&zoom=16&size=600x300&maptype=roadmap&markers=color:red%7Clabel:A%7C$lat,$lng&key=AIzaSyAeAnubSynFdzTpRww0N8dvYtZ_W4s5XFM';
  }

  void savedPlace(double latitude, double longitude) async {
    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longitude&key=AIzaSyAeAnubSynFdzTpRww0N8dvYtZ_W4s5XFM');
    final response = await http.get(url);
    final resDtat = json.decode(response.body);
    final address = resDtat['results'][0]['formatted_address'];

    setState(() {
      pickedLocation = PlaceLocation(
          address: address, latitude: latitude, longitude: longitude);
      isGettinLocation = false;
    });
    widget.onSelectLocation(pickedLocation!);
  }

  void getCurrentLocation() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    setState(() {
      isGettinLocation = true;
    });

    locationData = await location.getLocation();
    final lat = locationData.latitude;
    final lng = locationData.longitude;

    if (lat == null || lng == null) {
      return;
    }
    savedPlace(lat, lng);
  }

  void selectOnMap() async {
    final pickedLocation =
        await Navigator.of(context).push<LatLng>(MaterialPageRoute(
      builder: (ctx) => const MapsScreen(),
    ));
    if (pickedLocation == null) {
      return;
    }
    savedPlace(pickedLocation.latitude, pickedLocation.longitude);
  }

  @override
  Widget build(BuildContext context) {
    Widget previewContent = Text(
      'no location choosen',
      textAlign: TextAlign.center,
      style: Theme.of(context)
          .textTheme
          .bodyLarge!
          .copyWith(color: Theme.of(context).colorScheme.onBackground),
    );
    if (pickedLocation != null) {
      previewContent = Image.network(
        locationImage,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      );
    }
    if (isGettinLocation) {
      previewContent = const CircularProgressIndicator();
    }
    return Column(
      children: [
        Container(
          height: 170,
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              border: Border.all(
                  width: 1,
                  color:
                      Theme.of(context).colorScheme.primary.withOpacity(0.2))),
          child: previewContent,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton.icon(
                onPressed: getCurrentLocation,
                icon: const Icon(Icons.location_on),
                label: const Text('Get Current Location')),
            TextButton.icon(
                onPressed: selectOnMap,
                icon: const Icon(Icons.map),
                label: const Text('Select on Map')),
          ],
        )
      ],
    );
  }
}