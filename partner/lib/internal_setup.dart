import 'package:internal_core/internal_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internal_network/options.dart';

import 'src/constants/constants.dart';
import 'src/utils/utils.dart';

internalSetup() {
  AppSetup.initialized(
    value: AppSetup(
      env: AppEnv.preprod,
      appColors: AppColors.instance,
      appPrefs: AppPrefs.instance,
      appTextStyleWrap: AppTextStyleWrap(
        fontWrap: (textStyle) =>
            GoogleFonts.fredoka(textStyle: textStyle.copyWith(height: 1)),
      ),
      networkOptions: PNetworkOptionsImpl(
        loggingEnable: true,
        baseUrl: 'https://zennail23.com',
        baseUrlAsset: '',
        responsePrefixData: 'data',
        // errorInterceptor: (e) {
        //   print(e);
        // },
      ),
    ),
  );
}
