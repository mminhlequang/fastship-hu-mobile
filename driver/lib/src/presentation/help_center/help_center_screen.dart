import 'package:flutter/material.dart';
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
      appBar: AppBar(
        title: const Text('Trung tâm hỗ trợ'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: Image.asset(
              'assets/images/messenger.png',
              width: 32,
              height: 32,
            ),
            title: const Text('Messenger'),
            trailing: const Icon(Icons.chevron_right),
            onTap: _launchMessenger,
          ),
          const Divider(),
          ListTile(
            leading: Image.asset(
              'assets/images/whatsapp.png',
              width: 32,
              height: 32,
            ),
            title: const Text('Whatsapp'),
            trailing: const Icon(Icons.chevron_right),
            onTap: _launchWhatsapp,
          ),
          const Divider(),
          ListTile(
            leading: const Icon(
              Icons.phone,
              size: 32,
              color: Colors.green,
            ),
            title: const Text('Hotline'),
            subtitle: const Text('19008028'),
            trailing: const Icon(Icons.chevron_right),
            onTap: _callHotline,
          ),
        ],
      ),
    );
  }
}
