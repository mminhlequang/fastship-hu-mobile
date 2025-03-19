import 'package:app/src/constants/app_sizes.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:internal_core/internal_core.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:flutter/material.dart';

import '../presentation/widgets/widgets.dart';
import 'utils.dart';
// import 'dart:html' as html;

// setFriendlyRouteName({required String title, required String url}) {
//   html.document.title = title;
//   html.window.history.pushState(null, title, url);
// }

bool appIsBottomSheetOpen = false;
Future<T> appOpenBottomSheet<T>(
  Widget child, {
  bool isDismissible = true,
  bool enableDrag = true,
  Color? backgroundColor,
}) async {
  appIsBottomSheetOpen = true;
  var r = await showMaterialModalBottomSheet(
    enableDrag: enableDrag,
    context: appContext,
    builder: (_) => Padding(
      padding: MediaQuery.viewInsetsOf(_),
      child: child,
    ),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    isDismissible: isDismissible,
    backgroundColor: backgroundColor ?? Colors.white,
    useRootNavigator: true,
  );
  appIsBottomSheetOpen = false;
  return r;
}

bool appIsDialogOpen = false;
appOpenDialog(Widget child, {bool barrierDismissible = true}) async {
  appIsDialogOpen = true;
  var r = await showGeneralDialog(
    barrierLabel: "popup",
    barrierColor: Colors.black.withValues(alpha: .5),
    barrierDismissible: barrierDismissible,
    transitionDuration: const Duration(milliseconds: 300),
    context: appContext,
    pageBuilder: (context, anim1, anim2) {
      return child;
    },
    transitionBuilder: (context, anim1, anim2, child) {
      return SlideTransition(
        position: Tween(begin: const Offset(0, 1), end: const Offset(0, 0))
            .animate(anim1),
        child: child,
      );
    },
  );
  appIsDialogOpen = false;
  return r;
}

appHideKeyboard() {
  FocusManager.instance.primaryFocus?.unfocus();
}

appChangedTheme() {
  AppPrefs.instance.themeModel = AppPrefs.instance.isDarkTheme
      ? AppPrefsBase.themeModeLightKey
      : AppPrefsBase.themeModeDarkKey;
  WidgetsBinding.instance.performReassemble();
}

appCatchLog(e) {
  appDebugPrint('[catchLog] $e');
}

enum AppSnackBarType { error, success, notitfication }

appShowSnackBar({
  context,
  required msg,
  Duration? duration,
  AppSnackBarType type = AppSnackBarType.notitfication,
}) {
  Color color;
  Duration duration;

  switch (type) {
    case AppSnackBarType.error:
      color = Colors.red;
      duration = const Duration(seconds: 6);
      break;
    case AppSnackBarType.success:
      color = Colors.green;
      duration = const Duration(seconds: 3);
      break;
    case AppSnackBarType.notitfication:
      color = Colors.blue;
      duration = const Duration(seconds: 4);
      break;
  }

  ScaffoldMessenger.of(context ?? appContext).showSnackBar(
    SnackBar(
      content: Text(
        msg,
        style: w400TextStyle(color: Colors.white, fontSize: 16.sw),
      ),
      duration: duration,
      backgroundColor: color,
    ),
  );
}

bool isImageByMime(type) {
  switch (type) {
    case 'image/jpeg':
    case 'image/png':
      return true;
    default:
      return false;
  }
}

Future<void> appOpenDateTimePicker(
  DateTime? date,
  Function(DateTime date) onConfirm, {
  title,
  type = DateTimePickerType.date,
}) async {
  date ??= DateTime.now();
  final rs = await appOpenBottomSheet(
    WidgetDateTimePicker(
      type: type,
      initialDateTime: date,
    ),
    enableDrag: false,
    backgroundColor: Colors.transparent,
  );
  if (rs is DateTime) {
    onConfirm(rs);
  }
}

Future<void> appOpenTimePicker(
  DateTime? date,
  Function(DateTime date) onConfirm, {
  title,
}) async {
  date ??= DateTime.now();
  final rs = await appOpenBottomSheet(
    WidgetBottomPickTime(
      title: title ?? 'Please choose time'.tr(),
      time: date,
    ),
    // isDismissible: false,
    enableDrag: false,
    backgroundColor: Colors.transparent,
  );
  if (rs is DateTime) {
    onConfirm(rs);
  }
}
