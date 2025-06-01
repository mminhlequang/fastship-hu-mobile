import 'dart:math' as math;
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:internal_core/internal_core.dart';
import 'package:latlong2/latlong.dart';

import 'utils.dart';

updateMapToBoundsLatLng(List<LatLng> latLngs, AnimatedMapController controller,
    {double zoomPlus =  .85, Size? mapSize, bool isFlutterMap = false}) {
  LatLngBounds bounds = LatLngBounds(
    latLngs.reduce((value, element) => LatLng(
        value.latitude < element.latitude ? value.latitude : element.latitude,
        value.longitude < element.longitude
            ? value.longitude
            : element.longitude)),
    latLngs.reduce((value, element) => LatLng(
        value.latitude > element.latitude ? value.latitude : element.latitude,
        value.longitude > element.longitude
            ? value.longitude
            : element.longitude)),
  );
  LatLng center = LatLng(
      (bounds.northEast.latitude + bounds.southWest.latitude) / 2,
      (bounds.northEast.longitude + bounds.southWest.longitude) / 2);
  double zoomLevel = latLngs.length == 1
      ? 13.5
      : _getBoundsZoomLevel(
              bounds,
              mapSize ??
                  Size(
                    appContext.width - 48,
                    appContext.height / 3,
                  )) +
          zoomPlus;

  controller.animateTo(
    dest: center,
    zoom: zoomLevel,
  );
}

updateMapToBounds2(List<Marker> markers, AnimatedMapController controller,
    {double zoomPlus = 1.0, Size? mapSize, bool isFlutterMap = false}) {
  var markerLocations = markers.map((e) => e.point).toList();
  LatLngBounds bounds = LatLngBounds(
    markerLocations.reduce((value, element) => LatLng(
        value.latitude < element.latitude ? value.latitude : element.latitude,
        value.longitude < element.longitude
            ? value.longitude
            : element.longitude)),
    markerLocations.reduce((value, element) => LatLng(
        value.latitude > element.latitude ? value.latitude : element.latitude,
        value.longitude > element.longitude
            ? value.longitude
            : element.longitude)),
  );
  LatLng center = LatLng(
      (bounds.northEast.latitude + bounds.southWest.latitude) / 2,
      (bounds.northEast.longitude + bounds.southWest.longitude) / 2);
  double zoomLevel = markers.length == 1
      ? 13.5
      : _getBoundsZoomLevel(
              bounds,
              mapSize ??
                  Size(
                    appContext.width - 48,
                    appContext.height / 3,
                  )) +
          zoomPlus;

  controller.animateTo(
    dest: center,
    zoom: zoomLevel,
  );
}

double _getBoundsZoomLevel(LatLngBounds bounds, Size mapDimensions) {
  var worldDimension = Size(appContext.width, appContext.height);

  double latRad(lat) {
    var sinValue = math.sin(lat * math.pi / 180);
    var radX2 = math.log((1 + sinValue) / (1 - sinValue)) / 2;
    return math.max(math.min(radX2, math.pi), -math.pi) / 2;
  }

  double zoom(mapPx, worldPx, fraction) {
    return (math.log(mapPx / worldPx / fraction) / math.ln2).floorToDouble();
  }

  var ne = bounds.northEast;
  var sw = bounds.southWest;

  var latFraction = (latRad(ne.latitude) - latRad(sw.latitude)) / math.pi;

  var lngDiff = ne.longitude - sw.longitude;
  var lngFraction = ((lngDiff < 0) ? (lngDiff + 360) : lngDiff) / 360;

  var latZoom = zoom(mapDimensions.height, worldDimension.height, latFraction);
  var lngZoom = zoom(mapDimensions.width, worldDimension.width, lngFraction);

  if (latZoom < 0) return lngZoom;
  if (lngZoom < 0) return latZoom;

  return math.min(latZoom, lngZoom);
}

