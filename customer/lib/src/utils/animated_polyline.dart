import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

/// Class tiện ích tạo animation cho polyline
class AnimatedPolylineHelper {
  /// Tạo polyline với hiệu ứng animation
  static List<Polyline> createAnimatedPolyline({
    required List<LatLng> points,
    required Color color,
    double strokeWidth = 4.0,
    Color borderColor = Colors.white,
    double borderStrokeWidth = 1.0,
  }) {
    if (points.isEmpty) return [];

    // Tính toán điểm giữa
    List<List<LatLng>> segments = [];
    int segmentCount = 5; // Số lượng đoạn

    for (int i = 0; i < segmentCount; i++) {
      double ratio = i / segmentCount;
      int pointCount = (points.length * ratio).round();
      if (pointCount > 0) {
        segments.add(points.sublist(0, pointCount));
      }
    }

    // Thêm đoạn đầy đủ
    segments.add(points);

    // Tạo danh sách polyline
    List<Polyline> polylines = [];

    // Polyline chính
    polylines.add(
      Polyline(
        points: points,
        strokeWidth: strokeWidth,
        color: color.withOpacity(0.3),
        borderColor: borderColor,
        borderStrokeWidth: borderStrokeWidth,
      ),
    );

    // Polyline chuyển động
    for (int i = 0; i < segments.length; i++) {
      double opacity = 0.4 + (0.6 * (i / segments.length));

      polylines.add(
        Polyline(
          points: segments[i],
          strokeWidth: strokeWidth,
          color: color.withOpacity(opacity),
          borderColor: Colors.transparent,
          borderStrokeWidth: 0,
        ),
      );
    }

    return polylines;
  }
}

/// Widget quản lý cập nhật polyline theo thời gian
class LiveAnimatedPolyline extends StatefulWidget {
  final List<LatLng> points;
  final Color color;
  final double strokeWidth;
  final Color borderColor;
  final double borderStrokeWidth;
  final Duration animationDuration;
  final ValueNotifier<List<Polyline>> polylinesNotifier;

  const LiveAnimatedPolyline({
    Key? key,
    required this.points,
    required this.polylinesNotifier,
    this.color = Colors.blue,
    this.strokeWidth = 4.0,
    this.borderColor = Colors.white,
    this.borderStrokeWidth = 1.0,
    this.animationDuration = const Duration(milliseconds: 1500),
  }) : super(key: key);

  @override
  State<LiveAnimatedPolyline> createState() => _LiveAnimatedPolylineState();
}

class _LiveAnimatedPolylineState extends State<LiveAnimatedPolyline> {
  Timer? _timer;
  int _currentSegment = 0;
  final int _totalSegments = 6;

  @override
  void initState() {
    super.initState();
    _updatePolylines();
    _startAnimation();
  }

  @override
  void didUpdateWidget(LiveAnimatedPolyline oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.points != oldWidget.points) {
      _updatePolylines();
    }

    if (widget.animationDuration != oldWidget.animationDuration) {
      _startAnimation();
    }
  }

  void _startAnimation() {
    _timer?.cancel();
    _timer = Timer.periodic(widget.animationDuration ~/ _totalSegments, (_) {
      _currentSegment = (_currentSegment + 1) % _totalSegments;
      _updatePolylines();
    });
  }

  void _updatePolylines() {
    if (widget.points.isEmpty) {
      widget.polylinesNotifier.value = [];
      return;
    }

    // Tính toán các đoạn
    List<List<LatLng>> segments = [];
    for (int i = 0; i < _totalSegments; i++) {
      double ratio = (i + 1) / _totalSegments;
      int pointCount = (widget.points.length * ratio).round();
      if (pointCount > 0) {
        segments.add(widget.points.sublist(0, pointCount));
      }
    }

    // Tạo polylines
    List<Polyline> polylines = [];

    // Polyline chính mờ
    polylines.add(
      Polyline(
        points: widget.points,
        strokeWidth: widget.strokeWidth,
        color: widget.color.withOpacity(0.3),
        borderColor: widget.borderColor,
        borderStrokeWidth: widget.borderStrokeWidth,
      ),
    );

    // Polyline chuyển động
    int visibleSegment = _currentSegment % segments.length;
    polylines.add(
      Polyline(
        points: segments[visibleSegment],
        strokeWidth: widget.strokeWidth,
        color: widget.color,
        borderColor: Colors.transparent,
        borderStrokeWidth: 0,
      ),
    );

    widget.polylinesNotifier.value = polylines;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Widget không hiển thị gì, chỉ quản lý animation
    return const SizedBox();
  }
}
