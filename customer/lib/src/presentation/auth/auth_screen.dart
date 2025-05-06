import 'dart:math';

import 'package:app/src/base/auth/auth_cubit.dart';
import 'package:app/src/constants/constants.dart';
import 'package:app/src/presentation/widgets/widgets.dart';
import 'package:app/src/utils/utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internal_core/internal_core.dart';
import 'package:internal_network/options.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:network_resources/auth/repo.dart';
import 'package:network_resources/network_resources.dart';
import 'package:url_launcher/url_launcher.dart';

import '../widgets/widget_infinity_slider.dart';
import 'widgets/widget_otp.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  PhoneNumber? phoneNumber;
  bool isPhoneNumberValid = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 380,
              child: WidgetCarouselImages(is4Column: false),
            ),
            _buildHeaderText(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: InternationalPhoneNumberInput(
                spaceBetweenSelectorAndTextField: 12,
                keyboardType: TextInputType.phone,
                formatInput: true,
                keyboardAction: TextInputAction.done,
                cursorColor: appColorText,
                countries: ["VN"] +
                    euroCounries.map((e) => e['code'].toString()).toList(),
                selectorConfig: SelectorConfig(
                  bgColor: Colors.white,
                  selectorTextStyle: w500TextStyle(fontSize: 16),
                ),
                builderTextField: (child) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Number phone'.tr(),
                      style: w400TextStyle(
                        fontSize: 14.sw,
                        color: const Color(0xFFB6AFAE),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 52.sw,
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xFFF1EFE9)),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: child,
                    ),
                  ],
                ),
                builderButtonSelector: (child) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Country',
                      style: TextStyle(
                        fontSize: 14,
                        color: const Color(0xFFB6AFAE),
                        letterSpacing: 0.14,
                        fontFamily: GoogleFonts.fredoka().fontFamily,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 52.sw,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF4F4F4),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: child,
                    ),
                  ],
                ),
                onInputChanged: (PhoneNumber number) {
                  appHaptic();
                  setState(() {
                    phoneNumber = number;
                  });
                },
                onInputValidated: (bool isValid) {
                  setState(() {
                    isPhoneNumberValid = isValid;
                  });
                },
                onSubmit: () {
                  if (isPhoneNumberValid) {
                    pushWidget(
                      child: PhoneVerificationScreen(
                        phoneNumber: phoneNumber!,
                      ),
                    );
                  }
                },
                textStyle: w400TextStyle(fontSize: 16.sw),
                inputDecoration: InputDecoration(
                  isDense: true,
                  isCollapsed: true,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 12.sw, vertical: 8.sw),
                  filled: true,
                  fillColor: appColorBackground,
                  hintText: '87 878 7878',
                  hintStyle: w400TextStyle(
                    fontSize: 16.sw,
                    color: const Color(0xFF8A8C91),
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(8.sw),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: WidgetButtonConfirm(
                onPressed: () {
                  appHaptic();
                  pushWidget(
                    child: PhoneVerificationScreen(
                      phoneNumber: phoneNumber!,
                    ),
                  );
                },
                isEnabled: isPhoneNumberValid,
                text: "Continue".tr(),
              ),
            ),
            _buildSocialLoginSection(),
            _buildTermsSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderText() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Column(
        children: [
          GestureDetector(
            onDoubleTap: () async {
              final response = await AuthRepo().login({
                'password': '123456',
                'phone': '+84979797979',
                'type': 1,
              });

              if (response.isSuccess) {
                await AppPrefs.instance.saveAccountToken(response.data!);
                authCubit.load(
                  delayRedirect: const Duration(seconds: 2),
                );

                // Xử lý đăng ký thành công
                appShowSnackBar(
                    msg: 'Register success, redirecting to home...',
                    context: context,
                    type: AppSnackBarType.success);
              } else {
                // Xử lý lỗi
                appShowSnackBar(
                    msg: response.msg ?? 'Register failed, please try again!',
                    type: AppSnackBarType.error);
              }
            },
            child: Text(
              'Your Favorite Food Delivery Partner'.tr(),
              style: w700TextStyle(
                fontSize: 33,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'We are the fastest and most popular delivery service across the city.'
                .tr(),
            style: w400TextStyle(
              fontSize: 18,
              color: const Color(0xFF847D79),
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSocialLoginSection() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: Divider(color: const Color(0xFFF8F1F0))),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  'Or',
                  style: TextStyle(
                    fontSize: 14,
                    color: const Color(0xFFB6AFAE),
                    fontFamily: GoogleFonts.fredoka().fontFamily,
                  ),
                ),
              ),
              Expanded(child: Divider(color: const Color(0xFFF8F1F0))),
            ],
          ),
          const SizedBox(height: 12),
          // Row(
          //   children: [
          //     Expanded(
          //       child: _buildSocialButton(
          //         'Google',
          //         Icons.g_mobiledata,
          //       ),
          //     ),
          //     const SizedBox(width: 8),
          //     Expanded(
          //       child: _buildSocialButton(
          //         'Apple',
          //         Icons.apple,
          //       ),
          //     ),
          //   ],
          // ),
          // const SizedBox(height: 12),
          WidgetInkWellTransparent(
            onTap: () {
              appHaptic();
              clearAllRouters('/');
            },
            enableInkWell: false,
            child: Text(
              'Continue as a guest'.tr(),
              style: w500TextStyle(
                fontSize: 18,
                color: appColorPrimary,
                decoration: TextDecoration.underline,
                decorationColor: appColorPrimary,
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  // Widget _buildSocialButton(String text, IconData icon) {
  //   return Container(
  //     padding: const EdgeInsets.symmetric(vertical: 12),
  //     decoration: BoxDecoration(
  //       border: Border.all(color: const Color(0xFFF1EFE9)),
  //       borderRadius: BorderRadius.circular(62),
  //     ),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: [
  //         Icon(icon),
  //         const SizedBox(width: 12),
  //         Text(
  //           text,
  //           style: TextStyle(
  //             fontSize: 16,
  //             color: const Color(0xFF303030),
  //             fontFamily: GoogleFonts.fredoka().fontFamily,
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildTermsSection() {
    return Padding(
      padding: EdgeInsets.fromLTRB(
          16, 12, 16, 12 + MediaQuery.of(context).padding.bottom),
      child: RichText(
        text: TextSpan(
          style: w400TextStyle(),
          children: [
            TextSpan(
              text: 'When continue, you agree to our '.tr(),
              style: w400TextStyle(color: appColorText2),
            ),
            TextSpan(
              text: 'terms and conditions'.tr(),
              style: w500TextStyle(color: appColorPrimaryOrange),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  appHaptic();
                  launchUrl(Uri.parse(
                      "${appBaseUrl!}/terms-and-conditions")); // TODO: change to terms and conditions
                },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSignalIcon() {
    return Row(
      children: List.generate(
        4,
        (index) => Container(
          margin: const EdgeInsets.only(right: 2),
          width: 3,
          height: (index + 1) * 3.0,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _buildBatteryIcon() {
    return Container(
      width: 25,
      height: 12,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(3),
      ),
      child: Row(
        children: [
          Container(
            margin: const EdgeInsets.all(2),
            width: 18,
            color: Colors.black,
          ),
          Container(
            width: 2,
            height: 8,
            margin: const EdgeInsets.only(left: 1),
            color: Colors.black,
          ),
        ],
      ),
    );
  }
}

class WidgetCarouselImages extends StatelessWidget {
  final bool is4Column;
  const WidgetCarouselImages({super.key, this.is4Column = true});

  //length collection
  int get _count => 5;

  Widget _buildColumn(
      {int column = 1, Duration duration = const Duration(milliseconds: 60)}) {
    return WidgetInfinitySlider(
      duration: duration,
      scrollDirection: Axis.vertical,
      child: Column(
        children: List.generate(
          _count - 1,
          (index) => Padding(
            padding: EdgeInsets.only(bottom: 12.sw),
            child: _WidgetImageAsset(
              prefix: "welcome_${column}_",
              index: index,
              radius: 16.sw,
              height: is4Column ? 145.sw : 172.sw,
              boxShadow: const [],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Row(
          children: [
            Gap(16.sw),
            Expanded(
              child: _buildColumn(
                  column: 1, duration: const Duration(milliseconds: 60)),
            ),
            Gap(12.sw),
            Expanded(
              child: _buildColumn(
                  column: 2, duration: const Duration(milliseconds: 45)),
            ),
            Gap(12.sw),
            Expanded(
              child: _buildColumn(
                  column: 1, duration: const Duration(milliseconds: 120)),
            ),
            // if (is4Column) ...[
            //   Gap(12.sw),
            //   Expanded(
            //     child: _buildColumn(
            //         column: 1, duration: const Duration(milliseconds: 85)),
            //   ),
            // ],
            Gap(16.sw),
          ],
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          height: 100.sw,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                Colors.white,
                Colors.white.withOpacity(.8),
                Colors.white.withOpacity(.35),
                Colors.white.withOpacity(.00001),
              ], begin: Alignment.bottomCenter, end: Alignment.topCenter),
            ),
          ),
        )
      ],
    );
  }
}

int _randomSizeInRange(int min, int max) => min + Random().nextInt(max - min);

class _WidgetImageAsset extends StatelessWidget {
  final String prefix;
  final int index;
  final double? height;
  final double radius;
  final List<BoxShadow>? boxShadow;
  const _WidgetImageAsset({
    required this.index,
    this.height,
    required this.radius,
    this.boxShadow,
    required this.prefix,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
              "assets/images/jpg/$prefix${index == 0 ? 5 : index}.jpg"),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.circular(radius),
        boxShadow: boxShadow ??
            [
              BoxShadow(
                  color: Colors.black.withOpacity(.3),
                  blurRadius: 12.sw,
                  offset: Offset(5.sw, 5.sw))
            ],
      ),
    );
  }
}
