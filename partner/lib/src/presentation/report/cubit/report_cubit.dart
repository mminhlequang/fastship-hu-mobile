import 'package:app/src/base/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:internal_core/internal_core.dart';
import 'package:network_resources/reports/models/models.dart';
import 'package:network_resources/reports/repo.dart';

enum ReportStatus { initial, loading, success, failure }

class ReportState extends Equatable {
  final ReportStatus status;
  final ReportOverviewModel? overview;
  final ReportRevenueChartModel? revenueChart;
  final List<ReportTopSellingItemModel> topSellingItems;
  final List<ReportRecentReviewModel> recentReviews;
  final List<Map<String, dynamic>> recentOrders;
  final List<Map<String, dynamic>> cancelledOrders;
  final String error;

  const ReportState({
    this.status = ReportStatus.initial,
    this.overview,
    this.revenueChart,
    this.topSellingItems = const [],
    this.recentReviews = const [],
    this.recentOrders = const [],
    this.cancelledOrders = const [],
    this.error = '',
  });

  ReportState copyWith({
    ReportStatus? status,
    ReportOverviewModel? overview,
    ReportRevenueChartModel? revenueChart,
    List<ReportTopSellingItemModel>? topSellingItems,
    List<ReportRecentReviewModel>? recentReviews,
    List<Map<String, dynamic>>? recentOrders,
    List<Map<String, dynamic>>? cancelledOrders,
    String? error,
  }) {
    return ReportState(
      status: status ?? this.status,
      overview: overview ?? this.overview,
      revenueChart: revenueChart ?? this.revenueChart,
      topSellingItems: topSellingItems ?? this.topSellingItems,
      recentReviews: recentReviews ?? this.recentReviews,
      recentOrders: recentOrders ?? this.recentOrders,
      cancelledOrders: cancelledOrders ?? this.cancelledOrders,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [
        status,
        overview,
        revenueChart,
        topSellingItems,
        recentReviews,
        recentOrders,
        cancelledOrders,
        error,
      ];
}

class ReportCubit extends Cubit<ReportState> {
  ReportCubit() : super(const ReportState());

  Future<void> fetchReport() async {
    emit(state.copyWith(status: ReportStatus.loading));

    try {
      final responseOverview = await StoreReportRepo().getReportOverview({
        'store_id': authCubit.storeId,
        'date': DateTime.now().formatDate(formatType: 'yyyy-MM-dd'),
      });
      ReportOverviewModel? overview;
      if (responseOverview.isSuccess) {
        overview = responseOverview.data;
      }

      final responseRevenueChart = await StoreReportRepo().getRevenueChart({
        'store_id': authCubit.storeId,
        'period': 'daily',
        'start_date': DateTime.now()
            .subtract(const Duration(days: 30))
            .formatDate(formatType: 'yyyy-MM-dd'),
        'end_date': DateTime.now().formatDate(formatType: 'yyyy-MM-dd'),
      });
      ReportRevenueChartModel? revenueChart;
      if (responseRevenueChart.isSuccess) {
        revenueChart = responseRevenueChart.data;
      }

      final responseTopSellingItems = await StoreReportRepo().getTopSellingItems({
        'store_id': authCubit.storeId,
        "limit": 10,
        "start_date": DateTime.now()
            .subtract(const Duration(days: 30))
            .formatDate(formatType: 'yyyy-MM-dd'),
        "end_date": DateTime.now().formatDate(formatType: 'yyyy-MM-dd'),
      });
      List<ReportTopSellingItemModel>? topSellingItems;
      if (responseTopSellingItems.isSuccess) {
        topSellingItems = responseTopSellingItems.data;
      }

      final responseRecentReviews = await StoreReportRepo().getRecentReviews({
        'store_id': authCubit.storeId,
        "limit": 10,
        "days": 30,
      });
      List<ReportRecentReviewModel>? recentReviews;
      if (responseRecentReviews.isSuccess) {
        recentReviews = responseRecentReviews.data;
      }

      emit(
        state.copyWith(
          status: ReportStatus.success,
          overview: overview,
          revenueChart: revenueChart,
          topSellingItems: topSellingItems,
          recentReviews: recentReviews,
          // recentOrders: recentOrders,
          // cancelledOrders: cancelledOrders,
        ),
      );
    } catch (e) {
      emit(state.copyWith(
        status: ReportStatus.failure,
        error: e.toString(),
      ));
    }
  }
}
