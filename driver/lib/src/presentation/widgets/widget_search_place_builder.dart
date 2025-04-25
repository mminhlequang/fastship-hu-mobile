import 'package:network_resources/network_resources.dart';
import 'dart:async';
import 'dart:math';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:gap/gap.dart';
import 'package:internal_core/internal_core.dart';
import 'package:internal_core/widgets/widgets.dart';

import 'package:app/src/constants/constants.dart';
import 'package:app/src/utils/utils.dart';

import 'widget_popup_container.dart';

class HereSearchResult {
  final String title;
  final String address;
  final double lat;
  final double lng;

  HereSearchResult({
    required this.title,
    required this.address,
    required this.lat,
    required this.lng,
  });

  factory HereSearchResult.fromJson(Map<String, dynamic> json) {
    return HereSearchResult(
      title: json['title'] ?? '',
      address: json['address']['label'] ?? '',
      lat: json['position']['lat']?.toDouble() ?? 0,
      lng: json['position']['lng']?.toDouble() ?? 0,
    );
  }
}

class WidgetSearchPlaceBuilder extends StatefulWidget {
  final Widget Function(
      ValueChanged onChanged,
      TextEditingController controller,
      bool loading,
      GlobalKey inputKey) builder;
  final TextEditingController? controller;
  final ValueChanged<HereSearchResult> onSubmitted;
  final String? countryCode;
  final ValueChanged<AppLatLng>? onChangedFocusMap;
  final FocusNode? focusNode;
  final bool isNeedInitRequest;
  final HereSearchResult? selectedAddress;

  const WidgetSearchPlaceBuilder({
    super.key,
    this.controller,
    this.countryCode,
    this.onChangedFocusMap,
    required this.builder,
    required this.onSubmitted,
    this.focusNode,
    this.isNeedInitRequest = true,
    this.selectedAddress,
  });

  @override
  State<WidgetSearchPlaceBuilder> createState() =>
      _WidgetSearchPlaceBuilderState();
}

class _WidgetSearchPlaceBuilderState extends State<WidgetSearchPlaceBuilder> {
  final ValueNotifier<List<HereSearchResult>> _searchPlaces = ValueNotifier([]);
  late HereSearchResult? _selectedPlace = widget.selectedAddress;
  late FocusNode _focusNode;
  late TextEditingController _textEditingController;

  Timer? _debounce;
  bool loading = false;

  _onChanged(query) {
    _selectedPlace = null;
    setState(() {
      loading = true;
    });
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      _searchPlaces.value = [];
      if (!loading && mounted) {
        setState(() {
          loading = true;
        });
      }
      if (query.trim().isNotEmpty) {
        await _searchPlacesHere(query);
      } else {
        setState(() {
          loading = false;
        });
      }
    });
  }

  Future<void> _searchPlacesHere(String query) async {
    try {
      final apiKey = hereMapApiKey;
      final url =
          'https://geocode.search.hereapi.com/v1/geocode?lang=${appPrefs?.languageCode ?? 'en'}&q=$query&apiKey=$apiKey';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes));
        final items = List<Map<String, dynamic>>.from(data['items']);

        setState(() {
          _searchPlaces.value =
              items.map((item) => HereSearchResult.fromJson(item)).toList();
          loading = false;
        });
      } else {
        setState(() {
          loading = false;
        });
      }
    } catch (e) {
      print('_searchPlacesHere error: $e');
      setState(() {
        loading = false;
      });
    }
  }

  void _onPlaceSelected(HereSearchResult place) {
    _selectedPlace = place;
    _textEditingController.text = place.title;
    widget.onSubmitted.call(place);
    _searchPlaces.value = [];
    widget.onChangedFocusMap?.call(AppLatLng(place.lat, place.lng));
  }

  @override
  void initState() {
    _focusNode = widget.focusNode ?? FocusNode();
    _textEditingController = widget.controller ?? TextEditingController();
    super.initState();
    if (widget.isNeedInitRequest) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        if (_textEditingController.text.isNotEmpty) {
          _onChanged(_textEditingController.text);
        }
      });
    }
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _textEditingController.dispose();
    }
    _focusNode.dispose();
    _searchPlaces.dispose();
    super.dispose();
  }

  final GlobalKey inputKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _searchPlaces,
      builder: (_, value, child) {
        int count = loading ? 3 : min(_searchPlaces.value.length, 3);
        return PortalTarget(
          visible: _selectedPlace == null &&
              _textEditingController.text.isNotEmpty &&
              (_searchPlaces.value.isNotEmpty || loading),
          anchor: const Aligned(
              follower: Alignment.topLeft,
              target: Alignment.bottomLeft,
              offset: Offset(0, 12)),
          portalFollower: WidgetPopupContainer(
            child: Container(
              width: MediaQuery.of(context).size.width - 40,
              height: 68 * count + 1 * (count - 1),
              child: ListView.separated(
                padding: EdgeInsets.zero,
                itemCount: loading ? 2 : _searchPlaces.value.length,
                itemBuilder: (BuildContext context, int index) {
                  if (loading) {
                    return Ink(
                      height: 68,
                      padding: const EdgeInsets.only(left: 16, right: 18),
                      child: Center(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 14.sw * 1.2,
                                    width: 280.sw,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                  const Gap(8),
                                  Container(
                                    height: 12.sw * 1.2,
                                    width: 200.sw,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  HereSearchResult place = _searchPlaces.value[index];
                  return InkWell(
                    onTap: () => _onPlaceSelected(place),
                    child: Ink(
                      height: 68,
                      padding: const EdgeInsets.only(left: 16, right: 18),
                      child: Center(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    place.title,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: w400TextStyle(
                                      fontSize: 14.sw,
                                      color: const Color(0xFF333333),
                                    ),
                                  ),
                                  const Gap(8),
                                  Text(
                                    place.address,
                                    style: w300TextStyle(
                                      fontSize: fs12(context),
                                      color: const Color(0xFF666666),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    height: 1,
                    color: const Color(0xFFEDEEF3),
                  );
                },
              ),
            ),
          ),
          child: widget.builder(
              _onChanged, _textEditingController, loading, inputKey),
        );
      },
    );
  }
}

class AppLatLng {
  double? lat;
  double? lng;

  AppLatLng(this.lat, this.lng);

  AppLatLng.fromJson(Map<String, dynamic> json) {
    if (json["lat"] is double) lat = json["lat"];
    if (json["lng"] is double) lng = json["lng"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["lat"] = lat;
    data["lng"] = lng;
    return data;
  }
}
