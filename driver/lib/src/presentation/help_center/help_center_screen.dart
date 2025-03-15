import 'package:app/src/constants/app_colors.dart';
import 'package:app/src/constants/app_sizes.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:internal_core/internal_core.dart';
import 'package:url_launcher/url_launcher.dart';

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
          ListTile(
            leading: WidgetAppSVG('ic_messenger', width: 32.sw),
            title: const Text('Messenger'),
            trailing: const Icon(Icons.chevron_right),
            visualDensity: const VisualDensity(horizontal: -4),
            onTap: _launchMessenger,
          ),
          const Divider(),
          ListTile(
            leading: WidgetAppSVG('ic_whatsapp', width: 32.sw),
            title: const Text('Whatsapp'),
            trailing: const Icon(Icons.chevron_right),
            visualDensity: const VisualDensity(horizontal: -4),
            onTap: _launchWhatsapp,
          ),
          const Divider(),
          ListTile(
            leading: WidgetAppSVG(
              'sp_hotline',
              width: 32.sw,
              color: appColorPrimary,
            ),
            title: const Text('Hotline'),
            subtitle: const Text('19008028'),
            trailing: const Icon(Icons.chevron_right),
            visualDensity: const VisualDensity(horizontal: -4),
            onTap: _callHotline,
          ),
        ],
      ),
    );
  }
}
