// import 'dart:io';
// import 'dart:typed_data';
// import 'dart:ui' as ui;
// import 'dart:math' as math;

// import 'package:_private_core/_private_core.dart';
// import 'package:app/src/constants/constants.dart';
// import 'package:app/src/presentation/widgets/widgets.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_cache_manager/flutter_cache_manager.dart';
// import 'package:platform_maps_flutter/platform_maps_flutter.dart';
// import 'package:latlong2/latlong.dart' as latlong2;

// import '../network_resources/points/models/point_interest.dart';

// class AppMapHelper {
//   AppMapHelper._();

//   static late BitmapDescriptor defaultBitmapDescriptor;

//   static initialize() async {
//     defaultBitmapDescriptor = BitmapDescriptor.fromBytes(
//         await _getBytesFromAsset(assetpng('defaultBitmapDescriptor'), 135));
//   }

//   static Future<Uint8List> _getBytesFromAsset(String path, int width) async {
//     ByteData data = await rootBundle.load(path);
//     ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
//         targetWidth: width);
//     ui.FrameInfo fi = await codec.getNextFrame();
//     return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
//         .buffer
//         .asUint8List();
//   }

//   static Map<String, BitmapDescriptor> localBitmapDescriptors = {};
//   static BitmapDescriptor? bitmapDescriptorById(String id) =>
//       localBitmapDescriptors[id];
// }

// // extension ToBitDescription on Widget {
// //   Future<BitmapDescriptor> toBitmapDescriptor({
// //     Size? logicalSize,
// //     Size? imageSize,
// //     Duration waitToRenderDuration = const Duration(milliseconds: 250),
// //     TextDirection textDirection = TextDirection.ltr,
// //     double? devicePixelRatio,
// //     List<String?>? imageUrls,
// //   }) async {
// //     final pngBytes = await _imageFromWidget(
// //       RepaintBoundary(
// //         child: MediaQuery(
// //             data: const MediaQueryData(),
// //             child:
// //                 Directionality(textDirection: TextDirection.ltr, child: this)),
// //       ),
// //       waitToRenderDuration: waitToRenderDuration,
// //       logicalSize: logicalSize,
// //       imageSize: imageSize,
// //       devicePixelRatio: devicePixelRatio,
// //       imageUrls: imageUrls,
// //     );
// //     return BitmapDescriptor.fromBytes(pngBytes);
// //   }

// //   /// Creates an image from the given widget by first spinning up a element and render tree,
// //   /// wait [waitToRenderDuration] to render the widget that take time like network and asset images

// //   /// The final image will be of size [imageSize] and the the widget will be layout, ... with the given [logicalSize].
// //   /// By default Value of  [imageSize] and [logicalSize] will be calculate from the app main window

// //   Future<Uint8List> _imageFromWidget(
// //     Widget widget, {
// //     Size? logicalSize,
// //     required Duration waitToRenderDuration,
// //     Size? imageSize,
// //     double? devicePixelRatio,
// //     List<String?>? imageUrls,
// //   }) async {
// //     final RenderRepaintBoundary repaintBoundary = RenderRepaintBoundary();
// //     logicalSize ??= AppMapHelper.view.physicalSize /
// //         (devicePixelRatio ?? AppMapHelper.view.devicePixelRatio);
// //     imageSize ??= AppMapHelper.view.physicalSize;

// //     // assert(logicalSize.aspectRatio == imageSize.aspectRatio);

// //     final RenderView renderView = RenderView(
// //       view: AppMapHelper.view,
// //       child: RenderPositionedBox(
// //           alignment: Alignment.center, child: repaintBoundary),
// //       configuration: ViewConfiguration(
// //         size: logicalSize,
// //         devicePixelRatio: 1.0,
// //       ),
// //     );

// //     final PipelineOwner pipelineOwner = PipelineOwner();
// //     final BuildOwner buildOwner = BuildOwner(focusManager: FocusManager());

// //     pipelineOwner.rootNode = renderView;
// //     renderView.prepareInitialFrame();

// //     final RenderObjectToWidgetElement<RenderBox> rootElement =
// //         RenderObjectToWidgetAdapter<RenderBox>(
// //       container: repaintBoundary,
// //       child: widget,
// //     ).attachToRenderTree(buildOwner);

// //     buildOwner.buildScope(rootElement);

