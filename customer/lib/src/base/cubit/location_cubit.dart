import 'package:app/src/presentation/widgets/widget_search_place_builder.dart';
import 'package:app/src/utils/utils.dart';
import 'package:bloc/bloc.dart';
import 'package:latlong2/latlong.dart';

part 'location_state.dart';

LocationCubit get locationCubit => findInstance<LocationCubit>();

class LocationCubit extends Cubit<LocationState> {
  LocationCubit() : super(LocationState());

  double? get latitude => state.currentLocation?.latitude;
  double? get longitude => state.currentLocation?.longitude;
  String? get addressDetail => state.addressDetail?.title;
  String? get countryCode => state.addressDetail?.address?.countryCode;

  void updateLocation(LatLng? location) {
    emit(state.copyWith(currentLocation: location));
  }

  void updateAddressDetail(HereSearchResult? address) {
    var deliveryAddresses = AppPrefs.instance.deliveryAddresses;
    deliveryAddresses.removeWhere((element) =>
        element.position!.lat == address!.position!.lat &&
        element.position!.lng == address.position!.lng);
    deliveryAddresses.add(address!);
    AppPrefs.instance.deliveryAddresses = deliveryAddresses;
    emit(state.copyWith(addressDetail: address));
  }
}
