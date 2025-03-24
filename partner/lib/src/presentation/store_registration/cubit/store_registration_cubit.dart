import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'store_registration_state.dart';

class StoreRegistrationCubit extends Cubit<StoreRegistrationState> {
  StoreRegistrationCubit() : super(StoreRegistrationState());
}
