import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

enum ReportStatus { initial, loading, success, failure }

// Model cho thống kê tổng quan
class ReportOverview {
  final double todayRevenue;
  final double yesterdayRevenue;
  final int todayOrders;
  final int yesterdayOrders;
  final int totalCustomers;
  final double avgOrderValue;
  final double growthRate;

  const ReportOverview({
    required this.todayRevenue,
    required this.yesterdayRevenue,
    required this.todayOrders,
    required this.yesterdayOrders,
    required this.totalCustomers,
    required this.avgOrderValue,
    required this.growthRate,
  });
}

// Model cho doanh thu theo thời gian
class RevenueChart {
  final List<ChartData> dailyRevenue;
  final List<ChartData> weeklyRevenue;
  final List<ChartData> monthlyRevenue;

  const RevenueChart({
    required this.dailyRevenue,
    required this.weeklyRevenue,
    required this.monthlyRevenue,
  });
}

class ChartData {
  final String period;
  final double value;
  final DateTime date;

  const ChartData({
    required this.period,
    required this.value,
    required this.date,
  });
}

// Model cho món ăn bán chạy
class TopSellingItem {
  final String name;
  final String image;
  final int quantity;
  final double revenue;

  const TopSellingItem({
    required this.name,
    required this.image,
    required this.quantity,
    required this.revenue,
  });
}

// Model cho đánh giá khách hàng
class CustomerReview {
  final String customerName;
  final String customerAvatar;
  final double rating;
  final String comment;
  final DateTime date;

  const CustomerReview({
    required this.customerName,
    required this.customerAvatar,
    required this.rating,
    required this.comment,
    required this.date,
  });
}

class ReportState extends Equatable {
  final ReportStatus status;
  final ReportOverview? overview;
  final RevenueChart? revenueChart;
  final List<TopSellingItem> topSellingItems;
  final List<CustomerReview> recentReviews;
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
    ReportOverview? overview,
    RevenueChart? revenueChart,
    List<TopSellingItem>? topSellingItems,
    List<CustomerReview>? recentReviews,
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
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      // Mock overview data
      final overview = ReportOverview(
        todayRevenue: 2450000,
        yesterdayRevenue: 1890000,
        todayOrders: 45,
        yesterdayOrders: 38,
        totalCustomers: 234,
        avgOrderValue: 125000,
        growthRate: 29.6,
      );

      // Mock revenue chart data
      final now = DateTime.now();
      final revenueChart = RevenueChart(
        dailyRevenue: List.generate(7, (index) {
          final date = now.subtract(Duration(days: 6 - index));
          return ChartData(
            period: _getDayName(date.weekday),
            value: 1200000 + (index * 200000) + (index % 2 * 300000),
            date: date,
          );
        }),
        weeklyRevenue: List.generate(4, (index) {
          final value = 8500000 + (index * 1200000);
          return ChartData(
            period: 'Week ${index + 1}',
            value: value.toDouble(),
            date: now.subtract(Duration(days: (3 - index) * 7)),
          );
        }),
        monthlyRevenue: List.generate(6, (index) {
          final value = 25000000 + (index * 3000000);
          return ChartData(
            period: _getMonthName(now.month - (5 - index)),
            value: value.toDouble(),
            date: DateTime(now.year, now.month - (5 - index)),
          );
        }),
      );

      // Mock top selling items
      final topSellingItems = [
        TopSellingItem(
          name: 'Beef Pho',
          image: 'assets/images/pho_bo.jpg',
          quantity: 89,
          revenue: 1780000,
        ),
        TopSellingItem(
          name: 'Hue Beef Noodle',
          image: 'assets/images/bun_bo_hue.jpg',
          quantity: 67,
          revenue: 1340000,
        ),
        TopSellingItem(
          name: 'Chicken Rice',
          image: 'assets/images/com_ga.jpg',
          quantity: 56,
          revenue: 1120000,
        ),
        TopSellingItem(
          name: 'Grilled Pork Banh Mi',
          image: 'assets/images/banh_mi.jpg',
          quantity: 45,
          revenue: 675000,
        ),
      ];

      // Mock recent reviews
      final recentReviews = [
        CustomerReview(
          customerName: 'Nguyễn Văn A',
          customerAvatar: 'https://via.placeholder.com/100',
          rating: 5.0,
          comment: 'Đồ ăn rất ngon, giao hàng nhanh!',
          date: now.subtract(const Duration(hours: 2)),
        ),
        CustomerReview(
          customerName: 'Trần Thị B',
          customerAvatar: 'https://via.placeholder.com/100',
          rating: 4.5,
          comment: 'Chất lượng tốt, sẽ đặt lại.',
          date: now.subtract(const Duration(hours: 5)),
        ),
        CustomerReview(
          customerName: 'Lê Văn C',
          customerAvatar: 'https://via.placeholder.com/100',
          rating: 4.8,
          comment: 'Phở rất đậm đà, thích lắm!',
          date: now.subtract(const Duration(hours: 8)),
        ),
      ];

      // Mock recent orders
      final recentOrders = List.generate(
        15,
        (index) => {
          'id': '${10000 + index}',
          'date': _formatDate(now.subtract(Duration(hours: index * 2))),
          'time': _formatTime(now.subtract(Duration(hours: index * 2))),
          'amount': 120000.0 + (index * 15000),
          'customerName': 'Khách hàng ${index + 1}',
          'status': index % 4 == 0 ? 'completed' : 'pending',
          'items': [
            {
              'name': 'Phở Bò Tái',
              'description': 'Nước dùng trong, thịt bò tươi',
              'price': 85000.0,
              'quantity': 1,
            },
            {
              'name': 'Trà Đá',
              'description': 'Trà đá mát lạnh',
              'price': 5000.0,
              'quantity': 2,
            }
          ],
        },
      );

      // Mock cancelled orders
      final cancelledOrders = List.generate(
        5,
        (index) => {
          'id': '${20000 + index}',
          'date': _formatDate(now.subtract(Duration(days: index + 1))),
          'time': _formatTime(now.subtract(Duration(days: index + 1))),
          'amount': 95000.0 + (index * 12000),
          'customerName': 'Khách hàng ${index + 10}',
          'reason': index % 2 == 0 ? 'Khách hàng hủy' : 'Hết nguyên liệu',
          'items': [
            {
              'name': 'Bún Bò Huế',
              'description': 'Bún bò cay nồng đặc trưng Huế',
              'price': 90000.0,
              'quantity': 1,
            }
          ],
        },
      );

      emit(
        state.copyWith(
          status: ReportStatus.success,
          overview: overview,
          revenueChart: revenueChart,
          topSellingItems: topSellingItems,
          recentReviews: recentReviews,
          recentOrders: recentOrders,
          cancelledOrders: cancelledOrders,
        ),
      );
    } catch (e) {
      emit(state.copyWith(
        status: ReportStatus.failure,
        error: e.toString(),
      ));
    }
  }

  String _getDayName(int weekday) {
    const days = ['CN', 'T2', 'T3', 'T4', 'T5', 'T6', 'T7'];
    return days[weekday % 7];
  }

  String _getMonthName(int month) {
    const months = [
      'T1',
      'T2',
      'T3',
      'T4',
      'T5',
      'T6',
      'T7',
      'T8',
      'T9',
      'T10',
      'T11',
      'T12'
    ];
    final adjustedMonth = month <= 0 ? month + 12 : month;
    return months[(adjustedMonth - 1) % 12];
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  String _formatTime(DateTime date) {
    return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}
