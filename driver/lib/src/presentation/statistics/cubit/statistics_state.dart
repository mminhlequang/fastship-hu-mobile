part of 'statistics_cubit.dart';

/// The status of the statistics data fetching process.
enum StatisticsStatus { initial, loading, success, failure }

/// The state for the statistics screen.
/// It holds the data for various statistics sections.
class StatisticsState extends Equatable {
  const StatisticsState({
    this.status = StatisticsStatus.initial,
    this.overview,
    this.incomeChart,
    this.tripsChart,
    this.incomeBreakdown,
    this.timeChart,
    this.details,
    this.errorMessage,
  });

  /// The current status of the data fetching.
  final StatisticsStatus status;

  /// The data for the overview section.
  final DriverStatisticOverviewModel? overview;

  /// The data for the income chart.
  final DriverStatIncomeChart? incomeChart;

  /// The data for the trips chart.
  final DriverStatTripsChart? tripsChart;

  /// The data for the income breakdown.
  final DriverStatIncomeBreakdown? incomeBreakdown;

  /// The data for the time chart.
  final DriverStatTimeChart? timeChart;

  /// The data for the details section.
  final DriverStatDetail? details;

  /// The error message if data fetching fails.
  final String? errorMessage;

  StatisticsState copyWith({
    StatisticsStatus? status,
    DriverStatisticOverviewModel? overview,
    DriverStatIncomeChart? incomeChart,
    DriverStatTripsChart? tripsChart,
    DriverStatIncomeBreakdown? incomeBreakdown,
    DriverStatTimeChart? timeChart,
    DriverStatDetail? details,
    String? errorMessage,
  }) {
    return StatisticsState(
      status: status ?? this.status,
      overview: overview ?? this.overview,
      incomeChart: incomeChart ?? this.incomeChart,
      tripsChart: tripsChart ?? this.tripsChart,
      incomeBreakdown: incomeBreakdown ?? this.incomeBreakdown,
      timeChart: timeChart ?? this.timeChart,
      details: details ?? this.details,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        overview,
        incomeChart,
        tripsChart,
        incomeBreakdown,
        timeChart,
        details,
        errorMessage,
      ];
}
