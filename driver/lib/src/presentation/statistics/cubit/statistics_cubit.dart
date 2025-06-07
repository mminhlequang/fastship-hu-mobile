import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:internal_network/network_resources/resources.dart';
import 'package:network_resources/driver_statistics/models/models.dart';
import 'package:network_resources/driver_statistics/repo.dart';

part 'statistics_state.dart';

/// The cubit for managing the state of the statistics screen.
class StatisticsCubit extends Cubit<StatisticsState> {
  StatisticsCubit() : super(const StatisticsState());

  final DriverStatisticsRepo _repo = DriverStatisticsRepo();

  /// Fetches general statistics overview.
  /// This is a convenience method that calls [getOverview].
  Future<void> getStatistics({Map<String, dynamic> params = const {}}) async {
    await getOverview(params);
  }

  /// Fetches the statistics overview from the repository.
  Future<void> getOverview(Map<String, dynamic> params) async {
    emit(state.copyWith(status: StatisticsStatus.loading));
    try {
      final response = await _repo.getOverview(params);
      if (response.isSuccess) {
        emit(state.copyWith(
          status: StatisticsStatus.success,
          overview: response.data,
        ));
      } else {
        emit(state.copyWith(
          status: StatisticsStatus.failure,
          errorMessage: response.msg,
        ));
      }
    } catch (e) {
      emit(state.copyWith(
          status: StatisticsStatus.failure, errorMessage: e.toString()));
    }
  }

  /// Fetches the income chart data from the repository.
  Future<void> getIncomeChart(Map<String, dynamic> params) async {
    emit(state.copyWith(status: StatisticsStatus.loading));
    try {
      final response = await _repo.getIncomeChart(params);
      if (response.isSuccess) {
        emit(state.copyWith(
          status: StatisticsStatus.success,
          incomeChart: response.data,
        ));
      } else {
        emit(state.copyWith(
          status: StatisticsStatus.failure,
          errorMessage: response.msg,
        ));
      }
    } catch (e) {
      emit(state.copyWith(
          status: StatisticsStatus.failure, errorMessage: e.toString()));
    }
  }

  /// Fetches the trips chart data from the repository.
  Future<void> getTripsChart(Map<String, dynamic> params) async {
    emit(state.copyWith(status: StatisticsStatus.loading));
    try {
      final response = await _repo.getTripsChart(params);
      if (response.isSuccess) {
        emit(state.copyWith(
          status: StatisticsStatus.success,
          tripsChart: response.data,
        ));
      } else {
        emit(state.copyWith(
          status: StatisticsStatus.failure,
          errorMessage: response.msg,
        ));
      }
    } catch (e) {
      emit(state.copyWith(
          status: StatisticsStatus.failure, errorMessage: e.toString()));
    }
  }

  /// Fetches the income breakdown data from the repository.
  Future<void> getIncomeBreakdown(Map<String, dynamic> params) async {
    emit(state.copyWith(status: StatisticsStatus.loading));
    try {
      final response = await _repo.getIncomeBreakdown(params);
      if (response.isSuccess) {
        emit(state.copyWith(
          status: StatisticsStatus.success,
          incomeBreakdown: response.data,
        ));
      } else {
        emit(state.copyWith(
          status: StatisticsStatus.failure,
          errorMessage: response.msg,
        ));
      }
    } catch (e) {
      emit(state.copyWith(
          status: StatisticsStatus.failure, errorMessage: e.toString()));
    }
  }

  /// Fetches the time chart data from the repository.
  Future<void> getTimeChart(Map<String, dynamic> params) async {
    emit(state.copyWith(status: StatisticsStatus.loading));
    try {
      final response = await _repo.getTimeChart(params);
      if (response.isSuccess) {
        emit(state.copyWith(
          status: StatisticsStatus.success,
          timeChart: response.data,
        ));
      } else {
        emit(state.copyWith(
          status: StatisticsStatus.failure,
          errorMessage: response.msg,
        ));
      }
    } catch (e) {
      emit(state.copyWith(
          status: StatisticsStatus.failure, errorMessage: e.toString()));
    }
  }

  /// Fetches the details data from the repository.
  Future<void> getDetails(Map<String, dynamic> params) async {
    emit(state.copyWith(status: StatisticsStatus.loading));
    try {
      final response = await _repo.getDetails(params);
      if (response.isSuccess) {
        emit(state.copyWith(
          status: StatisticsStatus.success,
          details: response.data,
        ));
      } else {
        emit(state.copyWith(
          status: StatisticsStatus.failure,
          errorMessage: response.msg,
        ));
      }
    } catch (e) {
      emit(state.copyWith(
          status: StatisticsStatus.failure, errorMessage: e.toString()));
    }
  }
}
