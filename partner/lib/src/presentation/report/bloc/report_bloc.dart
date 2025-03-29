import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

// Events
abstract class ReportEvent extends Equatable {
  const ReportEvent();

  @override
  List<Object> get props => [];
}

class ReportFetched extends ReportEvent {}

// States
enum ReportStatus { initial, loading, success, failure }

class ReportState extends Equatable {
  final ReportStatus status;
  final List<Map<String, dynamic>> orders;
  final double totalRevenue;
  final String error;

  const ReportState({
    this.status = ReportStatus.initial,
    this.orders = const [],
    this.totalRevenue = 0.0,
    this.error = '',
  });

  ReportState copyWith({
    ReportStatus? status,
    List<Map<String, dynamic>>? orders,
    double? totalRevenue,
    String? error,
  }) {
    return ReportState(
      status: status ?? this.status,
      orders: orders ?? this.orders,
      totalRevenue: totalRevenue ?? this.totalRevenue,
      error: error ?? this.error,
    );
  }

  @override
  List<Object> get props => [status, orders, totalRevenue, error];
}

class ReportBloc extends Bloc<ReportEvent, ReportState> {
  ReportBloc() : super(const ReportState()) {
    on<ReportFetched>(_onReportFetched);
  }

  Future<void> _onReportFetched(
    ReportFetched event,
    Emitter<ReportState> emit,
  ) async {
    emit(state.copyWith(status: ReportStatus.loading));

    try {
      await Future.delayed(const Duration(seconds: 2)); // Simulate API call

      // Mock data
      final mockOrders = List.generate(
        10,
        (index) => {
          'id': '1234563',
          'date': '24/02/2025',
          'time': '11:11',
          'amount': 10.0,
          'items': [
            {
              'name': 'Vanilla Latte Milk',
              'description': 'Espresso,Vanilla Syrup, Fresh Mink, Fresh Milk',
              'price': 10.0,
            }
          ],
        },
      );

      final totalRevenue = mockOrders.fold<double>(
        0,
        (sum, order) => sum + (order['amount'] as double),
      );

      emit(
        state.copyWith(
          status: ReportStatus.success,
          orders: mockOrders,
          totalRevenue: totalRevenue,
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
