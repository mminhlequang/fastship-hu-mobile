import 'dart:async';

import 'package:app/src/base/auth/auth_cubit.dart';
import 'package:app/src/utils/utils.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import '../widgets/widget_dialog_confirm.dart';
import 'controllers/socket_controller.dart';

class SocketShellWrapper extends StatefulWidget {
  final Widget child;

  const SocketShellWrapper({
    super.key,
    required this.child,
  });

  @override
  State<SocketShellWrapper> createState() => _SocketShellWrapperState();
}

class _SocketShellWrapperState extends State<SocketShellWrapper> {
  @override
  void initState() {
    super.initState();
    if (authCubit.isLoggedIn) {
      socketController.initializeSocket();
    }
    FirebaseCloudMessaging.initFirebaseMessaging();
  }

  @override
  void dispose() {
    super.dispose();
    socketController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
