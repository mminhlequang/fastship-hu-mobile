import 'package:internal_core/internal_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internal_network/options.dart';
import 'package:network_resources/network_resources.dart';

import 'src/constants/constants.dart';
import 'src/utils/utils.dart';

void internalSetup() {
  AppSetup.initialized(
    value: AppSetup(
      env: AppEnv.preprod,
      appColors: AppColors.instance,
      appPrefs: AppPrefs.instance,
      appTextStyleWrap: AppTextStyleWrap(
        fontWrap: (textStyle) => GoogleFonts.fredoka(textStyle: textStyle.copyWith(height: 1)),
      ),
      networkOptions: PNetworkOptionsImpl(
        loggingEnable: true,
        baseUrl: apiBaseUrl,
        baseUrlAsset: apiBaseUrl,
        responsePrefixData: 'data',
        // errorInterceptor: (e) {
        //   print(e);
        // },
      ),
    ),
  );
}
