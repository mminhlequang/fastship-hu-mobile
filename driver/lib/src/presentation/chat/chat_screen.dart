import 'package:app/src/constants/app_sizes.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:internal_core/internal_core.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User_1234'.tr()),
        actions: [
          IconButton(
            icon: WidgetAppSVG('ic_phone'),
            onPressed: () {
              // Todo:
            },
          ),
          Gap(4.sw),
        ],
      ),
    );
  }
}
