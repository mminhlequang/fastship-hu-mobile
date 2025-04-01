import 'dart:async';

import 'package:app/src/base/cubit/location_cubit.dart';
import 'package:app/src/constants/constants.dart';
import 'package:app/src/presentation/widgets/widget_app_map.dart';
import 'package:app/src/presentation/widgets/widget_appbar.dart';
import 'package:app/src/presentation/widgets/widget_search_place_builder.dart';
import 'package:app/src/utils/utils.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:internal_core/internal_core.dart';
import 'package:latlong2/latlong.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class WidgetSheetLocations extends StatefulWidget {
  const WidgetSheetLocations({Key? key}) : super(key: key);

  @override
  _WidgetSheetLocationsState createState() => _WidgetSheetLocationsState();
}

class _WidgetSheetLocationsState extends State<WidgetSheetLocations> {
  Completer<AnimatedMapController> mapController =
      Completer<AnimatedMapController>();
  final PanelController _panelController = PanelController();
  HereSearchResult? selectedAddress;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              WidgetAppBar(
                title: WidgetSearchPlaceBuilder(
                  builder: (onChanged, controller, loading, inputKey) =>
                      Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.sw,
                      vertical: 10.sw,
                    ),
                    decoration: BoxDecoration(
                      color: hexColor('#F9F8F6'),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        WidgetAppSVG('icon20', width: 24.sw, height: 24.sw),
                        SizedBox(width: 8.sw),
                        Expanded(
                          child: TextField(
                            controller: controller,
                            onSubmitted: (value) {},
                            // focusNode: focusNode,
                            onChanged: onChanged,
                            style: w500TextStyle(
                              fontSize: 16.sw,
                            ),
                            decoration: InputDecoration.collapsed(
                              hintText: 'Where to ship?'.tr(),
                              border: InputBorder.none,
                              hintStyle: w400TextStyle(
                                fontSize: 16.sw,
                                color: hexColor('#7D7575'),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  onSubmitted: (value) async {
                    selectedAddress = value;
                    (await mapController.future).animateTo(
                      dest: LatLng(
                        value.position!.lat!,
                        value.position!.lng!,
                      ),
                      zoom: 15,
                    );
                    setState(() {});
                  },
                ),
              ),
              Expanded(
                child: WidgetAppFlutterMapAnimation(
                  mapController: mapController,
                  initialCenter: selectedAddress != null
                      ? LatLng(
                          selectedAddress!.position!.lat!,
                          selectedAddress!.position!.lng!,
                        )
                      : LatLng(
                          locationCubit.latitude!,
                          locationCubit.longitude!,
                        ),
                  markers: [
                    Marker(
                      point: selectedAddress != null
                          ? LatLng(
                              selectedAddress!.position!.lat!,
                              selectedAddress!.position!.lng!,
                            )
                          : LatLng(
                              locationCubit.latitude!,
                              locationCubit.longitude!,
                            ),
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
                ),
              ),
            ],
          ),
          SlidingUpPanel(
            controller: _panelController,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 20,
                offset: const Offset(0, -4),
              ),
            ],
            minHeight: 240.sw + MediaQuery.of(context).padding.bottom,
            maxHeight: MediaQuery.of(context).size.height * 0.8,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            panel: _buildBottomSheet(),
            body: Container(),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomSheet() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 55,
            height: 5,
            margin: EdgeInsets.symmetric(vertical: 16.sw),
            decoration: BoxDecoration(
              color: hexColor('#F1EFE9'),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 12.sw,
              children: [
                Text(
                  'Current Location selected'.tr(),
                  style: w500TextStyle(
                    fontSize: 16.sw,
                    height: 1.4,
                  ),
                ),
                _buildLocationCard(locationCubit.state.addressDetail!, true),
                SizedBox(height: 12.sw),
                if (selectedAddress != null ||
                    AppPrefs.instance.deliveryAddresses
                        .where((e) =>
                            e.position!.lat != locationCubit.latitude &&
                            e.position!.lng != locationCubit.longitude)
                        .isNotEmpty) ...[
                  Text(
                    'You can select other location as delivery address'.tr(),
                    style: w500TextStyle(
                      fontSize: 16.sw,
                      height: 1.4,
                    ),
                  ),
                  if (selectedAddress != null)
                    WidgetInkWellTransparent(
                      enableInkWell: false,
                      onTap: () {
                        appHaptic();
                        locationCubit.updateAddressDetail(selectedAddress!);
                        context.pop();
                      },
                      child: _buildLocationCard(selectedAddress!, false),
                    ),
                  ...AppPrefs.instance.deliveryAddresses
                      .where((e) =>
                          e.position!.lat != locationCubit.latitude &&
                          e.position!.lng != locationCubit.longitude)
                      .map((e) => WidgetInkWellTransparent(
                            enableInkWell: false,
                            onTap: () {
                              appHaptic();
                              locationCubit.updateAddressDetail(e);
                              context.pop();
                            },
                            child: _buildLocationCard(e, false),
                          ))
                      .toList(),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationCard(HereSearchResult address, bool isSelected) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: isSelected ? appBoxDecorationSelected : null,
      child: Row(
        children: [
          WidgetAppSVG(
            'icon20',
            width: 36.sw,
            height: 36.sw,
          ),
          SizedBox(width: 8.sw),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  address.address?.street ?? '',
                  style: w500TextStyle(
                    fontSize: 16.sw,
                    height: 1.4,
                  ),
                ),
                Text(
                  address.title ?? '',
                  style: w400TextStyle(
                    fontSize: 14.sw,
                    color: hexColor('#7D7575'),
                    height: 1.4,
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
