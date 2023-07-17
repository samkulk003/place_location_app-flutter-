import 'package:favorite_places/models/place.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapsScreen extends StatefulWidget {
  const MapsScreen(
      {super.key,
      this.location = const PlaceLocation(
          address: '', latitude: 37.422, longitude: -122.084),
      this.isSelecting = true});
  final PlaceLocation location;
  final bool isSelecting;
  @override
  State<MapsScreen> createState() {
    return _MapsScreen();
  }
}

class _MapsScreen extends State<MapsScreen> {
  LatLng? pickedLocation;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text(widget.isSelecting ? 'pick your location' : 'Your Location'),
        actions: [
          if (widget.isSelecting)
            IconButton(
              onPressed: () {
                Navigator.of(context).pop(pickedLocation);
              },
              icon: const Icon(Icons.save),
            )
        ],
      ),
      body: GoogleMap(
        onTap: !widget.isSelecting
            ? null
            : (position) {
                setState(() {
                  pickedLocation = position;
                });
              },
        initialCameraPosition: CameraPosition(
            target: LatLng(widget.location.latitude, widget.location.longitude),
            zoom: 16),
        markers: (pickedLocation == null && widget.isSelecting == true)
            ? {}
            : {
                Marker(
                    markerId: const MarkerId('m1'),
                    position: pickedLocation ??
                        LatLng(widget.location.latitude,
                            widget.location.longitude))
              },
      ),
    );
  }
}
