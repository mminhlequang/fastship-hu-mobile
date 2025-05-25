import 'package:app/src/constants/constants.dart';
import 'package:app/src/presentation/filter_results/filter_results_screen.dart';
import 'package:app/src/presentation/widgets/widgets.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:internal_core/internal_core.dart';
import 'package:network_resources/category/model/category.dart';
import 'package:network_resources/category/repo.dart';
import 'package:network_resources/network_resources.dart';

import '../home_screen.dart';
import 'widget_category_card.dart';

class _SortOption {
  int id;
  String label;
  String fieldName;
  dynamic value;

  _SortOption({
    required this.id,
    required this.label,
    required this.fieldName,
    this.value,
  });
}

class WidgetDialogFilters extends StatefulWidget {
  final bool isRestaurant;
  final Map<String, dynamic>? initialParams;
  const WidgetDialogFilters(
      {super.key, this.isRestaurant = false, this.initialParams});

  @override
  State<WidgetDialogFilters> createState() => _WidgetDialogFiltersState();
}

class _WidgetDialogFiltersState extends State<WidgetDialogFilters> {
  List<int> selectedSort = [2, 3];
  final List<_SortOption> sortOptions = [
    _SortOption(
      id: 1,
      label: 'Recommend'.tr(),
      fieldName: 'is_popular',
      value: 1,
    ),
    _SortOption(
      id: 2,
      label: 'Best seller'.tr(),
      fieldName: 'is_topseller',
      value: 1,
    ),
    _SortOption(
      id: 3,
      label: 'High rating'.tr(),
      fieldName: 'is_topseller', //TODO: need correct
      value: 1,
    ),
    _SortOption(
      id: 4,
      label: 'Preparation time'.tr(),
      fieldName: 'is_topseller', //TODO: need correct
      value: 1,
    ),
    _SortOption(
      id: 5,
      label: 'Delivery time'.tr(),
      fieldName: 'is_topseller', //TODO: need correct
      value: 1,
    ),
  ];

  int? _categoryIdSelected;
  List<int> subTypeIds = [];
  RangeValues priceRange = const RangeValues(2000.0, 10000.0);

  Map<String, dynamic> get paramFilters {
    var result = <String, dynamic>{};
    if (selectedSort.isNotEmpty) {
      for (var sort
          in sortOptions.where((option) => selectedSort.contains(option.id))) {
        result.addAll({
          sort.fieldName: sort.value,
        });
      }
    }
    if (_categoryIdSelected != null) {
      result['category_ids'] = [_categoryIdSelected, ...subTypeIds].join(',');
    }
    result['price_from'] = priceRange.start;
    result['price_to'] = priceRange.end;
    print(result);
    return result;
  }

  @override
  void initState() {
    super.initState();
    if (widget.initialParams != null) {
      if (widget.initialParams?['is_popular'] != null) {
        selectedSort.add(1);
      }
      if (widget.initialParams?['is_topseller'] != null) {
        selectedSort.add(2);
      }
      if (widget.initialParams?['category_ids']?.isNotEmpty == true) {
        List<String> listCategoryIds =
            widget.initialParams?['category_ids'].split(',');
        _categoryIdSelected = int.parse(listCategoryIds.first);
        subTypeIds = listCategoryIds.skip(1).map(int.parse).toList();
      }
      if (widget.initialParams?['price_from'] != null) {
        priceRange = RangeValues(
          widget.initialParams?['price_from'],
          widget.initialParams?['price_to'],
        );
      }
    }
    _fetchCategories();
  }

