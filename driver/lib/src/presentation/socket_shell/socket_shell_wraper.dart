import 'package:app/src/constants/constants.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:internal_core/internal_core.dart';
import 'package:permission_handler/permission_handler.dart';

import 'controllers/socket_controller.dart';

class SocketShellWrapper extends StatefulWidget {
  final Widget child;
  const SocketShellWrapper({super.key, required this.child});

  @override
  State<SocketShellWrapper> createState() => _SocketShellWrapperState();
}

class _SocketShellWrapperState extends State<SocketShellWrapper> {
  @override
  void initState() {
    super.initState();
    socketController.init();
  }

  @override
  void dispose() {
    socketController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
