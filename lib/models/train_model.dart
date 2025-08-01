class Train {
  final String trainName;
  final String trainNumber;
  final String departureTime;
  final String arrivalTime;
  final String duration;
  final double price;

  Train({
    required this.trainName,
    required this.trainNumber,
    required this.departureTime,
    required this.arrivalTime,
    required this.duration,
    required this.price,
  });

  factory Train.fromJson(Map<String, dynamic> json) {
    return Train(
      trainName: json['trainName'] ?? '',
      trainNumber: json['trainNumber'] ?? '',
      departureTime: json['departureTime'] ?? '',
      arrivalTime: json['arrivalTime'] ?? '',
      duration: json['duration'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
    );
  }
}
