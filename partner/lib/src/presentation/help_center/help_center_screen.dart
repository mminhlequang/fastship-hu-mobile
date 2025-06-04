import 'package:app/src/constants/app_colors.dart';
import 'package:app/src/constants/app_sizes.dart';
import 'package:app/src/constants/constants.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:internal_core/internal_core.dart';
import 'package:network_resources/network_resources.dart';
import 'package:url_launcher/url_launcher.dart';

import '../widgets/widgets.dart';

class HelpCenterScreen extends StatelessWidget {
  const HelpCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Help Center'.tr())),
      body: ListView(
        children: [
          _buildItem(
            'Messenger',
            appMessengerUrl,
            'ic_messenger',
            () {
              launchUrl(Uri.parse(appMessengerUrl));
            },
            null,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: AppDivider(),
          ),
          _buildItem(
            'WhatsApp',
            appWhatsappUrl,
            'ic_whatsapp',
            () {
              launchUrl(Uri.parse(appWhatsappUrl));
            },
            null,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: AppDivider(),
          ),
          _buildItem(
            'Hotline',
            supportPhoneNumber,
            'sp_hotline',
            () {
              launchUrl(Uri.parse('tel:$supportPhoneNumber'));
            },
            supportPhoneNumber,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: AppDivider(),
          ),
          _buildItem(
            'Privacy Policy',
            privacyPolicyUrl,
            'legal-system1',
            () {
              launchUrl(Uri.parse(privacyPolicyUrl));
            },
            null,
            true,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: AppDivider(),
          ),
          _buildItem(
            'Terms of Service',
            termsOfServiceUrl,
            'legal-system2',
            () {
              launchUrl(Uri.parse(termsOfServiceUrl));
            },
            null,
            true,
          ),
        ],
      ),
    );
  }

  Widget _buildItem(String title, String value, String icon, Function() onTap,
      String? description,
      [isPng = false]) {
    return WidgetRippleButton(
      onTap: () {
        appHaptic();
        onTap.call();
      },
      radius: 0,
      child: Padding(
        padding: EdgeInsets.all(16.sw),
        child: Row(
          children: [
            isPng
                ? WidgetAssetImage.png(icon, width: 24.sw)
                : WidgetAppSVG(
                    icon,
                    width: 24.sw,
                  ),
            Gap(8.sw),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: w400TextStyle(fontSize: 16.sw),
                  ),
                  if (description != null) ...[
                    Gap(2.sw),
                    Text(
                      description,
                      style: w400TextStyle(color: grey9),
                    ),
                  ],
                ],
              ),
            ),
            const Spacer(),
            const WidgetAppSVG('chevron_right'),
          ],
        ),
      ),
    );
  }
}