// //     if (imageUrls != null) {
// //       for (var e in imageUrls) {
// //         if (e != null) {
// //           await DefaultCacheManager().getSingleFile(appImageCorrectUrl(e));
// //         }
// //       }
// //     }

// //     await Future.delayed(waitToRenderDuration);

// //     buildOwner.buildScope(rootElement);
// //     buildOwner.finalizeTree();

// //     pipelineOwner.flushLayout();
// //     pipelineOwner.flushCompositingBits();
// //     pipelineOwner.flushPaint();

// //     final ui.Image image = await repaintBoundary.toImage(
// //         pixelRatio: imageSize.width / logicalSize.width);
// //     final ByteData? byteData =
// //         await image.toByteData(format: ui.ImageByteFormat.png);

// //     return byteData!.buffer.asUint8List();
// //   }
// // }

// updateMapToBoundsLatLng(List<LatLng> latLngs, PlatformMapController controller,
//     {double zoomPlus = .75, Size? mapSize}) {
//   LatLngBounds bounds = LatLngBounds(
//     southwest: latLngs.reduce((value, element) => LatLng(
//         value.latitude < element.latitude ? value.latitude : element.latitude,
//         value.longitude < element.longitude
//             ? value.longitude
//             : element.longitude)),
//     northeast: latLngs.reduce((value, element) => LatLng(
//         value.latitude > element.latitude ? value.latitude : element.latitude,
//         value.longitude > element.longitude
//             ? value.longitude
//             : element.longitude)),
//   );
//   LatLng center = LatLng(
//       (bounds.northeast.latitude + bounds.southwest.latitude) / 2,
//       (bounds.northeast.longitude + bounds.southwest.longitude) / 2);

//   // Tính khoảng cách giữa hai điểm gần nhất
//   double minDistance = double.infinity;
//   for (int i = 0; i < latLngs.length; i++) {
//     for (int j = i + 1; j < latLngs.length; j++) {
//       double distance = calculateDistanceInMet(latLngs[i].latitude,
//           latLngs[i].longitude, latLngs[j].latitude, latLngs[j].longitude);
//       if (distance < minDistance) {
//         minDistance = distance;
//       }
//     }
//   }

//   // Điều chỉnh zoomLevel dựa trên khoảng cách tối thiểu
//   double zoomLevel;
//   if (minDistance < 100) {
//     // Nếu khoảng cách nhỏ hơn 100 mét
//     zoomLevel = mapMaxZoom; // Zoom gần hơn
//   } else {
//     zoomLevel = latLngs.length == 1
//         ? 13.5
//         : _getBoundsZoomLevel(
//                 bounds,
//                 mapSize ??
//                     Size(
//                       appContext.width - 48,
//                       appContext.height / 3,
//                     )) +
//             zoomPlus;
//   }

//   controller.animateCamera(
//     CameraUpdate.newCameraPosition(CameraPosition(
//       target: center,
//       zoom: zoomLevel,
//     )),
//   );
// }

// updateMapToBounds(List<Marker> markers, PlatformMapController controller,
//     {double zoomPlus = 1.0, Size? mapSize, bool isFlutterMap = false}) {
//   var markerLocations = markers.map((e) => e.position).toList();
//   LatLngBounds bounds = LatLngBounds(
//     southwest: markerLocations.reduce((value, element) => LatLng(
//         value.latitude < element.latitude ? value.latitude : element.latitude,
//         value.longitude < element.longitude
//             ? value.longitude
//             : element.longitude)),
//     northeast: markerLocations.reduce((value, element) => LatLng(
//         value.latitude > element.latitude ? value.latitude : element.latitude,
//         value.longitude > element.longitude
//             ? value.longitude
//             : element.longitude)),
//   );
//   LatLng center = LatLng(
//       (bounds.northeast.latitude + bounds.southwest.latitude) / 2,
//       (bounds.northeast.longitude + bounds.southwest.longitude) / 2);
//   double zoomLevel = markers.length == 1
//       ? 13.5
//       : _getBoundsZoomLevel(
//               bounds,
//               mapSize ??
//                   Size(
//                     appContext.width - 48,
//                     appContext.height / 3,
//                   )) +
//           zoomPlus;

//   controller.animateCamera(
//     CameraUpdate.newCameraPosition(
//         CameraPosition(target: center, zoom: zoomLevel)),
//   );
// }

