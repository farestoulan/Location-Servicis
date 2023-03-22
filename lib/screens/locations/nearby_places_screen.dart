import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/nearby_response.dart';
import '../../my_app.dart';
import '../../utils/cubit/location_cubit.dart';

class NearByPlacesScreen extends StatefulWidget {
  double latitude;

  double longitude;
  NearByPlacesScreen(
      {Key? key, required this.latitude, required this.longitude})
      : super(key: key);

  @override
  State<NearByPlacesScreen> createState() => _NearByPlacesScreenState();
}

class _NearByPlacesScreenState extends State<NearByPlacesScreen> {
  String apiKey = "AIzaSyDbtJ1dV_G9nvMNo_Eh2PMRZgJR7tgUvm8";
  String radius = "100";
  List<Results> results = [];
  Iterable<Results> nearbyCurrentLocation = [];

  // double latitude;
  // //30.55056;
  // // 31.5111093;
  // //30.6213191;
  // double longitude;
  //31.00638;
  // 74.279664;
  //30.8993719;

  NearbyPlacesResponse nearbyPlacesResponse = NearbyPlacesResponse();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LocationCubit(),
      child: BlocConsumer<LocationCubit, LocationState>(
        listener: (context, state) async {
          if (state is GetNearbyLocationSuccesState) {
            results = state.results;
            nearbyCurrentLocation = state.nearbyCurrentLocation;
            // if (nearbyCurrentLocation.isNotEmpty) {
            //   await notificationService.showNotification(
            //     id: Random().nextInt(50000),
            //     body:
            //         '${results[0].geometry!.location!.lat} :  ${results[0].geometry!.location!.lng}',
            //     title: '${results[0].name}',
            //   );
            // } else {
            //   await notificationService.showNotification(
            //     id: Random().nextInt(50000),
            //     body: 'Noooo',
            //     title: 'Noooo',
            //   );
            // }
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Nearby Places'),
              centerTitle: true,
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  ElevatedButton(
                      onPressed: () {
                        LocationCubit.get(context).getNearbyPlaces(
                            latitude: 30.55056,
                            longitude: 31.00638,
                            radius: radius,
                            apiKey: apiKey);
                      },
                      child: const Text("Get Nearby Places")),
                  if (results.isNotEmpty)
                    for (int i = 0; i < results.length; i++)
                      nearbyPlacesWidget(results[i])
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget nearbyPlacesWidget(Results results) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          Text("Name: " + results.name!),
          Text("Location: " +
              results.geometry!.location!.lat.toString() +
              " , " +
              results.geometry!.location!.lng.toString()),
          Text(results.openingHours != null ? "Open" : "Closed"),
        ],
      ),
    );
  }
}
