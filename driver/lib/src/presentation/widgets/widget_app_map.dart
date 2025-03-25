import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart' as flutter_map;
import 'package:flutter_map_animations/flutter_map_animations.dart';

import 'package:app/src/constants/constants.dart';
import 'package:latlong2/latlong.dart';

const double mapMaxZoom = 19.0;

class WidgetAppFlutterMapAnimation extends StatefulWidget {
  //Init state
  final LatLng initialCenter;
  final double initialZoom;
  final double minZoom;
  final double maxZoom;

  //children on map
  final List<flutter_map.Marker>? markers;
  final List<flutter_map.Polyline>? polylines;
  final List<flutter_map.CircleMarker>? circles;

  //callback
  final flutter_map.TapCallback? onTap;
  final flutter_map.TapCallback? onSecondaryTap;
  final flutter_map.LongPressCallback? onLongPress;
  final flutter_map.PointerDownCallback? onPointerDown;
  final flutter_map.PointerUpCallback? onPointerUp;
  final flutter_map.PointerCancelCallback? onPointerCancel;
  final flutter_map.PointerHoverCallback? onPointerHover;
  final flutter_map.PositionCallback? onPositionChanged;
  final flutter_map.MapEventCallback? onMapEvent;

  //interaction
  final bool enableInteractions;
  final int? interactionFlags;

  //enableTiler
  final bool enableTiler;
  final flutter_map.CameraConstraint cameraConstraint;

  final Completer<AnimatedMapController> mapController;

  const WidgetAppFlutterMapAnimation({
    super.key,
    this.markers,
    required this.mapController,
    required this.initialCenter,
    this.initialZoom = 14.0,
    this.minZoom = 3.5,
    this.maxZoom = mapMaxZoom,
    this.polylines,
    this.circles,
    this.onTap,
    this.onSecondaryTap,
    this.onLongPress,
    this.onPointerDown,
    this.onPointerUp,
    this.onPointerCancel,
    this.onPointerHover,
    this.onPositionChanged,
    this.onMapEvent,
    this.enableInteractions = true,
    this.interactionFlags,
    this.enableTiler = true,
    this.cameraConstraint = const flutter_map.CameraConstraint.unconstrained(),
  });

  @override
  State<WidgetAppFlutterMapAnimation> createState() => _WidgetAppFlutterMapAnimationState();
}

class _WidgetAppFlutterMapAnimationState extends State<WidgetAppFlutterMapAnimation>
    with TickerProviderStateMixin {
  late final _animatedMapController = AnimatedMapController(vsync: this);

  // @override
  // void dispose() {
  //   _animatedMapController.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return flutter_map.FlutterMap(
      mapController: _animatedMapController.mapController,
      options: flutter_map.MapOptions(
        backgroundColor: Colors.transparent,
        initialCenter: widget.initialCenter,
        initialZoom: widget.initialZoom,
        minZoom: widget.minZoom,
        maxZoom: widget.maxZoom,
        onTap: widget.onTap,
        cameraConstraint: widget.cameraConstraint,
        onSecondaryTap: widget.onSecondaryTap,
        onLongPress: widget.onLongPress,
        onPointerDown: widget.onPointerDown,
        onPointerUp: widget.onPointerUp,
        onPointerCancel: widget.onPointerCancel,
        onPointerHover: widget.onPointerHover,
        onPositionChanged: widget.onPositionChanged,
        onMapEvent: widget.onMapEvent,
        onMapReady: () {
          if (!widget.mapController.isCompleted) {
            widget.mapController.complete(_animatedMapController);
          }
        },
        interactionOptions: flutter_map.InteractionOptions(
          flags: widget.interactionFlags ??
              (!widget.enableInteractions
                  ? flutter_map.InteractiveFlag.none
                  : flutter_map.InteractiveFlag.drag |
                      flutter_map.InteractiveFlag.flingAnimation |
                      flutter_map.InteractiveFlag.pinchMove |
                      flutter_map.InteractiveFlag.pinchZoom |
                      flutter_map.InteractiveFlag.doubleTapZoom |
                      flutter_map.InteractiveFlag.doubleTapDragZoom |
                      flutter_map.InteractiveFlag.scrollWheelZoom),
        ),
      ),
      children: [
        if (widget.enableTiler)
          flutter_map.TileLayer(
            tileSize: 256,
            urlTemplate: appMapUrlTemplate,
            tileProvider: _CachedNetworkTileProvider(),
          ),
        if (widget.polylines != null)
          flutter_map.PolylineLayer(
            polylines: widget.polylines!,
          ),
        if (widget.circles != null) flutter_map.CircleLayer(circles: widget.circles!),
        if (widget.markers != null) flutter_map.MarkerLayer(markers: widget.markers!),
      ],
    );
  }
}

