import 'dart:async';

import 'package:app/src/base/cubit/location_cubit.dart';
import 'package:app/src/constants/constants.dart';
import 'package:app/src/presentation/widgets/widgets.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:internal_core/internal_core.dart';
import 'package:latlong2/latlong.dart';

import 'widget_app_map.dart';

class WidgetSheetCurrentLocation extends StatefulWidget {
  final LatLng latlng;
  const WidgetSheetCurrentLocation({super.key, required this.latlng});

  @override
  State<WidgetSheetCurrentLocation> createState() =>
      _WidgetSheetCurrentLocationState();
}

class _WidgetSheetCurrentLocationState
    extends State<WidgetSheetCurrentLocation> {
  Completer<AnimatedMapController> mapController =
      Completer<AnimatedMapController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 393),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 34),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    width: 58,
                    height: 5,
                    decoration: BoxDecoration(
                      color: appColorBorder,
                      borderRadius: BorderRadius.circular(9),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Use current location'.tr(),
                              style: w600TextStyle(
                                fontSize: 20.sw,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Confirming your location helps us determine availability and delivery fees'
                            .tr(),
                        style: w400TextStyle(
                          fontSize: 16.sw,
                          height: 1.4,
                        ),
                      ),
                      if (locationCubit.state.formattedAddress != null) ...[
                        const SizedBox(height: 12),
                        Text(
                          locationCubit.state.formattedAddress!,
                          style: w400TextStyle(
                              fontSize: 16.sw,
                              height: 1.4,
                              color: appColorPrimary),
                        ),
                      ],
                      const SizedBox(height: 12),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: SizedBox(
                          width: 361,
                          height: 361 / 1.97, // Maintaining aspect ratio
                          child: WidgetAppFlutterMap(
                            initialCenter: widget.latlng,
                            markers: [
                              Marker(
                                point: widget.latlng,
                                width: 36,
                                height: 36,
                                child: AvatarGlow(
                                  glowColor: appColorPrimary,
                                  duration: const Duration(milliseconds: 2000),
                                  repeat: true,
                                  child: WidgetAppSVG(
                                    'icon23',
                                    width: 28,
                                    height: 28,
                                    color: appColorPrimary,
                                  ),
                                ),
                              ),
                            ],
                            initialZoom: 15,
                            minZoom: 15,
                            maxZoom: 19,
                            interactionFlags: InteractiveFlag.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      WidgetButtonConfirm(
                        text: 'Submit'.tr(),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
