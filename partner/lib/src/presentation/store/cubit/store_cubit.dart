import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'store_state.dart';

class StoreCubit extends Cubit<StoreState> {
  StoreCubit() : super(const StoreState()) {
    _checkStoreExistence();
  }

  Future<void> _checkStoreExistence() async {
    // TODO: Thực hiện kiểm tra từ API hoặc local storage
    // Tạm thời giả định chưa có cửa hàng
    emit(const StoreState(hasStore: false));
  }

  Future<void> createNewStore() async {
    // TODO: Xử lý tạo cửa hàng mới
    // Sau khi tạo thành công:
    // emit(const StoreState(hasStore: true));
  }

  // Thêm các phương thức xử lý logic tại đây
}
