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
        fontWrap: (textStyle) => GoogleFonts.inter(textStyle: textStyle),
      ),
      networkOptions: PNetworkOptionsImpl(
        loggingEnable: true,
        baseUrl: 'https://zennail23.com',
        baseUrlAsset: '',
        responsePrefixData: 'data',
        responseIsSuccess: (response) =>
            response.statusCode == 200 || response.statusCode == 201,
        // errorInterceptor: (e) {
        //   print(e);
        // },
      ),
    ),
  );
}
