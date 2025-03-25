import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:app/src/utils/app_prefs.dart';
import 'package:app/src/network_resources/auth/models/models.dart';

part 'store_registration_state.dart';

class StoreRegistrationCubit extends Cubit<StoreRegistrationState> {
  StoreRegistrationCubit() : super(const StoreRegistrationState());

  // Các hàm quản lý các bước của store_registration_screen
  void updateSelectedService(int service) {
    emit(state.copyWith(selectedService: service));
  }

  void updateHasAlcohol(bool value) {
    emit(state.copyWith(hasAlcohol: () => value));
  }

  void updateAcceptTerms(bool value) {
    emit(state.copyWith(acceptTerms: value));
  }

  void nextStep() {
    if (state.currentStep < state.totalStep) {
      emit(state.copyWith(currentStep: state.currentStep + 1));
    }
  }

  void previousStep() {
    if (state.currentStep > 1) {
      emit(state.copyWith(currentStep: state.currentStep - 1));
    }
  }

  // Các hàm quản lý các bước của provide_info_screen
  void updatePersonalInfo(Map<String, dynamic> data) {
    emit(state.copyWith(basicInfo: {...state.basicInfo, ...data}));
  }

  void updateIdCardImages(Map<String, dynamic> data) {
    emit(state.copyWith(idCardImages: {...state.idCardImages, ...data}));
  }

  void updateDetailInfo(Map<String, dynamic> data) {
    emit(state.copyWith(detailInfos: {...state.detailInfos, ...data}));
  }

  // Thêm các hàm tiện ích nếu cần thiết
  bool isStoreDetailComplete() {
    return state.detailInfos['avatarImage'] != null &&
        state.detailInfos['coverImage'] != null &&
        state.detailInfos['facadeImage'] != null &&
        state.detailInfos['openingTime'] != null &&
        state.detailInfos['serviceType'] != null &&
        (state.detailInfos['cuisines'] ?? []).isNotEmpty &&
        (state.detailInfos['featuredProducts'] ?? []).isNotEmpty;
  }

  // Các hàm xử lý API
  Future<bool> submitStoreRegistration() async {
    emit(state.copyWith(isLoading: true, errorMessage: () => null));

    try {
      // Xử lý upload ảnh CCCD
      String? urlImage_cccd_before;
      String? urlImage_cccd_after;
      String? urlImage_license_before;
      String? urlImage_license_after;

      try {
        // Đây là phần code upload ảnh, hiện đang được comment trong file gốc
        // Khi có thông tin về MerchantRepo(), có thể uncomment và sử dụng

        /*
        final futures = await Future.wait([
          if (state.idCardImages['imageIDCardFront'] != null)
            MerchantRepo().uploadFile(
                (state.idCardImages['imageIDCardFront'] as XFile).path, 
                'image_cccd_before'),
          if (state.idCardImages['imageIDCardBack'] != null)
            MerchantRepo().uploadFile(
                (state.idCardImages['imageIDCardBack'] as XFile).path, 
                'image_cccd_after'),
          if (state.idCardImages['imageDrivingLicenseFront'] != null)
            MerchantRepo().uploadFile(
                (state.idCardImages['imageDrivingLicenseFront'] as XFile).path, 
                'image_license_before'),
          if (state.idCardImages['imageDrivingLicenseBack'] != null)
            MerchantRepo().uploadFile(
                (state.idCardImages['imageDrivingLicenseBack'] as XFile).path, 
                'image_license_after'),
        ]);
        
        // Lưu URL của các ảnh đã upload
        int index = 0;
        if (state.idCardImages['imageIDCardFront'] != null) {
          if (futures[index].isSuccess) {
            urlImage_cccd_before = futures[index].data;
          }
          index++;
        }
        if (state.idCardImages['imageIDCardBack'] != null) {
          if (futures[index].isSuccess) {
            urlImage_cccd_after = futures[index].data;
          }
          index++;
        }
        if (state.idCardImages['imageDrivingLicenseFront'] != null) {
          if (futures[index].isSuccess) {
            urlImage_license_before = futures[index].data;
          }
          index++;
        }
        if (state.idCardImages['imageDrivingLicenseBack'] != null) {
          if (futures[index].isSuccess) {
            urlImage_license_after = futures[index].data;
          }
        }
        */
      } catch (e) {
        emit(state.copyWith(
          isLoading: false,
          errorMessage: () => 'Error uploading image: $e',
        ));
        return false;
      }

      // Chuẩn bị dữ liệu từ các bước
      final Map<String, dynamic> requestData = {
        // Thông tin cửa hàng
        'service_type': state.selectedService,
        'has_alcohol': state.hasAlcohol,

        // Thông tin cá nhân
        'name': state.basicInfo['fullName'],
        'sex': state.basicInfo['gender'],
        'birthday': state.basicInfo['birthday'] != null
            ? (state.basicInfo['birthday'] as DateTime).toString().split(' ')[0]
            : null,
        'address': state.basicInfo['address'] != null
            ? state.basicInfo['address'].address
            : null,

        // Thông tin CCCD
        'image_cccd_before': urlImage_cccd_before,
        'image_cccd_after': urlImage_cccd_after,

        // Thông tin giấy phép lái xe
        'image_license_before': urlImage_license_before,
        'image_license_after': urlImage_license_after,

        // Liên hệ khẩn cấp
        'contacts': jsonEncode(state.detailInfos['emergencyContacts'] ?? []),

        'step_id': 2,
      };

      // Gọi API cập nhật thông tin - được comment trong file gốc
      /*
      final response = await MerchantRepo().updateProfile(requestData);
      
      if (response.isSuccess) {
        // Cập nhật thông tin người dùng
        AccountModel user = AppPrefs.instance.user!;
        user.profile!.stepId = 2;
        AppPrefs.instance.user = user;
        
        emit(state.copyWith(isLoading: false));
        return true;
      } else {
        emit(state.copyWith(
          isLoading: false,
          errorMessage: () => response.msg,
        ));
        return false;
      }
      */

      // Vì API đang comment nên tạm thời luôn trả về true trong môi trường debug
      if (kDebugMode) {
        emit(state.copyWith(isLoading: false));
        return true;
      } else {
        emit(state.copyWith(
          isLoading: false,
          errorMessage: () => 'API implementation pending',
        ));
        return false;
      }
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: () => 'Error updating profile: $e',
      ));
      return false;
    }
  }
}
