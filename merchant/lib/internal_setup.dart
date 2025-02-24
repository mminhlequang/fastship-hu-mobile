import 'package:internal_core/internal_core.dart';
import 'package:google_fonts/google_fonts.dart';

import 'src/constants/constants.dart';
import 'src/utils/utils.dart';

internalSetup() {
  AppSetup.initialized(
    value: AppSetup(
      env: AppEnv.preprod,
      appColors: AppColors.instance,
      appPrefs: AppPrefs.instance,
      appTextStyleWrap: AppTextStyleWrap(
        fontWrap: (textStyle) => GoogleFonts.poppins(textStyle: textStyle),
      ),
      // networkOptions: PNetworkOptionsImpl(
      //   loggingEnable: kDebugMode,
      //   baseUrl: '',
      //   baseUrlAsset: '',
      //   responsePrefixData: '',
      //   responseIsSuccess: (response) => true,
      //   errorInterceptor: (e) {
      //     print(e);
      //   },
      // ),
    ),
  );
} 