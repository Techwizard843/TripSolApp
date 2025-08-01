class Trip {
  final String id;
  final String userId;
  final String destination;
  final String startDate;
  final String endDate;

  Trip({
    required this.id,
    required this.userId,
    required this.destination,
    required this.startDate,
    required this.endDate,
  });

  factory Trip.fromJson(Map<String, dynamic> json) {
    return Trip(
      id: json['_id'] ?? '',
      userId: json['userId'] ?? '',
      destination: json['destination'] ?? '',
      startDate: json['startDate'] ?? '',
      endDate: json['endDate'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "userId": userId,
      "destination": destination,
      "startDate": startDate,
      "endDate": endDate,
    };
  }
}