// double _getBoundsZoomLevel(LatLngBounds bounds, Size mapDimensions) {
//   var worldDimension = Size(appContext.width, appContext.height);

//   double latRad(lat) {
//     var sinValue = math.sin(lat * math.pi / 180);
//     var radX2 = math.log((1 + sinValue) / (1 - sinValue)) / 2;
//     return math.max(math.min(radX2, math.pi), -math.pi) / 2;
//   }

//   double zoom(mapPx, worldPx, fraction) {
//     return (math.log(mapPx / worldPx / fraction) / math.ln2).floorToDouble();
//   }

//   var ne = bounds.northeast;
//   var sw = bounds.southwest;

//   var latFraction = (latRad(ne.latitude) - latRad(sw.latitude)) / math.pi;

//   var lngDiff = ne.longitude - sw.longitude;
//   var lngFraction = ((lngDiff < 0) ? (lngDiff + 360) : lngDiff) / 360;

//   var latZoom = zoom(mapDimensions.height, worldDimension.height, latFraction);
//   var lngZoom = zoom(mapDimensions.width, worldDimension.width, lngFraction);

//   if (latZoom < 0) return lngZoom;
//   if (lngZoom < 0) return latZoom;

//   return math.min(latZoom, lngZoom);
// }

// ///==================
// _radians(degree) => degree * (math.pi / 180);

// double calculateDistanceInMet(num lat1, num lng1, num lat2, num lng2) {
//   final latlong2.Distance distance = latlong2.Distance();
//   return distance.as(latlong2.LengthUnit.Meter, 
//     latlong2.LatLng(lat1.toDouble(), lng1.toDouble()),
//     latlong2.LatLng(lat2.toDouble(), lng2.toDouble())
//   );
// }

// // // Hàm tính khoảng cách giữa hai điểm dựa trên tọa độ (latitude, longitude).
// // double calculateDistanceInMet(num lat1, num lon1, num lat2, num lon2) {
// //   const double earthRadius = 6371; // Bán kính trái đất (đơn vị: km)

// //   final double deltaLat = _radians(lat2 - lat1);
// //   final double deltaLon = _radians(lon2 - lon1);

// //   final double a = math.sin(deltaLat / 2) * math.sin(deltaLat / 2) +
// //       math.cos(_radians(lat1)) *
// //           math.cos(_radians(lat2)) *
// //           math.sin(deltaLon / 2) *
// //           math.sin(deltaLon / 2);

// //   final double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));

// //   final double distance = earthRadius * c;
// //   return distance * 1000;
// // }

// // Hàm tính hướng từ một điểm đến một địa điểm khác dựa trên tọa độ (latitude, longitude).
// double calculateDirection(double lat1, double lon1, double lat2, double lon2) {
//   final double deltaLon = _radians(lon2 - lon1);
//   final double y = math.sin(deltaLon) * math.cos(_radians(lat2));
//   final double x = math.cos(_radians(lat1)) * math.sin(_radians(lat2)) -
//       math.sin(_radians(lat1)) * math.cos(_radians(lat2)) * math.cos(deltaLon);

//   final double bearing = math.atan2(y, x);
//   final double degrees = bearing * (180 / math.pi);
//   final double compassDirection =
//       (degrees + 360) % 360; // Đảm bảo hướng từ 0 đến 360 độ.

//   return compassDirection;
// }

// Future<BitmapDescriptor> userCircleBitmapDescriptor() async {
//   //Load image/ if faild => load asset
//   double ratio = 2.5;
//   Uint8List imageUint8List = await _loadImage(
//       AppPrefs.instance.loginUser?.thumbnail,
//       placeholder: 'placeholder');

//   // Kích thước của hình ảnh
//   final double avatarSize = 80.0 * ratio;
//   final double border0Size = 10.0 * ratio;
//   final double borderSize = 3.0 * ratio;

//   // Tạo PictureRecorder và Canvas
//   final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
//   final Canvas canvas = Canvas(pictureRecorder);

//   // Vẽ hình tròn nền

//   final Paint circlePaint1x = Paint()..color = Colors.white;
//   canvas.drawCircle(
//     Offset(avatarSize / 2, avatarSize / 2),
//     avatarSize / 2,
//     circlePaint1x,
//   );
//   final Paint circlePaint1 = Paint()..color = appColorPrimary2.withOpacity(.5);
//   canvas.drawCircle(
//     Offset(avatarSize / 2, avatarSize / 2),
//     avatarSize / 2 - 3,
//     circlePaint1,
//   );

