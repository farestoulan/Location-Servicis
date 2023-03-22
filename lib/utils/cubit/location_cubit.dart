import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hive/hive.dart';
import '../../models/location.dart';
import '../../models/nearby_response.dart';
import '../../my_app.dart';
import '../reusable/show_toast.dart';
import 'package:http/http.dart' as http;

part 'location_state.dart';

class LocationCubit extends Cubit<LocationState> {
  LocationCubit() : super(LocationInitial());
  static LocationCubit get(context) => BlocProvider.of(context);
  late Box locationBox;

  NearbyPlacesResponse nearbyPlacesResponse = NearbyPlacesResponse();

  //=============== Current Lcation ==================

  getCurrentLocation(context) async {
    emit(GetLocationLoadingState());

    try {
      bool serviceEnabled;
      LocationPermission permission;

      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        showToast(
          msg: "Please allow device location",
          context: context,
          width: MediaQuery.of(context).size.width,
        );
        permission = await Geolocator.requestPermission();
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          showToast(
            msg: "Please allow device location",
            context: context,
            width: MediaQuery.of(context).size.width,
          );
          await Geolocator.openLocationSettings();
        }
      }
      if (permission == LocationPermission.deniedForever) {
        await Geolocator.openLocationSettings();
        return Future.error(
            'Location permissions are permanently denied, we cannot request permissions.');
      }

      return await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.high)
          .then((position) async {
        emit(GetLocationState(position));
      });
    } catch (e) {}
    //============================
  }

  // Add info location to location box
  addInfo(double latitude, double longitude) async {
    locationBox = Hive.box('locationBox');

    Location newLocation = Location(
      latitude: latitude,
      longitude: longitude,
    );

    locationBox.add(newLocation);
    print('Info location added to box!');
  }

  insertLocations(context) async {
    emit(InsertLocationLoadingState());
    addInfo(30.550334, 31.0106341);
    addInfo(30.5511479, 31.0062773);
    addInfo(30.5501386, 31.006242);
    addInfo(30.5503794, 31.00681429999999);
    emit(InsertSuccesLocationState(locationBox));
    getCurrentLocation(context);
  }

  void getNearbyPlaces(
      {required latitude,
      required longitude,
      required radius,
      required apiKey}) async {
    emit(GetNearbyLocationLoadingState());
    locationBox = Hive.box('locationBox');

    var url = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=' +
            latitude.toString() +
            ',' +
            longitude.toString() +
            '&radius=' +
            radius +
            '&key=' +
            apiKey);

    var response = await http.post(url);

    nearbyPlacesResponse =
        NearbyPlacesResponse.fromJson(jsonDecode(response.body));
    print(nearbyPlacesResponse.results!.length);

    print(nearbyPlacesResponse.results![4].geometry!.location!.lat);
    print(nearbyPlacesResponse.results![4].geometry!.location!.lng);
    print(nearbyPlacesResponse.results![4].name);

    Iterable<Results> nearbyCurrentLocation = [];

    for (var x = 0; x <= locationBox.length - 1; x++) {
      var localLocation = locationBox.getAt(x) as Location;

      nearbyCurrentLocation = nearbyPlacesResponse.results!.where((element) =>
          element.geometry!.location!.lat == localLocation.latitude &&
          element.geometry!.location!.lng == localLocation.longitude);
      if (nearbyCurrentLocation.isNotEmpty) {
        await notificationService.showNotification(
          id: Random().nextInt(50000),
          body:
              '${nearbyCurrentLocation.first.geometry!.location!.lat} :  ${nearbyCurrentLocation.elementAt(0).geometry!.location!.lng}',
          title: '${nearbyCurrentLocation.first.name}',
        );
      }
    }
    print(nearbyCurrentLocation.length);

    emit(GetNearbyLocationSuccesState(
        nearbyPlacesResponse.results!, nearbyCurrentLocation));
  }
}
