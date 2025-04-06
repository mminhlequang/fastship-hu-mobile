import 'package:app/src/constants/constants.dart';
import 'package:app/src/presentation/widgets/widget_appbar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appColorBackground,
      body: Column(
        children: [
          WidgetAppBar(
            title: 'Notification'.tr(),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Today section
                _buildSection(
                  title: 'Today',
                  notifications: [
                    _buildNotificationItem(
                      icon: Icons.local_offer,
                      iconColor: const Color(0xFFFFAB17),
                      title: '30% Special Discount!',
                      subtitle: 'Special promotion only valid today',
                      isUnread: true,
                    ),
                    _buildNotificationItem(
                      icon: Icons.delivery_dining,
                      iconColor: const Color(0xFF52A533),
                      title: 'Your Order Has Been Taken by the Driver',
                      subtitle: 'Recently',
                      isUnread: true,
                    ),
                    _buildNotificationItem(
                      icon: Icons.cancel,
                      iconColor: const Color(0xFFFB4069),
                      title: 'Your Order Has Been Canceled',
                      subtitle: '19 Jun 2023',
                      isUnread: true,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Yesterday section
                _buildSection(
                  title: 'Yesterday',
                  notifications: [
                    _buildNotificationItem(
                      icon: Icons.message,
                      iconColor: const Color(0xFF848484),
                      title: '35% Special Discount!',
                      subtitle: 'Special promotion only valid today',
                    ),
                    _buildNotificationItem(
                      icon: Icons.person,
                      iconColor: const Color(0xFF848484),
                      title: 'Account Setup Successfull!',
                      subtitle: 'Special promotion only valid today',
                    ),
                    _buildNotificationItem(
                      icon: Icons.local_offer,
                      iconColor: const Color(0xFFFB4069),
                      title: 'Special Offer! 60% Off',
                      subtitle:
                          'Special offer for new account, valid until 20 Nov 2022',
                    ),
                    _buildNotificationItem(
                      icon: Icons.credit_card,
                      iconColor: const Color(0xFFF17228),
                      title: 'Credit Card Connected',
                      subtitle: 'Special promotion only valid today',
                    ),
                    _buildNotificationItem(
                      icon: Icons.credit_card,
                      iconColor: const Color(0xFFF17228),
                      title: 'Credit Card Connected',
                      subtitle: 'Special promotion only valid today',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> notifications,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF878787),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: notifications,
          ),
        ),
      ],
    );
  }

  Widget _buildNotificationItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    bool isUnread = false,
  }) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF121212),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF848484),
                      ),
                    ),
                  ],
                ),
              ),
              if (isUnread)
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF17228),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFFF48E53).withOpacity(0.2),
                      width: 3,
                    ),
                  ),
                ),
            ],
          ),
        ),
        const Divider(height: 1),
      ],
    );
  }
}
