part of 'store_registration_cubit.dart';

class StoreRegistrationState extends Equatable {
  final int totalStep1;
  final int currentStep1;
  final int totalStep2;
  final int currentStep2;

  // Lưu thông tin đăng ký cửa hàng
  final int selectedService;
  final bool hasAlcohol;
  final bool acceptTerms;

  // Lưu thông tin từ provide_info_screen
  final Map<String, dynamic> infoStep1;
  final Map<String, dynamic> infoStep2;
  final Map<String, dynamic> infoStep3;

  // Trạng thái làm việc
  final bool isLoading;
  final String? errorMessage;

  const StoreRegistrationState({
    this.totalStep1 = 3,
    this.currentStep1 = 1,
    this.totalStep2 = 3,
    this.currentStep2 = 1,
    this.selectedService = 0,
    this.hasAlcohol = false,
    this.acceptTerms = kDebugMode,
    this.infoStep1 = const {},
    this.infoStep2 = const {},
    this.infoStep3 = const {},
    this.isLoading = false,
    this.errorMessage,
  });

  bool get isEnableServiceContinue =>
      selectedService == 0 ? hasAlcohol != null : true;

  bool get isEnableProvideInfoContinue {
    switch (currentStep2) {
      case 1:
        print('infoStep1: ${infoStep1}');
        return _notNullAndNotEmpty(infoStep1['name'], requiredLength: 5) &&
            _notNullAndNotEmpty(infoStep1['phone'], requiredLength: 10) &&
            infoStep1['address'] != null;
      case 2:
        print('infoStep2: ${infoStep2}');
        var isEnable = false;
        switch (infoStep2['contact_type']) {
          case RepresentativeType.individual:
            isEnable = _notNullAndNotEmpty(infoStep2['contact_full_name'],
                    requiredLength: 5) &&
                _notNullAndNotEmpty(infoStep2['contact_email']) &&
                _notNullAndNotEmpty(infoStep2['contact_phone']) &&
                _notNullAndNotEmpty(infoStep2['contact_card_id'],
                    requiredLength: 6) &&
                infoStep2['contact_card_id_issue_date'] != null &&
                _notNullAndNotEmpty(infoStep2['contact_tax']) &&
                infoStep2['contact_card_id_image_front'] != null &&
                infoStep2['contact_card_id_image_back'] != null &&
                infoStep2['contact_image_license'] != null;
          case RepresentativeType.householdBusiness:
            isEnable = true;
          case RepresentativeType.enterprise:
            isEnable = true;
        }
        print('isEnable: $isEnable');
        return isEnable;
      case 3:
        print('infoStep3: ${infoStep3}');
        return infoStep3['avatar_image'] != null &&
            infoStep3['banner_images'] != null &&
            infoStep3['facade_image'] != null;
      default:
        return true;
    }
  }

  bool _notNullAndNotEmpty(String? value, {int requiredLength = 0}) {
    return value != null && value.isNotEmpty && value.length >= requiredLength;
  }

  StoreRegistrationState copyWith({
    int? totalStep1,
    int? currentStep1,
    int? totalStep2,
    int? currentStep2,
    int? selectedService,
    bool? hasAlcohol,
    bool? acceptTerms,
    Map<String, dynamic>? infoStep1,
    Map<String, dynamic>? infoStep2,
    Map<String, dynamic>? infoStep3,
    bool? isLoading,
  }) {
    return StoreRegistrationState(
      totalStep1: totalStep1 ?? this.totalStep1,
      currentStep1: currentStep1 ?? this.currentStep1,
      totalStep2: totalStep2 ?? this.totalStep2,
      currentStep2: currentStep2 ?? this.currentStep2,
      selectedService: selectedService ?? this.selectedService,
      hasAlcohol: hasAlcohol ?? this.hasAlcohol,
      acceptTerms: acceptTerms ?? this.acceptTerms,
      infoStep1: infoStep1 ?? this.infoStep1,
      infoStep2: infoStep2 ?? this.infoStep2,
      infoStep3: infoStep3 ?? this.infoStep3,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [
        totalStep1,
        currentStep1,
        totalStep2,
        currentStep2,
        selectedService,
        hasAlcohol,
        acceptTerms,
        infoStep1,
        infoStep2,
        infoStep3,
        isLoading,
        errorMessage
      ];
}