//   final Paint circlePaint2x = Paint()..color = Colors.white;
//   canvas.drawCircle(
//     Offset(avatarSize / 2, avatarSize / 2),
//     avatarSize / 2 - border0Size * .85,
//     circlePaint2x,
//   );
//   final Paint circlePaint2 = Paint()..color = appColorPrimary2;
//   canvas.drawCircle(
//     Offset(avatarSize / 2, avatarSize / 2),
//     avatarSize / 2 - border0Size,
//     circlePaint2,
//   );

//   final Paint circlePaint = Paint()..color = Colors.white;
//   canvas.drawCircle(
//     Offset(avatarSize / 2, avatarSize / 2),
//     avatarSize / 2 - border0Size * 2,
//     circlePaint,
//   );

//   final ui.Codec codec = await ui.instantiateImageCodec(
//     imageUint8List,
//     targetHeight: ((avatarSize / 2 - border0Size * 2 - borderSize) * 2).toInt(),
//     targetWidth: ((avatarSize / 2 - border0Size * 2 - borderSize) * 2).toInt(),
//   );
//   final ui.FrameInfo frameInfo = await codec.getNextFrame();

//   // Vẽ hình ảnh trong hình tròn
//   final Paint imagePaint = Paint()
//     ..shader = ImageShader(
//       frameInfo.image,
//       TileMode.clamp,
//       TileMode.clamp,
//       Matrix4.translationValues((border0Size * 2 + borderSize).toDouble(),
//               (border0Size * 2 + borderSize).toDouble(), 0)
//           .storage,
//     );

//   canvas.drawCircle(
//     Offset(avatarSize / 2, avatarSize / 2),
//     avatarSize / 2 - border0Size * 2 - borderSize,
//     imagePaint,
//   );

//   // Kết thúc vẽ và chuyển đổi thành BitmapDescriptor
//   final ui.Image image = await pictureRecorder
//       .endRecording()
//       .toImage(avatarSize.toInt(), avatarSize.toInt());
//   final ByteData? byteData =
//       await image.toByteData(format: ui.ImageByteFormat.png);
//   final Uint8List byteList = byteData!.buffer.asUint8List();

//   return BitmapDescriptor.fromBytes(byteList);
// }

// Future<BitmapDescriptor> pointCircleBitmapDescriptor(
//     PointInterest m, bool isSelected) async {
//   //Load image/ if faild => load asset
//   double ratio = 2.5;

//   Uint8List imageUint8List = await _loadImage(m.imageDisplayTiny);

//   // Kích thước của hình ảnh
//   final double avatarSize = 60.0 * ratio;
//   final double borderSize = 3.0 * ratio;

//   // Tạo PictureRecorder và Canvas
//   final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
//   final Canvas canvas = Canvas(pictureRecorder);

//   // Vẽ hình tròn nền
//   final Paint circlePaint = Paint()
//     ..color = isSelected ? appColorPrimary2 : Colors.white;
//   canvas.drawCircle(
//     Offset(avatarSize / 2, avatarSize / 2),
//     avatarSize / 2,
//     circlePaint,
//   );

//   final ui.Codec codec = await ui.instantiateImageCodec(
//     imageUint8List,
//     // targetHeight: ((avatarSize / 2 - borderSize) * 2).toInt(),
//     // targetWidth: ((avatarSize / 2 - borderSize) * 2).toInt(),
//     targetHeight: (avatarSize * 1.05).toInt(),
//     targetWidth: (avatarSize * 1.05).toInt(),
//   );
//   final ui.FrameInfo frameInfo = await codec.getNextFrame();

//   // Vẽ hình ảnh trong hình tròn
//   final Paint imagePaint = Paint()
//     ..shader = ImageShader(
//       frameInfo.image,
//       TileMode.clamp,
//       TileMode.clamp,
//       Matrix4.identity().storage,
//     );

//   canvas.drawCircle(
//     Offset(avatarSize / 2, avatarSize / 2),
//     avatarSize / 2 - borderSize,
//     imagePaint,
//   );