List<Marker> removeIfZoomSmallFlutterMap2(
  LatLngBounds? visibleRegion,
  List<Marker> values,
  double zoom,
) {
  List<Marker> markers = List.from(values);
  if (zoom > 14) {
  } else if (zoom > 13) {
    markers = groupCoordinatesByRadiusFlutterMap(markers, .3)
        .map((e) => e.first)
        .toList();
  } else if (zoom > 12) {
    markers = groupCoordinatesByRadiusFlutterMap(markers, .5)
        .map((e) => e.first)
        .toList();
  } else if (zoom > 11) {
    markers = groupCoordinatesByRadiusFlutterMap(markers, 1)
        .map((e) => e.first)
        .toList();
  } else if (zoom > 10) {
    markers = groupCoordinatesByRadiusFlutterMap(markers, 1.5)
        .map((e) => e.first)
        .toList();
  } else if (zoom > 9) {
    markers = groupCoordinatesByRadiusFlutterMap(markers, 2)
        .map((e) => e.first)
        .toList();
  } else if (zoom > 8) {
    markers = groupCoordinatesByRadiusFlutterMap(markers, 2.5)
        .map((e) => e.first)
        .toList();
  } else if (zoom > 7) {
    markers = groupCoordinatesByRadiusFlutterMap(markers, 3)
        .map((e) => e.first)
        .toList();
  } else if (zoom > 6) {
    markers = groupCoordinatesByRadiusFlutterMap(markers, 3.5)
        .map((e) => e.first)
        .toList();
  } else if (zoom > 5) {
    markers = groupCoordinatesByRadiusFlutterMap(markers, 4)
        .map((e) => e.first)
        .toList();
  } else if (zoom > 4) {
    markers = groupCoordinatesByRadiusFlutterMap(markers, 6)
        .map((e) => e.first)
        .toList();
  } else if (zoom > 3) {
    markers = groupCoordinatesByRadiusFlutterMap(markers, 8)
        .map((e) => e.first)
        .toList();
  } else {
    markers = groupCoordinatesByRadiusFlutterMap(markers, 10)
        .map((e) => e.first)
        .toList();
  }
  // appDebugPrint('visibleRegion:  $visibleRegion');
  if (visibleRegion != null) {
    // appDebugPrint(
    //     'visibleRegion markers on map:  ${filterCoordinatesInVisibleRegionFlutterMap(markers, visibleRegion).length}');
    return filterCoordinatesInVisibleRegionFlutterMap(markers, visibleRegion);
  } else {
    return markers;
  }
}

List<List<Marker>> groupCoordinatesByRadiusFlutterMap(
    List<Marker> coordinates, double radius) {
  // Kiểm tra nếu chỉ có 10 điểm
  if (coordinates.length == 10) {
    return [coordinates];
  }

  double degreesToRadians(double degrees) {
    return degrees * pi / 180.0;
  }

  double distance(Marker coord1, Marker coord2) {
    const earthRadiusKm = 6371.0;

    double dLat =
        degreesToRadians(coord2.point.latitude - coord1.point.latitude);
    double dLon =
        degreesToRadians(coord2.point.longitude - coord1.point.longitude);

    double lat1 = degreesToRadians(coord1.point.latitude);
    double lat2 = degreesToRadians(coord2.point.latitude);

    double a = sin(dLat / 2) * sin(dLat / 2) +
        sin(dLon / 2) * sin(dLon / 2) * cos(lat1) * cos(lat2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return earthRadiusKm * c;
  }

  // Grouping logic
  List<List<Marker>> groupedCoordinates = [];

  for (int i = 0; i < coordinates.length; i++) {
    bool grouped = false;
    for (int j = 0; j < groupedCoordinates.length; j++) {
      if (distance(coordinates[i], groupedCoordinates[j].first) <= radius) {
        groupedCoordinates[j].add(coordinates[i]);
        grouped = true;
        break;
      }
    }
    if (!grouped) {
      groupedCoordinates.add([coordinates[i]]);
    }
  }

  return groupedCoordinates;
}

List<Marker> filterCoordinatesInVisibleRegion2(
    List<Marker> coordinates, LatLngBounds latLngBounds) {
  return coordinates.where((coord) {
    return coord.point.latitude >= latLngBounds.southWest.latitude &&
        coord.point.latitude <= latLngBounds.northEast.latitude &&
        coord.point.longitude >= latLngBounds.southWest.longitude &&
        coord.point.longitude <= latLngBounds.northEast.longitude;
  }).toList();
}

List<Marker> filterCoordinatesInVisibleRegionFlutterMap(
    List<Marker> coordinates, LatLngBounds latLngBounds) {
  return coordinates.where((coord) {
    return coord.point.latitude >= latLngBounds.southWest.latitude &&
        coord.point.latitude <= latLngBounds.northEast.latitude &&
        coord.point.longitude >= latLngBounds.southWest.longitude &&
        coord.point.longitude <= latLngBounds.northEast.longitude;
  }).toList();
}