  void _fetchCategories() async {
    final response = await CategoryRepo().getCategories({});
    if (response.isSuccess) {
      appProductCategories = response.data;
      if (appProductCategories != null && appProductCategories!.isNotEmpty) {
        if (_categoryIdSelected == null) {
          _categoryIdSelected = appProductCategories!
              .firstWhere(
                (category) => category.id == _categoryIdSelected,
                orElse: () => appProductCategories!.first,
              )
              .id;
          subTypeIds = [];
        }
      }
    }
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        margin: MediaQuery.of(context)
            .padding
            .add(const EdgeInsets.symmetric(horizontal: 8)),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24.sw),
        ),
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 24, 12, 12),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(),
                      16.h,
                      _buildSearchBar(),
                      const SizedBox(height: 12),
                      _buildSortBySection(),
                      _buildDivider(),
                      _buildTypeFoodSection(),
                      _buildDivider(),
                      _buildPriceRangeSection(),
                    ],
                  ),
                ),
              ),
            ),
            _buildBottomButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Filter'.tr(),
          style: w500TextStyle(fontSize: 20.sw),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFF8F1F0)),
        borderRadius: BorderRadius.circular(56),
        color: Colors.white,
      ),
      child: Row(
        children: [
          WidgetAppSVG(
            'icon29',
            width: 24.sw,
            height: 24.sw,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Search food, restaurant ...'.tr(),
              style: TextStyle(
                color: Color(0xFFAFAFAF),
                fontFamily: 'Fredoka',
                fontSize: 16,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFF74CA45),
              borderRadius: BorderRadius.circular(56),
            ),
            child:   Text(
              'Search'.tr(),
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Fredoka',
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSortBySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Sort by'.tr(),
          style: w500TextStyle(fontSize: 18.sw),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10.sw,
          runSpacing: 10.sw,
          children:
              sortOptions.map((option) => _buildSortOption(option)).toList(),
        ),
      ],
    );
  }

  Widget _buildSortOption(_SortOption option) {
    return GestureDetector(
      onTap: () {
        if (selectedSort.contains(option.id)) {
          selectedSort.remove(option.id);
        } else {
          selectedSort.add(option.id);
        }
        setState(() {});
      },
      child: SizedBox(
        width: context.width * 0.4,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: selectedSort.contains(option.id)
                        ? appColorPrimary
                        : const Color(0xFFBDBDBD),
                    width: 1.5,
                  ),
                ),
                child: selectedSort.contains(option.id)
                    ? Icon(
                        Icons.check,
                        size: 16,
                        color: appColorPrimary,
                      )
                    : const SizedBox.shrink(),
              ),
              const SizedBox(width: 8),
              Text(
                option.label,
                style: const TextStyle(
                  color: Color(0xFF120F0F),
                  fontFamily: 'Fredoka',
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTypeFoodSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Type food'.tr(),
          style: w500TextStyle(fontSize: 18.sw),
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          clipBehavior: Clip.none,
          scrollDirection: Axis.horizontal,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: appProductCategories == null
                ? List.generate(
                    5,
                    (index) => const WidgetCategoryCardShimmer(),
                  )
                : appProductCategories!.map((category) {
                    return WidgetCategoryCard(
                      title: category.name ?? '',
                      imageUrl: category.image ?? '',
                      isSelected: _categoryIdSelected == category.id,
                      onTap: () {
                        appHaptic();
                        _categoryIdSelected = category.id;
                        subTypeIds = [];
                        setState(() {});
                      },
                    );
                  }).toList(),
          ),
        ),
        if (_categoryIdSelected != null)
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              children: appProductCategories!
                      .firstWhere(
                          (category) => category.id == _categoryIdSelected)
                      .children
                      ?.map((category) => _buildFoodTypeChip(category))
                      .toList() ??
                  [],
            ),
          ),
        Gap(16.sw),
      ],
    );
  }

  Widget _buildFoodTypeChip(CategoryModel category) {
    return WidgetInkWellTransparent(
      onTap: () {
        appHaptic();
        if (subTypeIds.contains(category.id)) {
          subTypeIds.remove(category.id);
        } else {
          subTypeIds.add(category.id!);
        }
        setState(() {});
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(
            color: subTypeIds.contains(category.id)
                ? appColorPrimary
                : const Color(0xFFE7E7E7),
          ),
          borderRadius: BorderRadius.circular(46),
          color:
              subTypeIds.contains(category.id) ? appColorPrimary : Colors.white,
        ),
        child: Text(
          category.name ?? '',
          style: w400TextStyle(
            color:
                subTypeIds.contains(category.id) ? Colors.white : appColorText,
          ),
        ),
      ),
    );
  }

  Widget _buildPriceRangeSection() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Price'.tr(),
              style: w500TextStyle(fontSize: 18.sw),
            ),
            Text(
              '${currencyFormatted(priceRange.start)} - ${currencyFormatted(priceRange.end)}',
              style: w400TextStyle(
                fontSize: 16.sw,
                color: appColorText2,
              ),
            ),
          ],
        ),
        16.h,
        Row(
          children: [
            Text(
              currencyFormatted(1000),
              style: w400TextStyle(
                color: appColorText2,
                fontSize: 14.sw,
              ),
            ),
            Expanded(
              child: SliderTheme(
                data: SliderThemeData(
                  rangeThumbShape: RoundRangeSliderThumbShape(
                    enabledThumbRadius: 8,
                  ),
                  activeTrackColor: const Color(0xFFF17228),
                  inactiveTrackColor: const Color(0xFFD6D8E7),
                  thumbColor: Colors.white,
                  overlayColor: const Color(0xFFF17228).withOpacity(0.2),
                ),
                child: RangeSlider(
                  values: priceRange,
                  min: 1000.0,
                  max: 100000.0,
                  onChanged: (RangeValues values) {
                    setState(() {
                      priceRange = values;
                    });
                  },
                ),
              ),
            ),
            Text(
              currencyFormatted(100000),
              style: w400TextStyle(
                color: appColorText2,
                fontSize: 14.sw,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: DottedLine(
        direction: Axis.horizontal,
        alignment: WrapAlignment.center,
        lineLength: double.infinity,
        lineThickness: 1.0,
        dashLength: 4.0,
        dashColor: hexColor('#D1D1D1'),
        dashRadius: 0.0,
        dashGapLength: 4.0,
        dashGapColor: Colors.transparent,
        dashGapRadius: 0.0,
      ),
    );
  }

  Widget _buildBottomButtons() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24.sw),
          bottomRight: Radius.circular(24.sw),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x26000000),
            offset: Offset(17, 10),
            blurRadius: 30,
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: WidgetButtonCancel(
              text: 'Cancel'.tr(),
              onPressed: () {
                context.pop();
              },
              width: 120.sw,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 3,
            child: WidgetButtonConfirm(
              text: 'Apply filters'.tr(),
              onPressed: () {
                context.pop();
                appHaptic();
                List<String> listChip = [];

                if (selectedSort.isNotEmpty) {
                  for (var sort in sortOptions
                      .where((option) => selectedSort.contains(option.id))) {
                    listChip.add(sort.label);
                  }
                }
                if (subTypeIds.isNotEmpty) {
                  listChip.addAll(appProductCategories!
                          .firstWhere(
                              (category) => category.id == _categoryIdSelected)
                          .children
                          ?.where(
                              (category) => subTypeIds.contains(category.id))
                          .map((category) => category.name ?? '')
                          .toList() ??
                      []);
                }
                listChip.add(
                    '${"from".tr()} ${priceRange.start.toStringAsFixed(2)} ${"to".tr()} ${priceRange.end.toStringAsFixed(2)}');

                FilterResultsParams params = FilterResultsParams(
                  name:
                      '${appProductCategories!.firstWhere((category) => category.id == _categoryIdSelected).name} ${"near you".tr()}',
                  listChip: listChip,
                  params: paramFilters,
                );
                context.push('/filter-results', extra: params);
              },
            ),
          ),
        ],
      ),
    );
  }
}
