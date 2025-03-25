class OpeningTimeModel {
  final String day;
  final int dayNumber;
  bool isOpen;
  String openTime;
  String closeTime;

  OpeningTimeModel({
    required this.day,
    required this.dayNumber,
    required this.isOpen,
    required this.openTime,
    required this.closeTime,
  });

  factory OpeningTimeModel.fromJson(Map<String, dynamic> json) {
    return OpeningTimeModel(
      day: json['day'] ?? '',
      dayNumber: json['dayNumber'] ?? 0,
      isOpen: json['isOpen'] ?? false,
      openTime: json['openTime'] ?? '5:00',
      closeTime: json['closeTime'] ?? '23:00',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'day': day,
      'dayNumber': dayNumber,
      'isOpen': isOpen,
      'openTime': openTime,
      'closeTime': closeTime,
    };
  }

  static List<OpeningTimeModel> getDefaultOpeningTimes() {
    return [
      OpeningTimeModel(
        day: 'Monday',
        dayNumber: 1,
        isOpen: true,
        openTime: '5:00',
        closeTime: '16:00',
      ),
      OpeningTimeModel(
        day: 'Tuesday',
        dayNumber: 2,
        isOpen: true,
        openTime: '5:00',
        closeTime: '16:00',
      ),
      OpeningTimeModel(
        day: 'Wednesday',
        dayNumber: 3,
        isOpen: true,
        openTime: '5:00',
        closeTime: '16:00',
      ),
      OpeningTimeModel(
        day: 'Thursday',
        dayNumber: 4,
        isOpen: true,
        openTime: '5:00',
        closeTime: '16:00',
      ),
      OpeningTimeModel(
        day: 'Friday',
        dayNumber: 5,
        isOpen: true,
        openTime: '5:00',
        closeTime: '16:00',
      ),
      OpeningTimeModel(
        day: 'Saturday',
        dayNumber: 6,
        isOpen: true,
        openTime: '5:00',
        closeTime: '16:00',
      ),
      OpeningTimeModel(
        day: 'Sunday',
        dayNumber: 7,
        isOpen: true,
        openTime: '5:00',
        closeTime: '16:00',
      ),
    ];
  }
}
