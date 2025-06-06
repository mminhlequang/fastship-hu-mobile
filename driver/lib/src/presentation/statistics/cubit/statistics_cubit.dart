import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:network_resources/driver_statistics/repo.dart';

class StatisticsCubit extends Cubit<StatisticsState> {
  StatisticsCubit() : super(StatisticsState());

  void getStatistics() async {
    // DriverStatisticsRepo().;
  }
}

class StatisticsState {}
