import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app/src/utils/utils.dart';

part 'home_state.dart';

HomeCubit get homeCubit => findInstance<HomeCubit>();

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  // Thêm các hàm xử lý logic cho màn hình Home
  void fetchHomeData() {
    emit(HomeLoading());

    // TODO: Gọi API hoặc lấy dữ liệu từ local
    // Giả lập dữ liệu thành công
    emit(HomeLoaded());
  }

  void refreshHomeData() {
    // TODO: Thêm logic xử lý làm mới dữ liệu
    fetchHomeData();
  }
}