//   // Kết thúc vẽ và chuyển đổi thành BitmapDescriptor
//   final ui.Image image = await pictureRecorder
//       .endRecording()
//       .toImage(avatarSize.toInt(), avatarSize.toInt());
//   final ByteData? byteData =
//       await image.toByteData(format: ui.ImageByteFormat.png);
//   final Uint8List byteList = byteData!.buffer.asUint8List();

//   return BitmapDescriptor.fromBytes(byteList);
// }

// Future<BitmapDescriptor> pointBitmapDescriptor(
//     PointInterest m, bool isSelected) async {
//   //Load image/ if faild => load asset
//   double ratio = 2.5;

//   Uint8List imageUint8List = await _loadImage(m.imageDisplayTiny);

//   String textTitle = m.getTitle;

//   // Kích thước của hình ảnh
//   final double avatarSize = 60.0 * ratio;
//   final double borderSizeAvatar = 3.0 * ratio;
//   final double borderSizeContainer = 1.0 * ratio;

//   // Tạo PictureRecorder và Canvas
//   final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
//   final Canvas canvas = Canvas(pictureRecorder);

//   // Vẽ hình tròn nền
//   final Paint circlePaint = Paint()
//     ..color = isSelected ? appColorPrimary2 : Colors.white;
//   canvas.drawCircle(
//     Offset(avatarSize / 2, avatarSize / 2),
//     avatarSize / 2,
//     circlePaint,
//   );

//   final ui.Codec codec = await ui.instantiateImageCodec(
//     imageUint8List,
//     // targetHeight: ((avatarSize / 2 - borderSize) * 2).toInt(),
//     // targetWidth: ((avatarSize / 2 - borderSize) * 2).toInt(),
//     targetHeight: (avatarSize * 1.05).toInt(),
//     targetWidth: (avatarSize * 1.05).toInt(),
//   );
//   final ui.FrameInfo frameInfo = await codec.getNextFrame();

//   // Vẽ hình ảnh trong hình tròn
//   final Paint imagePaint = Paint()
//     ..shader = ImageShader(
//       frameInfo.image,
//       TileMode.clamp,
//       TileMode.clamp,
//       Matrix4.identity().storage,
//     );

//   canvas.drawCircle(
//     Offset(avatarSize / 2, avatarSize / 2),
//     avatarSize / 2 - borderSizeAvatar,
//     imagePaint,
//   );

//   //=========================================

//   // Padding và bo góc
//   final double paddingHoriz = 12.0 * ratio;
//   final double paddingVert = 8.0 * ratio;
//   final double borderRadius = 12.0 * ratio;
//   final double maxWidthTitle = 140.0 * ratio;

//   // Tạo TextPainters để đo kích thước của textTitle và textDesc
//   TextPainter textTitlePainter = TextPainter(
//     text: TextSpan(
//       text: textTitle,
//       style: w500TextStyle(
//           fontSize: 14.sw * ratio,
//           height: 1.4,
//           color: isSelected ? Colors.white : appColorText),
//     ),
//     textDirection: TextDirection.ltr,
//   );

//   textTitlePainter.layout();
//   // Kích thước của container
//   double containerWidth = paddingHoriz * 2 + textTitlePainter.width;
//   double containerHeight = paddingVert * 2 + textTitlePainter.height + 0;

//   if (textTitlePainter.width > maxWidthTitle) {
//     containerWidth = paddingHoriz * 2 + maxWidthTitle;
//     textTitlePainter = TextPainter(
//       maxLines: 2,
//       text: TextSpan(
//         text: textTitle,
//         style: w500TextStyle(
//             fontSize: 14.sw * ratio,
//             height: 1.4,
//             color: isSelected ? Colors.white : appColorText),
//       ),
//       textDirection: TextDirection.ltr,
//     );
//     textTitlePainter.layout(maxWidth: maxWidthTitle);
//     containerHeight = paddingVert * 2 + textTitlePainter.height + 0;
//   }
//   //Vẽ border

//   // Vẽ container với bo góc, padding, và shadow
//   final Paint containerBorderPaint = Paint()
//     ..style = PaintingStyle.fill
//     ..shader = LinearGradient(
//       colors: isSelected
//           ? [Colors.white, Colors.white]
//           : [hexColor('EBEBEC'), hexColor('EBEBEC')],
//       begin: Alignment.topCenter,
//       end: Alignment.bottomCenter,
//     ).createShader(
//         Rect.fromPoints(const Offset(0, 0), Offset(0, containerHeight)));

