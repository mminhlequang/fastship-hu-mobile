import 'dart:ui';

import 'package:app/src/base/auth/auth_cubit.dart';
import 'package:app/src/constants/constants.dart';
import 'package:network_resources/transaction/models/models.dart';
import 'package:network_resources/transaction/repo.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:internal_core/internal_core.dart';

import '../widgets/widgets.dart';

// Enum để quản lý các lựa chọn filter thời gian
enum DateFilterOption {
  all,
  today,
  yesterday,
  latest7Days,
  oneMonth,
  twoMonths,
}

// Extension để hiển thị text của filter
extension DateFilterOptionExtension on DateFilterOption {
  String get label {
    switch (this) {
      case DateFilterOption.all:
        return 'All'.tr();
      case DateFilterOption.today:
        return 'Today'.tr();
      case DateFilterOption.yesterday:
        return 'Yesterday'.tr();
      case DateFilterOption.latest7Days:
        return 'Latest 7 days'.tr();
      case DateFilterOption.oneMonth:
        return '1 month'.tr();
      case DateFilterOption.twoMonths:
        return '2 months'.tr();
    }
  }
}

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  bool isLoading = false;
  List<TransactionModel>? transactions;
  bool _isLoadingTransactions = true;
  bool hidePass = true;
  // Thêm biến để lưu filter hiện tại
  DateFilterOption _selectedFilter = DateFilterOption.all;

  @override
  void initState() {
    super.initState();
    _fetchTransactions();
  }

  // Hàm chuyển đổi từ DateFilterOption sang from_date và to_date
  Map<String, String> _getDateRangeFromFilter(DateFilterOption filter) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    String? fromDate;
    String? toDate;

    switch (filter) {
      case DateFilterOption.all:
        // Không cần filter date
        break;
      case DateFilterOption.today:
        fromDate = _formatDate(today);
        toDate = _formatDate(today);
        break;
      case DateFilterOption.yesterday:
        final yesterday = today.subtract(const Duration(days: 1));
        fromDate = _formatDate(yesterday);
        toDate = _formatDate(yesterday);
        break;
      case DateFilterOption.latest7Days:
        final sevenDaysAgo = today.subtract(const Duration(days: 6));
        fromDate = _formatDate(sevenDaysAgo);
        toDate = _formatDate(today);
        break;
      case DateFilterOption.oneMonth:
        // Lấy 30 ngày gần nhất
        final oneMonthAgo = today.subtract(const Duration(days: 29));
        fromDate = _formatDate(oneMonthAgo);
        toDate = _formatDate(today);
        break;
      case DateFilterOption.twoMonths:
        // Lấy 60 ngày gần nhất
        final twoMonthsAgo = today.subtract(const Duration(days: 59));
        fromDate = _formatDate(twoMonthsAgo);
        toDate = _formatDate(today);
        break;
    }

    final result = <String, String>{};
    if (fromDate != null) result['from_date'] = fromDate;
    if (toDate != null) result['to_date'] = toDate;

    return result;
  }

  // Hàm format date theo định dạng Y-m-d
  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  Future<void> _fetchTransactions() async {
    authCubit.fetchWallet();
    setState(() {
      _isLoadingTransactions = true;
    });

    // Lấy tham số date range từ filter đã chọn
    final dateRange = _getDateRangeFromFilter(_selectedFilter);

    // Truyền tham số vào API call
    final response = await TransactionRepo().getTransactions(
      {
        "store_id": authCubit.storeId,
        'from_date': dateRange['from_date'],
        'to_date': dateRange['to_date'],
      },
    );

    setState(() {
      transactions = response.data ?? [];
      _isLoadingTransactions = false;
    });
  }

  // Hàm thay đổi filter và fetch lại data
  void _changeFilter(DateFilterOption filter) {
    if (_selectedFilter != filter) {
      setState(() {
        _selectedFilter = filter;
      });
      _fetchTransactions();
    }
  }

  // Widget hiển thị các filter chip
  Widget _buildFilterChips() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.sw, horizontal: 16.sw),
      child: Wrap(
        spacing: 12.sw,
        runSpacing: 0,
        children: DateFilterOption.values.map((filter) {
          final isSelected = _selectedFilter == filter;

          return FilterChip(
            label: Text(
              filter.label,
              style: w400TextStyle(
                color: isSelected ? Colors.white : null,
                fontSize: 14.sw,
              ),
            ),
            selected: isSelected,
            onSelected: (_) => _changeFilter(filter),
            backgroundColor: Colors.grey.shade200,
            selectedColor: appColorPrimary,
            checkmarkColor: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 4.sw),
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appColorBackground,
      appBar: AppBar(
        title: Text('Transactions'.tr()),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Thêm filter chips vào đây
          _buildFilterChips(),
          SizedBox(height: 8.sw),
          Expanded(
            child: _isLoadingTransactions
                ? ListView.separated(
                    padding: EdgeInsets.symmetric(horizontal: 16.sw),
                    itemCount: 10,
                    separatorBuilder: (context, index) => const AppDivider(),
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.only(
                          top: index == 0 ? 0 : 8.sw,
                          bottom: 8.sw,
                        ),
                        child: Row(
                          children: [
                            WidgetAppShimmer(
                              height: 32.sw,
                              width: 32.sw,
                              borderRadius: BorderRadius.circular(16.sw),
                            ),
                            Gap(8.sw),
                            Expanded(
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      WidgetAppShimmer(
                                        height: 17.sw,
                                        width: 120.sw,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      WidgetAppShimmer(
                                        height: 17.sw,
                                        width: 56.sw,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    ],
                                  ),
                                  Gap(4.sw),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      WidgetAppShimmer(
                                        height: 15.sw,
                                        width: 105.sw,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      WidgetAppShimmer(
                                        height: 15.sw,
                                        width: 48.sw,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  )
                : transactions!.isEmpty
                    ? Padding(
                        padding: EdgeInsets.only(top: 20.sw),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            WidgetAppSVG('ic_empty_transaction'),
                            Gap(16.sw),
                            Text(
                              'There\'s nothing here...yet'.tr(),
                              style: w500TextStyle(fontSize: 18.sw),
                              textAlign: TextAlign.center,
                            ),
                            Gap(4.sw),
                            Text(
                              'We\'ll let you know when we get news for you'
                                  .tr(),
                              style: w400TextStyle(color: grey1),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: () async => await _fetchTransactions(),
                        child: ListView.separated(
                          padding: EdgeInsets.symmetric(horizontal: 16.sw),
                          itemCount: transactions!.length,
                          separatorBuilder: (context, index) =>
                              const AppDivider(),
                          itemBuilder: (context, index) {
                            final transaction = transactions![index];
                            bool isDeposit =
                                transaction.type?.toLowerCase() == 'deposit';

                            return Padding(
                              padding: EdgeInsets.only(
                                top: index == 0 ? 0 : 8.sw,
                                bottom: 8.sw,
                              ),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 16.sw,
                                    backgroundColor: hexColor('#F9F9F9'),
                                    child: WidgetAppSVG(
                                      isDeposit ? 'wallet-add' : 'wallet-minus',
                                      width: 24.sw,
                                    ),
                                  ),
                                  Gap(8.sw),
                                  Expanded(
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              isDeposit
                                                  ? 'Depositing money'.tr()
                                                  : 'Withdrawing money'.tr(),
                                              style: w400TextStyle(),
                                            ),
                                            Text(
                                              '\$${(transaction.price ?? 0).toStringAsFixed(2)}',
                                              style: w400TextStyle(),
                                            ),
                                          ],
                                        ),
                                        Gap(2.sw),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              string2DateTime(transaction
                                                          .createdAt!)
                                                      ?.toLocal()
                                                      .formatDateTime() ??
                                                  '',
                                              style: w400TextStyle(
                                                fontSize: 12.sw,
                                                color: grey1,
                                              ),
                                            ),
                                            Text(
                                              'Success'.tr(),
                                              style: w400TextStyle(
                                                fontSize: 12.sw,
                                                color: green2,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}