class WidgetAppFlutterMap extends StatefulWidget {
  //Init state
  final dynamic initialCenter;
  final double initialZoom;
  final double minZoom;
  final double maxZoom;

  //children on map
  final List<flutter_map.Marker>? markers;
  final List<flutter_map.Polyline>? polylines;
  final List<flutter_map.CircleMarker>? circles;

  //callback
  final flutter_map.TapCallback? onTap;
  final flutter_map.TapCallback? onSecondaryTap;
  final flutter_map.LongPressCallback? onLongPress;
  final flutter_map.PointerDownCallback? onPointerDown;
  final flutter_map.PointerUpCallback? onPointerUp;
  final flutter_map.PointerCancelCallback? onPointerCancel;
  final flutter_map.PointerHoverCallback? onPointerHover;
  final flutter_map.PositionCallback? onPositionChanged;
  final flutter_map.MapEventCallback? onMapEvent;

  //interaction
  final bool enableInteractions;
  final int? interactionFlags;

  //enableTiler
  final bool enableTiler;
  final flutter_map.CameraConstraint cameraConstraint;

  final Completer<flutter_map.MapController> mapController;

  const WidgetAppFlutterMap({
    super.key,
    this.markers,
    required this.mapController,
    this.initialCenter,
    this.initialZoom = 14.0,
    this.minZoom = 3.5,
    this.maxZoom = 19.0,
    this.polylines,
    this.circles,
    this.onTap,
    this.onSecondaryTap,
    this.onLongPress,
    this.onPointerDown,
    this.onPointerUp,
    this.onPointerCancel,
    this.onPointerHover,
    this.onPositionChanged,
    this.onMapEvent,
    this.enableInteractions = true,
    this.interactionFlags,
    this.enableTiler = true,
    this.cameraConstraint = const flutter_map.CameraConstraint.unconstrained(),
  });

  @override
  State<WidgetAppFlutterMap> createState() => _WidgetAppFlutterMapState();
}

class _WidgetAppFlutterMapState extends State<WidgetAppFlutterMap> {
  late final flutter_map.MapController mapController = flutter_map.MapController();

  @override
  Widget build(BuildContext context) {
    return flutter_map.FlutterMap(
      mapController: mapController,
      options: flutter_map.MapOptions(
        backgroundColor: Colors.transparent,
        initialCenter: widget.initialCenter,
        initialZoom: widget.initialZoom,
        minZoom: widget.minZoom,
        maxZoom: widget.maxZoom,
        onTap: widget.onTap,
        cameraConstraint: widget.cameraConstraint,
        onSecondaryTap: widget.onSecondaryTap,
        onLongPress: widget.onLongPress,
        onPointerDown: widget.onPointerDown,
        onPointerUp: widget.onPointerUp,
        onPointerCancel: widget.onPointerCancel,
        onPointerHover: widget.onPointerHover,
        onPositionChanged: widget.onPositionChanged,
        onMapEvent: widget.onMapEvent,
        onMapReady: () {
          if (!widget.mapController.isCompleted) {
            widget.mapController.complete(mapController);
          }
        },
        interactionOptions: flutter_map.InteractionOptions(
          flags: widget.interactionFlags ??
              (!widget.enableInteractions
                  ? flutter_map.InteractiveFlag.none
                  : flutter_map.InteractiveFlag.drag |
                      flutter_map.InteractiveFlag.flingAnimation |
                      flutter_map.InteractiveFlag.pinchMove |
                      flutter_map.InteractiveFlag.pinchZoom |
                      flutter_map.InteractiveFlag.doubleTapZoom |
                      flutter_map.InteractiveFlag.doubleTapDragZoom |
                      flutter_map.InteractiveFlag.scrollWheelZoom),
        ),
      ),
      children: [
        if (widget.enableTiler)
          flutter_map.TileLayer(
            tileSize: 256,
            urlTemplate: appMapUrlTemplate,
            tileProvider: _CachedNetworkTileProvider(),
          ),
        if (widget.polylines != null)
          flutter_map.PolylineLayer(
            polylines: widget.polylines!,
          ),
        if (widget.circles != null) flutter_map.CircleLayer(circles: widget.circles!),
        if (widget.markers != null) flutter_map.MarkerLayer(markers: widget.markers!),
      ],
    );
  }
}

class _CachedNetworkTileProvider extends flutter_map.TileProvider {
  @override
  ImageProvider getImage(flutter_map.TileCoordinates coordinates, flutter_map.TileLayer options) {
    // appDebugPrint('getTileUrl: ${getTileUrl(coordinates, options)}');
    return CachedNetworkImageProvider(getTileUrl(coordinates, options));
  }
}