//   final RRect containerBorderRect = RRect.fromRectAndCorners(
//     Rect.fromPoints(
//         Offset(avatarSize * .6 - borderSizeContainer,
//             avatarSize * .75 - borderSizeContainer),
//         Offset(containerWidth + avatarSize * .6 + borderSizeContainer,
//             containerHeight + avatarSize * .75 + borderSizeContainer)),
//     topLeft: Radius.circular(borderRadius + borderSizeContainer),
//     topRight: Radius.circular(borderRadius + borderSizeContainer),
//     bottomLeft: Radius.circular(borderRadius + borderSizeContainer),
//     bottomRight: Radius.circular(borderRadius + borderSizeContainer),
//   );

//   canvas.drawRRect(containerBorderRect, containerBorderPaint);

//   // Vẽ container với bo góc, padding, và shadow
//   final Paint containerPaint = Paint()
//     ..style = PaintingStyle.fill
//     ..shader = LinearGradient(
//       colors: isSelected
//           ? [appColorPrimary2, appColorPrimary2]
//           : [Colors.white, Colors.white],
//       begin: Alignment.topCenter,
//       end: Alignment.bottomCenter,
//     ).createShader(
//         Rect.fromPoints(const Offset(0, 0), Offset(0, containerHeight)));

//   final RRect containerRect = RRect.fromRectAndCorners(
//     Rect.fromPoints(
//         Offset(avatarSize * .6, avatarSize * .75),
//         Offset(containerWidth + avatarSize * .6,
//             containerHeight + avatarSize * .75)),
//     topLeft: Radius.circular(borderRadius),
//     topRight: Radius.circular(borderRadius),
//     bottomLeft: Radius.circular(borderRadius),
//     bottomRight: Radius.circular(borderRadius),
//   );

//   canvas.drawRRect(containerRect, containerPaint);

//   //Vẽ title
//   textTitlePainter.paint(canvas,
//       Offset(paddingHoriz + avatarSize * .6, paddingVert + avatarSize * .75));

//   //=========================================

//   // Kết thúc vẽ và chuyển đổi thành BitmapDescriptor
//   final ui.Image image = await pictureRecorder.endRecording().toImage(
//       (containerWidth + avatarSize * .6 + borderSizeContainer).toInt(),
//       (containerHeight + avatarSize * .75 + borderSizeContainer).toInt());
//   final ByteData? byteData =
//       await image.toByteData(format: ui.ImageByteFormat.png);
//   final Uint8List byteList = byteData!.buffer.asUint8List();

//   return BitmapDescriptor.fromBytes(byteList);
// }

// Future<Uint8List> _loadImage(String? imageUrl, {placeholder}) async {
//   Uint8List? imageUint8List;

//   if (imageUrl != null) {
//     try {
//       File imageFile = await DefaultCacheManager()
//           .getSingleFile(appImageCorrectUrl(imageUrl));
//       imageUint8List = await compute(_readFileIsolate, imageFile.path);
//     } catch (_) {}
//   }
//   imageUint8List ??= (await rootBundle
//           .load(assetpng(placeholder ?? 'defaultBitmapDescriptor')))
//       .buffer
//       .asUint8List();
//   return imageUint8List;
// }

// Uint8List _readFileIsolate(String filePath) {
//   File file = File(filePath);
//   return file.readAsBytesSync();
// }

