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
  final Map<String, dynamic> basicInfo;
  final Map<String, dynamic> idCardImages;
  final Map<String, dynamic> detailInfos;

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
    this.basicInfo = const {},
    this.idCardImages = const {},
    this.detailInfos = const {},
    this.isLoading = false,
    this.errorMessage,
  });

  bool get isEnableServiceContinue =>
      selectedService == 0 ? hasAlcohol != null : true;

  bool get isEnableProvideInfoContinue {
    switch (currentStep2) {
      case 1:
        print('basicInfo: ${basicInfo}');
        return _notNullAndNotEmpty(basicInfo['storeName']) &&
            _notNullAndNotEmpty(basicInfo['storePhone']) &&
            basicInfo['storeAddress'] != null;
      case 2:
        var isEnable = false;
        switch (idCardImages['type']) {
          case RepresentativeType.personal:
            isEnable = _notNullAndNotEmpty(idCardImages['name']) &&
                _notNullAndNotEmpty(idCardImages['email']) &&
                _notNullAndNotEmpty(idCardImages['phoneNumber']) &&
                _notNullAndNotEmpty(idCardImages['id']) &&
                idCardImages['issueDate'] != null &&
                _notNullAndNotEmpty(idCardImages['taxCode']) &&
                idCardImages['imageIDCardFront'] != null &&
                idCardImages['imageIDCardBack'] != null &&
                idCardImages['imageBusinessLicense'] != null;
          case RepresentativeType.householdBusiness:
            isEnable = true;
          case RepresentativeType.enterprise:
            isEnable = true;
        }
        return isEnable;
      case 3:
        print('detailInfos: ${detailInfos}');
        return detailInfos['avatarImage'] != null &&
            detailInfos['coverImage'] != null &&
            detailInfos['facadeImage'] != null;
      default:
        return true;
    }
  }

  bool _notNullAndNotEmpty(String? value) {
    return value != null && value.isNotEmpty;
  }

  StoreRegistrationState copyWith({
    int? totalStep1,
    int? currentStep1,
    int? totalStep2,
    int? currentStep2,
    int? selectedService,
    bool? hasAlcohol,
    bool? acceptTerms,
    Map<String, dynamic>? basicInfo,
    Map<String, dynamic>? idCardImages,
    Map<String, dynamic>? detailInfos,
    bool? isLoading,
    String? Function()? errorMessage,
  }) {
    return StoreRegistrationState(
      totalStep1: totalStep1 ?? this.totalStep1,
      currentStep1: currentStep1 ?? this.currentStep1,
      totalStep2: totalStep2 ?? this.totalStep2,
      currentStep2: currentStep2 ?? this.currentStep2,
      selectedService: selectedService ?? this.selectedService,
      hasAlcohol: hasAlcohol ?? this.hasAlcohol,
      acceptTerms: acceptTerms ?? this.acceptTerms,
      basicInfo: basicInfo ?? this.basicInfo,
      idCardImages: idCardImages ?? this.idCardImages,
      detailInfos: detailInfos ?? this.detailInfos,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
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
        basicInfo,
        idCardImages,
        detailInfos,
        isLoading,
        errorMessage
      ];
}
