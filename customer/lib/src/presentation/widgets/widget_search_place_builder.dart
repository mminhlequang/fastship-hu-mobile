import 'dart:async';
import 'dart:math';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:gap/gap.dart';
import 'package:internal_core/internal_core.dart';
import 'package:app/src/constants/constants.dart';

import 'widget_popup_container.dart';

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
      print('searchPlaces url: $url');
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes));
        final items = List<Map<String, dynamic>>.from(data['items']);
        print('searchPlaces response: $items');
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
    _textEditingController.text = place.title ?? '';
    widget.onSubmitted.call(place);
    _searchPlaces.value = [];
    widget.onChangedFocusMap
        ?.call(AppLatLng(place.position?.lat, place.position?.lng));
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
                                    place.title ?? '',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: w400TextStyle(
                                      fontSize: 14.sw,
                                      color: const Color(0xFF333333),
                                    ),
                                  ),
                                  const Gap(8),
                                  Text(
                                    place.address?.label ?? '',
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

class HereSearchResult {
  String? title;
  String? id;
  String? resultType;
  String? houseNumberType;
  HereAddress? address;
  HerePosition? position;

  HereSearchResult(
      {this.title,
      this.id,
      this.resultType,
      this.houseNumberType,
      this.address,
      this.position});

  HereSearchResult.fromJson(Map<String, dynamic> json) {
    if (json["title"] is String) {
      title = json["title"];
    }
    if (json["id"] is String) {
      id = json["id"];
    }
    if (json["resultType"] is String) {
      resultType = json["resultType"];
    }
    if (json["houseNumberType"] is String) {
      houseNumberType = json["houseNumberType"];
    }
    if (json["address"] is Map) {
      address =
          json["address"] == null ? null : HereAddress.fromJson(json["address"]);
    }
    if (json["position"] is Map) {
      position = json["position"] == null
          ? null
          : HerePosition.fromJson(json["position"]);
    }
  }

  static List<HereSearchResult> fromList(List<Map<String, dynamic>> list) {
    return list.map(HereSearchResult.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["title"] = title;
    _data["id"] = id;
    _data["resultType"] = resultType;
    _data["houseNumberType"] = houseNumberType;
    if (address != null) {
      _data["address"] = address?.toJson();
    }
    if (position != null) {
      _data["position"] = position?.toJson();
    }
    return _data;
  }
}

class HerePosition {
  double? lat;
  double? lng;

  HerePosition({this.lat, this.lng});

  HerePosition.fromJson(Map<String, dynamic> json) {
    if (json["lat"] is double) {
      lat = json["lat"];
    }
    if (json["lng"] is double) {
      lng = json["lng"];
    }
  }

  static List<HerePosition> fromList(List<Map<String, dynamic>> list) {
    return list.map(HerePosition.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["lat"] = lat;
    _data["lng"] = lng;
    return _data;
  }
}

class HereAddress {
  String? label;
  String? countryCode;
  String? countryName;
  String? stateCode;
  String? state;
  String? county;
  String? city;
  String? district;
  String? street;
  String? postalCode;
  String? houseNumber;

  HereAddress(
      {this.label,
      this.countryCode,
      this.countryName,
      this.stateCode,
      this.state,
      this.county,
      this.city,
      this.district,
      this.street,
      this.postalCode,
      this.houseNumber});

  HereAddress.fromJson(Map<String, dynamic> json) {
    if (json["label"] is String) {
      label = json["label"];
    }
    if (json["countryCode"] is String) {
      countryCode = json["countryCode"];
    }
    if (json["countryName"] is String) {
      countryName = json["countryName"];
    }
    if (json["stateCode"] is String) {
      stateCode = json["stateCode"];
    }
    if (json["state"] is String) {
      state = json["state"];
    }
    if (json["county"] is String) {
      county = json["county"];
    }
    if (json["city"] is String) {
      city = json["city"];
    }
    if (json["district"] is String) {
      district = json["district"];
    }
    if (json["street"] is String) {
      street = json["street"];
    }
    if (json["postalCode"] is String) {
      postalCode = json["postalCode"];
    }
    if (json["houseNumber"] is String) {
      houseNumber = json["houseNumber"];
    }
  }

  static List<HereAddress> fromList(List<Map<String, dynamic>> list) {
    return list.map(HereAddress.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["label"] = label;
    _data["countryCode"] = countryCode;
    _data["countryName"] = countryName;
    _data["stateCode"] = stateCode;
    _data["state"] = state;
    _data["county"] = county;
    _data["city"] = city;
    _data["district"] = district;
    _data["street"] = street;
    _data["postalCode"] = postalCode;
    _data["houseNumber"] = houseNumber;
    return _data;
  }
}
