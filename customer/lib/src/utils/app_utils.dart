import 'package:app/src/constants/constants.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:internal_core/internal_core.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:flutter/material.dart';

import 'utils.dart';

String currencyFormatted(double? amount) {
  return NumberFormat.currency(
    locale: 'vi_VN',
    symbol: AppPrefs.instance.currencySymbol,
    decimalDigits: 2,
  ).format(amount ?? 0);
}

bool appIsBottomSheetOpen = false;
appOpenBottomSheet(
  Widget child, {
  bool isDismissible = true,
  bool enableDrag = true,
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
    backgroundColor: Colors.white,
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
    barrierColor: Colors.black.withOpacity(.5),
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
      ? keyThemeModeLight
      : keyThemeModeDark;
  WidgetsBinding.instance.performReassemble();
}

appCatchLog(e) {
  appDebugPrint('[catchLog] $e');
}

enum AppSnackBarType { error, success, notitfication }

appShowSnackBar({context, required msg, Duration? duration}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        msg,
        style: w300TextStyle(color: appColorBackground),
      ),
      duration: duration ?? const Duration(seconds: 1),
      backgroundColor: appColorText,
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
