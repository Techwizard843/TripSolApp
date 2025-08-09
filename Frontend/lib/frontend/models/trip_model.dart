class Trip {
  final String tripName;
  final String startDate;
  final String endDate;
  final List<String> preferences;

  Trip({
    required this.tripName,
    required this.startDate,
    required this.endDate,
    required this.preferences,
  });

  factory Trip.fromJson(Map<String, dynamic> json) {
    return Trip(
      tripName: json['tripName'] ?? '',
      startDate: json['startDate'] ?? '',
      endDate: json['endDate'] ?? '',
      preferences: List<String>.from(json['preferences'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tripName': tripName,
      'startDate': startDate,
      'endDate': endDate,
      'preferences': preferences,
    };
  }
}
