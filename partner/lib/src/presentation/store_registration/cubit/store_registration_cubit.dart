import 'dart:convert';
import 'dart:math';

import 'package:app/src/base/auth/auth_cubit.dart';
import 'package:app/src/constants/constants.dart';
import 'package:app/src/network_resources/models/opening_time_model.dart';
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
    emit(state.copyWith(infoStep1: {...state.infoStep1, ...data}));
  }

  void updateIdCardImages(Map<String, dynamic> data) {
    emit(state.copyWith(infoStep2: {...state.infoStep2, ...data}));
  }

  void updateDetailInfo(Map<String, dynamic> data) {
    emit(state.copyWith(infoStep3: {...state.infoStep3, ...data}));
  }

  // Các hàm xử lý API
  Future<void> submitStoreRegistration(ValueNotifier<String> processor) async {
    processor.value = 'loading';
    emit(state.copyWith(isLoading: true));

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
          if (state.infoStep2['contact_card_id_image_front'] != null)
            StoreRepo().uploadImage(
                (state.infoStep2['contact_card_id_image_front'] as XFile).path,
                'image_cccd_before'),
          if (state.infoStep2['contact_card_id_image_back'] != null)
            StoreRepo().uploadImage(
                (state.infoStep2['contact_card_id_image_back'] as XFile).path,
                'image_cccd_after'),
          if (state.infoStep2['contact_image_license'] != null)
            StoreRepo().uploadImage(
                (state.infoStep2['contact_image_license'] as XFile).path,
                'image_license_before'),
          if (state.infoStep2['contact_documents'] != null)
            StoreRepo().uploadImage(
                (state.infoStep2['contact_documents'] as XFile).path,
                'image_license_after'),
          if (state.infoStep3['avatar_image'] != null)
            StoreRepo().uploadImage(
                (state.infoStep3['avatar_image'] as XFile).path,
                'image_avatar'),
          if (state.infoStep3['banner_images'] != null)
            StoreRepo().uploadImage(
                (state.infoStep3['banner_images'] as XFile).path,
                'image_cover'),
          if (state.infoStep3['facade_image'] != null)
            StoreRepo().uploadImage(
                (state.infoStep3['facade_image'] as XFile).path,
                'image_facade'),
        ]);

        // Lưu URL của các ảnh đã upload
        int index = 0;
        if (state.infoStep2['contact_card_id_image_front'] != null) {
          if (futures[index].isSuccess) {
            urlImage_cccd_before = futures[index].data;
          }
          index++;
        }
        if (state.infoStep2['contact_card_id_image_back'] != null) {
          if (futures[index].isSuccess) {
            urlImage_cccd_after = futures[index].data;
          }
          index++;
        }
        if (state.infoStep2['contact_image_license'] != null) {
          if (futures[index].isSuccess) {
            urlImage_license = futures[index].data;
          }
          index++;
        }
        if (state.infoStep2['contact_documents'] != null) {
          if (futures[index].isSuccess) {
            urlImage_relatedDocument = futures[index].data;
          }
        }

        if (state.infoStep3['avatar_image'] != null) {
          if (futures[index].isSuccess) {
            urlImage_avatar = futures[index].data;
          }
        }

        if (state.infoStep3['banner_images'] != null) {
          if (futures[index].isSuccess) {
            urlImage_cover = futures[index].data;
          }
        }

        if (state.infoStep3['facade_image'] != null) {
          if (futures[index].isSuccess) {
            urlImage_facade = futures[index].data;
          }
        }
      } catch (e) {
        print('Error uploading image: $e');
        emit(state.copyWith(
          isLoading: false         ));
        processor.value = 'error';
      }

      HereSearchResult? _selectedAddress = state.infoStep1['address'];

      final requestData = {
        "name": state.infoStep1['name'],
        "phone": state.infoStep1['phone'],
        "support_service_id": serviceTypeFoodDelivery,
        "support_service_additional_ids": [],
        "business_type_ids": state.infoStep3['business_type_ids'] ?? [],
        "category_ids": state.infoStep3['category_ids'] ?? [],
        "operating_hours":
            (state.infoStep3['operating_hours'] as List<OpeningTimeModel>?)
                ?.map((e) => {
                      "is_off": e.isOpen ? 0 : 1,
                      "day": e.dayNumber,
                      "hours": [e.openTime, e.closeTime]
                    })
                .toList(),
        "address": _selectedAddress?.address?.label,
        "lat": _selectedAddress?.position?.lat,
        "lng": _selectedAddress?.position?.lng,
        "street": _selectedAddress?.address?.street,
        "zip": _selectedAddress?.address?.postalCode,
        "city": _selectedAddress?.address?.city,
        "state": _selectedAddress?.address?.state,
        "country": _selectedAddress?.address?.countryName,
        "country_code": _selectedAddress?.address?.countryCode,
        "contact_phone": state.infoStep2['contact_phone'],
        "contact_email": state.infoStep2['contact_email'],
        "contact_card_id": state.infoStep2['contact_card_id'],
        "contact_card_id_issue_date":
            (state.infoStep2['contact_card_id_issue_date'] as DateTime)
                .formatDate(formatType: 'yyyy-MM-dd'),
        "avatar_image": urlImage_avatar,
        "banner_images": [urlImage_cover],
        "contact_card_id_image_front": urlImage_cccd_before,
        "contact_card_id_image_back": urlImage_cccd_after,
        "license_image": urlImage_license,
        "facade_image": urlImage_facade,
        "related_documents": [urlImage_relatedDocument],
        "tax_code": state.infoStep3['contact_tax'],
      };

      final response = await StoreRepo().createStore(requestData);

      if (response.isSuccess) {
        authCubit.fetchStores(isRedirect: true);

        emit(state.copyWith(isLoading: false));
        processor.value = 'success';
      } else {
        emit(state.copyWith(
          isLoading: false         ));
        processor.value = 'error';
      }
    } catch (e) {
      print('Error updating profile: $e');
      emit(state.copyWith(
        isLoading: false
      ));
      processor.value = 'error';
    }
  }
}
