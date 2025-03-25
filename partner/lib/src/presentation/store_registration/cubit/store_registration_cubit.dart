import 'dart:convert';

import 'package:app/src/base/auth/auth_cubit.dart';
import 'package:app/src/network_resources/store/repo.dart';
import 'package:app/src/presentation/widgets/widgets.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:internal_core/internal_core.dart';

import '../widgets/widget_form_profile_2.dart';

part 'store_registration_state.dart';

class StoreRegistrationCubit extends Cubit<StoreRegistrationState> {
  StoreRegistrationCubit() : super(const StoreRegistrationState());

  // Các hàm quản lý các bước của store_registration_screen
  void updateSelectedService(int service) {
    emit(state.copyWith(selectedService: service));
  }

  void updateHasAlcohol(bool value) {
    emit(state.copyWith(hasAlcohol: value));
  }

  void updateAcceptTerms(bool value) {
    emit(state.copyWith(acceptTerms: value));
  }

  void nextStep1() {
    if (state.currentStep1 < state.totalStep1) {
      emit(state.copyWith(currentStep1: state.currentStep1 + 1));
    }
  }

  void previousStep1() {
    if (state.currentStep1 > 1) {
      emit(state.copyWith(currentStep1: state.currentStep1 - 1));
    }
  }

  void nextStep2() {
    if (state.currentStep2 < state.totalStep2) {
      emit(state.copyWith(currentStep2: state.currentStep2 + 1));
    }
  }

  void previousStep2() {
    if (state.currentStep2 > 1) {
      emit(state.copyWith(currentStep2: state.currentStep2 - 1));
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

  // Các hàm xử lý API
  Future<bool> submitStoreRegistration() async {
    emit(state.copyWith(isLoading: true, errorMessage: () => null));

    try {
      // Xử lý upload ảnh
      String? urlImage_cccd_before;
      String? urlImage_cccd_after;
      String? urlImage_license;
      String? urlImage_relatedDocument;

      String? urlImage_avatar;
      String? urlImage_cover;
      String? urlImage_facade;

      try {
        final futures = await Future.wait([
          if (state.idCardImages['imageIDCardFront'] != null)
            StoreRepo().uploadImage(
                (state.idCardImages['imageIDCardFront'] as XFile).path,
                'image_cccd_before'),
          if (state.idCardImages['imageIDCardBack'] != null)
            StoreRepo().uploadImage(
                (state.idCardImages['imageIDCardBack'] as XFile).path,
                'image_cccd_after'),
          if (state.idCardImages['imageBusinessLicense'] != null)
            StoreRepo().uploadImage(
                (state.idCardImages['imageBusinessLicense'] as XFile).path,
                'image_license_before'),
          if (state.idCardImages['imageRelatedDocument'] != null)
            StoreRepo().uploadImage(
                (state.idCardImages['imageRelatedDocument'] as XFile).path,
                'image_license_after'),
          if (state.detailInfos['avatarImage'] != null)
            StoreRepo().uploadImage(
                (state.detailInfos['avatarImage'] as XFile).path,
                'image_avatar'),
          if (state.detailInfos['coverImage'] != null)
            StoreRepo().uploadImage(
                (state.detailInfos['coverImage'] as XFile).path, 'image_cover'),
          if (state.detailInfos['facadeImage'] != null)
            StoreRepo().uploadImage(
                (state.detailInfos['facadeImage'] as XFile).path,
                'image_facade'),
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
        if (state.idCardImages['imageBusinessLicense'] != null) {
          if (futures[index].isSuccess) {
            urlImage_license = futures[index].data;
          }
          index++;
        }
        if (state.idCardImages['imageRelatedDocument'] != null) {
          if (futures[index].isSuccess) {
            urlImage_relatedDocument = futures[index].data;
          }
        }

        if (state.detailInfos['avatarImage'] != null) {
          if (futures[index].isSuccess) {
            urlImage_avatar = futures[index].data;
          }
        }

        if (state.detailInfos['coverImage'] != null) {
          if (futures[index].isSuccess) {
            urlImage_cover = futures[index].data;
          }
        }

        if (state.detailInfos['facadeImage'] != null) {
          if (futures[index].isSuccess) {
            urlImage_facade = futures[index].data;
          }
        }
      } catch (e) {
        emit(state.copyWith(
          isLoading: false,
          errorMessage: () => 'Error uploading image: $e',
        ));
        return false;
      }

      HereSearchResult? _selectedAddress = state.basicInfo['storeAddress'];

      final requestData = {
        "name": state.basicInfo['storeName'],
        "type": "individual",
        "company": "Công ty A",
        "phone": state.basicInfo['storePhone'],
        "phone_contact": state.idCardImages['phoneNumber'],
        "email": state.idCardImages['email'],
        "cccd": state.idCardImages['id'],
        "cccd_date": (state.idCardImages['issueDate'] as DateTime)
            .formatDate(formatType: 'yyyy-MM-dd'),
        "image": urlImage_avatar,
        "banner": urlImage_cover,
        "image_cccd_before": urlImage_cccd_before,
        "image_cccd_after": urlImage_cccd_after,
        "image_license": urlImage_license,
        "images": [urlImage_relatedDocument, urlImage_facade],
        "tax_code": state.detailInfos['taxCode'],
        "support_service_id": 1,
        "support_service_additional_ids": [1],
        "business_type_ids": [1, 2, 3],
        "category_ids": [1, 2, 3],
        "operating_hours": [
          {
            "day": 7,
            "hours": ["10:00", "15:00"]
          }
        ],
        "address": _selectedAddress?.address?.label,
        "lat": _selectedAddress?.position?.lat,
        "lng": _selectedAddress?.position?.lng,
        "street": _selectedAddress?.address?.street,
        "zip": _selectedAddress?.address?.postalCode,
        "city": _selectedAddress?.address?.city,
        "state": _selectedAddress?.address?.state,
        "country": _selectedAddress?.address?.countryName,
        "country_code": _selectedAddress?.address?.countryCode,
      };

      final response = await StoreRepo().createStore(requestData);

      if (response.isSuccess) {
        authCubit.fetchStores(isRedirect: true);

        emit(state.copyWith(isLoading: false));
        return true;
      } else {
        emit(state.copyWith(
          isLoading: false,
          errorMessage: () => response.msg,
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
