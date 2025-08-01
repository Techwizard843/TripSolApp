class Flight {
  final String airline;
  final String flightNumber;
  final String departureTime;
  final String arrivalTime;
  final String duration;
  final double price;

  Flight({
    required this.airline,
    required this.flightNumber,
    required this.departureTime,
    required this.arrivalTime,
    required this.duration,
    required this.price,
  });

  factory Flight.fromJson(Map<String, dynamic> json) {
    return Flight(
      airline: json['airline'] ?? '',
      flightNumber: json['flightNumber'] ?? '',
      departureTime: json['departureTime'] ?? '',
      arrivalTime: json['arrivalTime'] ?? '',
      duration: json['duration'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
    );
  }
}