// // List<Marker> removeIfZoomSmall(
// //   LatLngBounds? visibleRegion,
// //   List<Marker> values,
// //   double zoom,
// // ) {
// //   late List<Marker> markers = List.from(values);
// //   if (zoom > 14) {
// //   } else if (zoom > 13) {
// //     markers =
// //         groupCoordinatesByRadius(markers, .3).map((e) => e.first).toList();
// //   } else if (zoom > 12) {
// //     markers =
// //         groupCoordinatesByRadius(markers, .5).map((e) => e.first).toList();
// //   } else if (zoom > 11) {
// //     markers = groupCoordinatesByRadius(markers, 1).map((e) => e.first).toList();
// //   } else if (zoom > 10) {
// //     markers =
// //         groupCoordinatesByRadius(markers, 1.5).map((e) => e.first).toList();
// //   } else if (zoom > 9) {
// //     markers = groupCoordinatesByRadius(markers, 2).map((e) => e.first).toList();
// //   } else if (zoom > 8) {
// //     markers =
// //         groupCoordinatesByRadius(markers, 2.5).map((e) => e.first).toList();
// //   } else if (zoom > 7) {
// //     markers = groupCoordinatesByRadius(markers, 3).map((e) => e.first).toList();
// //   } else if (zoom > 6) {
// //     markers =
// //         groupCoordinatesByRadius(markers, 3.5).map((e) => e.first).toList();
// //   } else if (zoom > 5) {
// //     markers = groupCoordinatesByRadius(markers, 4).map((e) => e.first).toList();
// //   } else if (zoom > 4) {
// //     markers = groupCoordinatesByRadius(markers, 6).map((e) => e.first).toList();
// //   } else if (zoom > 3) {
// //     markers = groupCoordinatesByRadius(markers, 8).map((e) => e.first).toList();
// //   } else {
// //     markers =
// //         groupCoordinatesByRadius(markers, 10).map((e) => e.first).toList();
// //   }
// //   if (visibleRegion != null) {
// //     appDebugPrint(
// //         'markers on map:  ${filterCoordinatesInVisibleRegion(markers, visibleRegion!).length}');

// //     return filterCoordinatesInVisibleRegion(markers, visibleRegion);
// //   } else {
// //     return markers;
// //   }
// // }

// // List<List<Marker>> groupCoordinatesByRadius(
// //     List<Marker> coordinates, double radius) {
// //   double degreesToRadians(double degrees) {
// //     return degrees * pi / 180.0;
// //   }

// //   double distance(Marker coord1, Marker coord2) {
// //     const earthRadiusKm = 6371.0;

// //     double dLat =
// //         degreesToRadians(coord2.position.latitude - coord1.position.latitude);
// //     double dLon =
// //         degreesToRadians(coord2.position.longitude - coord1.position.longitude);

// //     double lat1 = degreesToRadians(coord1.position.latitude);
// //     double lat2 = degreesToRadians(coord2.position.latitude);

// //     double a = sin(dLat / 2) * sin(dLat / 2) +
// //         sin(dLon / 2) * sin(dLon / 2) * cos(lat1) * cos(lat2);
// //     double c = 2 * atan2(sqrt(a), sqrt(1 - a));

// //     return earthRadiusKm * c;
// //   }

// //   // Grouping logic
// //   List<List<Marker>> groupedCoordinates = [];

// //   for (int i = 0; i < coordinates.length; i++) {
// //     bool grouped = false;
// //     for (int j = 0; j < groupedCoordinates.length; j++) {
// //       if (distance(coordinates[i], groupedCoordinates[j].first) <= radius) {
// //         groupedCoordinates[j].add(coordinates[i]);
// //         grouped = true;
// //         break;
// //       }
// //     }
// //     if (!grouped) {
// //       groupedCoordinates.add([coordinates[i]]);
// //     }
// //   }

// //   return groupedCoordinates;
// // }

