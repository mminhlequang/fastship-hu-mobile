import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app/src/utils/utils.dart';

part 'account_state.dart';

AccountCubit get accountCubit => findInstance<AccountCubit>();

class AccountCubit extends Cubit<AccountState> {
  AccountCubit() : super(AccountInitial());

  // Thêm các hàm xử lý logic cho màn hình Account
  void fetchUserProfile() {
    emit(AccountLoading());

    // TODO: Gọi API hoặc lấy dữ liệu từ local
    // Giả lập dữ liệu thành công
    emit(AccountLoaded());
  }

  void updateUserProfile(Map<String, dynamic> userData) {
    // TODO: Thêm logic xử lý cập nhật thông tin người dùng
  }

  void logout() {
    // TODO: Thêm logic xử lý đăng xuất
  }
}
