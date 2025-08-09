class Flight {
  final String airline;
  final String departure;
  final String arrival;
  final String price;
  final String duration;

  Flight({
    required this.airline,
    required this.departure,
    required this.arrival,
    required this.price,
    required this.duration,
  });

  factory Flight.fromJson(Map<String, dynamic> json) {
    return Flight(
      airline: json['airline'] ?? '',
      departure: json['departure'] ?? '',
      arrival: json['arrival'] ?? '',
      price: json['price']?.toString() ?? '',
      duration: json['duration'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'airline': airline,
      'departure': departure,
      'arrival': arrival,
      'price': price,
      'duration': duration,
    };
  }
}
