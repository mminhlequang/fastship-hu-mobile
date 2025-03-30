part of 'location_cubit.dart';

class LocationState {
  LatLng? currentLocation;
  HereSearchResult? addressDetail;

  LocationState({this.currentLocation, this.addressDetail});

  LocationState copyWith(
      {LatLng? currentLocation, HereSearchResult? addressDetail}) {
    return LocationState(
      currentLocation: currentLocation ?? this.currentLocation,
      addressDetail: addressDetail ?? this.addressDetail,
    );
  }
}
