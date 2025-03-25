part of 'store_registration_cubit.dart';

class StoreRegistrationState extends Equatable {
  final int totalStep;
  final int currentStep;

  // Lưu thông tin đăng ký cửa hàng
  final int selectedService;
  final bool? hasAlcohol;
  final bool acceptTerms;

  // Lưu thông tin từ provide_info_screen
  final Map<String, dynamic> basicInfo;
  final Map<String, dynamic> idCardImages;
  final Map<String, dynamic> detailInfos;

  // Trạng thái làm việc
  final bool isLoading;
  final String? errorMessage;

  const StoreRegistrationState({
    this.totalStep = 3,
    this.currentStep = 1,
    this.selectedService = 0,
    this.hasAlcohol,
    this.acceptTerms = false,
    this.basicInfo = const {},
    this.idCardImages = const {},
    this.detailInfos = const {},
    this.isLoading = false,
    this.errorMessage,
  });

  bool get isEnableServiceContinue =>
      selectedService == 0 ? hasAlcohol != null : true;

  bool get isEnableProvideInfoContinue {
    print('basicInfo: ${basicInfo}');
    switch (currentStep) {
      case 1:
        return _notNullAndNotEmpty(basicInfo['storeName']) &&
            _notNullAndNotEmpty(basicInfo['storePhone']) &&
            basicInfo['storeAddress'] != null;
      case 2:
        return idCardImages['imageIDCardFront'] != null &&
            idCardImages['imageIDCardBack'] != null;
      case 3:
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
    int? totalStep,
    int? currentStep,
    int? selectedService,
    bool? Function()? hasAlcohol,
    bool? acceptTerms,
    Map<String, dynamic>? basicInfo,
    Map<String, dynamic>? idCardImages,
    Map<String, dynamic>? detailInfos,
    bool? isLoading,
    String? Function()? errorMessage,
  }) {
    return StoreRegistrationState(
      totalStep: totalStep ?? this.totalStep,
      currentStep: currentStep ?? this.currentStep,
      selectedService: selectedService ?? this.selectedService,
      hasAlcohol: hasAlcohol != null ? hasAlcohol() : this.hasAlcohol,
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
        totalStep,
        currentStep,
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
