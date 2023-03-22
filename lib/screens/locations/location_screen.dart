import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_demo/utils/cubit/location_cubit.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../models/location.dart';
import '../../my_app.dart';
import 'nearby_places_screen.dart';

class LocationScreen extends StatefulWidget {
  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  late final Box locationBox;
  double latitude = 0;
  double longitude = 0;
  // late final Box locations;

  // Add info location to location box
  _addInfo(double latitude, double longitude) async {
    Location newLocation = Location(
      latitude: latitude,
      longitude: longitude,
    );

    locationBox.add(newLocation);
    print(locationBox.values);
    print('Info location added to box!');
  }

  @override
  void initState() {
    super.initState();

    locationBox = Hive.box('locationBox');
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LocationCubit(),
      child: BlocConsumer<LocationCubit, LocationState>(
        listener: (context, state) async {
          if (state is InsertSuccesLocationState) {
            locationBox = state.locationBox;
          }
          if (state is GetLocationState) {
            latitude = state.userPosition.altitude;
            longitude = state.userPosition.longitude;
            print(locationBox.length);
            await notificationService.showNotification(
              id: Random().nextInt(50000),
              body: '$latitude : $longitude',
              title: 'Current Location',
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text('locations'),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => NearByPlacesScreen(
                        latitude: latitude, longitude: longitude),
                  ),
                );
              },
              child: Icon(Icons.add),
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  ElevatedButton(
                      onPressed: () {
                        LocationCubit.get(context).insertLocations(context);
                      },
                      child: const Text("Get Local Locations")),
                  if (locationBox.isNotEmpty)
                    for (int i = 0; i < locationBox.length; i++)
                      localLocationsWidget(i)
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget localLocationsWidget(int index) {
    var localLocation = locationBox.getAt(index) as Location;
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          Text("Location: " +
              localLocation.latitude.toString() +
              " , " +
              localLocation.longitude.toString()),
        ],
      ),
    );
  }
}
