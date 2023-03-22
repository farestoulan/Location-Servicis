import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapSample extends StatefulWidget {
  const MapSample({Key? key}) : super(key: key);

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  var markers = HashSet<Marker>();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(30.6212804, 30.8992876),
    zoom: 14.4746,
  );

  static const CameraPosition _kLake = CameraPosition(
      // bearing: 0,
      // tilt: 0,
      bearing: 192.8334901395799,
      target: LatLng(30.6212804, 30.8992876),
      tilt: 59.440717697143555,
      //  zoom: 11.0);
      zoom: 19.151926040649414);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        mapType: MapType.hybrid,
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          setState(() {
            markers.add(
              Marker(
                markerId: MarkerId('1'),
                position: LatLng(30.6212804, 30.8992876),
              ),
            );
          });
          _controller.complete(controller);
        },
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        trafficEnabled: true,
        markers: markers,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToTheLake,
        label: const Text('To the lake!'),
        icon: const Icon(Icons.directions_boat),
      ),
    );
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }
}
