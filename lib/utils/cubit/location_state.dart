part of 'location_cubit.dart';

@immutable
abstract class LocationState {}

class LocationInitial extends LocationState {}

class GetLocationLoadingState extends LocationState {}

class GetLocationState extends LocationState {
  final Position userPosition;

  GetLocationState(this.userPosition);
}

class InsertLocationLoadingState extends LocationState {}

class InsertSuccesLocationState extends LocationState {
  final Box locationBox;

  InsertSuccesLocationState(this.locationBox);
}

class GetNearbyLocationLoadingState extends LocationState {}

class GetNearbyLocationSuccesState extends LocationState {
  List<Results> results;
  Iterable<Results> nearbyCurrentLocation;
  GetNearbyLocationSuccesState(this.results, this.nearbyCurrentLocation);
}

class CheckIsLocationNearbyLoadingState extends LocationState {}

class CheckIsLocationNearbySuccesState extends LocationState {
  Iterable<Results> results;
  CheckIsLocationNearbySuccesState(this.results);
}
