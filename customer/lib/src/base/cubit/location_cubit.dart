import 'package:app/src/utils/utils.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:latlong2/latlong.dart';

part 'location_state.dart';

LocationCubit get locationCubit => findInstance<LocationCubit>();

class LocationCubit extends Cubit<LocationState> {
  LocationCubit() : super(LocationState());

  void updateLocation(LatLng? location) {
    emit(state.copyWith(currentLocation: location));
  }

  void updateFormattedAddress(String? address) {
    emit(state.copyWith(formattedAddress: address));
   
}
}
