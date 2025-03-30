part of 'location_cubit.dart';

class LocationState {
  LatLng? currentLocation;
  String? formattedAddress;

  LocationState({this.currentLocation, this.formattedAddress});

  LocationState copyWith({LatLng? currentLocation, String? formattedAddress}) {
    return LocationState(
      currentLocation: currentLocation ?? this.currentLocation,
      formattedAddress: formattedAddress ?? this.formattedAddress,
    );
  }
}
