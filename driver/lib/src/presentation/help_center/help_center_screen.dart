import 'package:app/src/constants/app_colors.dart';
import 'package:app/src/constants/app_sizes.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:internal_core/internal_core.dart';
import 'package:url_launcher/url_launcher.dart';

import '../widgets/widgets.dart';

class HelpCenterScreen extends StatelessWidget {
  const HelpCenterScreen({super.key});

  void _launchMessenger() async {
    final Uri url = Uri.parse('https://m.me/fastship');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  void _launchWhatsapp() async {
    final Uri url = Uri.parse('https://wa.me/84123456789');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  void _callHotline() async {
    final Uri url = Uri.parse('tel:19008028');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Help Center'.tr())),
      body: ListView(
        children: [
          WidgetRippleButton(
            onTap: _launchMessenger,
            radius: 0,
            child: Padding(
              padding: EdgeInsets.all(16.sw),
              child: Row(
                children: [
                  WidgetAppSVG('ic_messenger', width: 24.sw),
                  Gap(8.sw),
                  Text(
                    'Messenger',
                    style: w400TextStyle(fontSize: 16.sw),
                  ),
                  const Spacer(),
                  const WidgetAppSVG('chevron_right'),
                ],
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: AppDivider(),
          ),
          WidgetRippleButton(
            onTap: _launchWhatsapp,
            radius: 0,
            child: Padding(
              padding: EdgeInsets.all(16.sw),
              child: Row(
                children: [
                  WidgetAppSVG('ic_whatsapp', width: 24.sw),
                  Gap(8.sw),
                  Text(
                    'WhatsApp',
                    style: w400TextStyle(fontSize: 16.sw),
                  ),
                  const Spacer(),
                  const WidgetAppSVG('chevron_right'),
                ],
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: AppDivider(),
          ),
          WidgetRippleButton(
            onTap: _callHotline,
            radius: 0,
            child: Padding(
              padding: EdgeInsets.all(16.sw),
              child: Row(
                children: [
                  WidgetAppSVG(
                    'sp_hotline',
                    width: 24.sw,
                    color: appColorPrimary,
                  ),
                  Gap(8.sw),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hotline',
                          style: w400TextStyle(fontSize: 16.sw),
                        ),
                        Gap(2.sw),
                        Text(
                          '19008028',
                          style: w400TextStyle(color: grey9),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  const WidgetAppSVG('chevron_right'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
