// import 'dart:async';

// import 'package:internal_core/internal_core.dart';
// import 'package:app/src/utils/utils.dart';
// import 'package:app_links/app_links.dart';
// import 'package:flutter/services.dart';

// class AppUniLinks {
//   static final _appLinks = AppLinks();
//   static StreamSubscription? _linkSubscription;
//   static Future<void> init({checkActualVersion = false}) async {
//     _linkSubscription?.cancel();
//     try {
//       _linkSubscription = _appLinks.uriLinkStream.listen((uri) {
//         _uniLinkHandler(uri: uri);
//       });
//     } on PlatformException {
//       appDebugPrint(
//           "[AppUniLinks] (PlatformException) Failed to receive initial uri.");
//     } on FormatException catch (error) {
//       appDebugPrint(
//           "[AppUniLinks] (FormatException) Malformed Initial URI received. Error: $error");
//     }
//   }

//   //dreamartai.mminhdev.io.vn/enable_nsfw
//   static Future<void> _uniLinkHandler({required Uri? uri}) async {
//     AppPrefs.instance.enableNsfw = true;

//     if (uri == null || uri.queryParameters.isEmpty) return;
//     Map<String, String> params = uri.queryParameters;
//     appDebugPrint(
//         '[AppUniLinks] _uniLinkHandler path=${uri.path} params=$params');

//     // switch (params['actionType']) {
//     //   case "sharePoi":
//     //     break;
//     //   default:
//     // }
//   }
// }