// // List<flutter_map.Marker> removeIfZoomSmallFlutterMap(
// //   LatLngBounds? visibleRegion,
// //   List<flutter_map.Marker> values,
// //   double zoom,
// // ) {
// //   List<flutter_map.Marker> markers = List.from(values);
// //   if (zoom > 14) {
// //   } else if (zoom > 13) {
// //     markers = groupCoordinatesByRadiusFlutterMap(markers, .3)
// //         .map((e) => e.first)
// //         .toList();
// //   } else if (zoom > 12) {
// //     markers = groupCoordinatesByRadiusFlutterMap(markers, .5)
// //         .map((e) => e.first)
// //         .toList();
// //   } else if (zoom > 11) {
// //     markers = groupCoordinatesByRadiusFlutterMap(markers, 1)
// //         .map((e) => e.first)
// //         .toList();
// //   } else if (zoom > 10) {
// //     markers = groupCoordinatesByRadiusFlutterMap(markers, 1.5)
// //         .map((e) => e.first)
// //         .toList();
// //   } else if (zoom > 9) {
// //     markers = groupCoordinatesByRadiusFlutterMap(markers, 2)
// //         .map((e) => e.first)
// //         .toList();
// //   } else if (zoom > 8) {
// //     markers = groupCoordinatesByRadiusFlutterMap(markers, 2.5)
// //         .map((e) => e.first)
// //         .toList();
// //   } else if (zoom > 7) {
// //     markers = groupCoordinatesByRadiusFlutterMap(markers, 3)
// //         .map((e) => e.first)
// //         .toList();
// //   } else if (zoom > 6) {
// //     markers = groupCoordinatesByRadiusFlutterMap(markers, 3.5)
// //         .map((e) => e.first)
// //         .toList();
// //   } else if (zoom > 5) {
// //     markers = groupCoordinatesByRadiusFlutterMap(markers, 4)
// //         .map((e) => e.first)
// //         .toList();
// //   } else if (zoom > 4) {
// //     markers = groupCoordinatesByRadiusFlutterMap(markers, 6)
// //         .map((e) => e.first)
// //         .toList();
// //   } else if (zoom > 3) {
// //     markers = groupCoordinatesByRadiusFlutterMap(markers, 8)
// //         .map((e) => e.first)
// //         .toList();
// //   } else {
// //     markers = groupCoordinatesByRadiusFlutterMap(markers, 10)
// //         .map((e) => e.first)
// //         .toList();
// //   }
// //   appDebugPrint('visibleRegion:  $visibleRegion');
// //   if (visibleRegion != null) {
// //     appDebugPrint(
// //         'visibleRegion markers on map:  ${filterCoordinatesInVisibleRegionFlutterMap(markers, visibleRegion!).length}');
// //     return filterCoordinatesInVisibleRegionFlutterMap(markers, visibleRegion);
// //   } else {
// //     return markers;
// //   }
// // }

// // List<List<flutter_map.Marker>> groupCoordinatesByRadiusFlutterMap(
// //     List<flutter_map.Marker> coordinates, double radius) {
// //   double degreesToRadians(double degrees) {
// //     return degrees * pi / 180.0;
// //   }

// //   double distance(flutter_map.Marker coord1, flutter_map.Marker coord2) {
// //     const earthRadiusKm = 6371.0;

// //     double dLat =
// //         degreesToRadians(coord2.point.latitude - coord1.point.latitude);
// //     double dLon =
// //         degreesToRadians(coord2.point.longitude - coord1.point.longitude);

// //     double lat1 = degreesToRadians(coord1.point.latitude);
// //     double lat2 = degreesToRadians(coord2.point.latitude);

// //     double a = sin(dLat / 2) * sin(dLat / 2) +
// //         sin(dLon / 2) * sin(dLon / 2) * cos(lat1) * cos(lat2);
// //     double c = 2 * atan2(sqrt(a), sqrt(1 - a));

// //     return earthRadiusKm * c;
// //   }

// //   // Grouping logic
// //   List<List<flutter_map.Marker>> groupedCoordinates = [];

// //   for (int i = 0; i < coordinates.length; i++) {
// //     bool grouped = false;
// //     for (int j = 0; j < groupedCoordinates.length; j++) {
// //       if (distance(coordinates[i], groupedCoordinates[j].first) <= radius) {
// //         groupedCoordinates[j].add(coordinates[i]);
// //         grouped = true;
// //         break;
// //       }
// //     }
// //     if (!grouped) {
// //       groupedCoordinates.add([coordinates[i]]);
// //     }
// //   }

// //   return groupedCoordinates;
// // }

// // List<Marker> filterCoordinatesInVisibleRegion(
// //     List<Marker> coordinates, LatLngBounds latLngBounds) {
// //   return coordinates.where((coord) {
// //     return coord.position.latitude >= latLngBounds.southwest.latitude &&
// //         coord.position.latitude <= latLngBounds.northeast.latitude &&
// //         coord.position.longitude >= latLngBounds.southwest.longitude &&
// //         coord.position.longitude <= latLngBounds.northeast.longitude;
// //   }).toList();
// // }

// // List<flutter_map.Marker> filterCoordinatesInVisibleRegionFlutterMap(
// //     List<flutter_map.Marker> coordinates, LatLngBounds latLngBounds) {
// //   return coordinates.where((coord) {
// //     return coord.point.latitude >= latLngBounds.southwest.latitude &&
// //         coord.point.latitude <= latLngBounds.northeast.latitude &&
// //         coord.point.longitude >= latLngBounds.southwest.longitude &&
// //         coord.point.longitude <= latLngBounds.northeast.longitude;
// //   }).toList();
// // }
