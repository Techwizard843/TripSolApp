class Train {
  final String trainName;
  final String departure;
  final String arrival;
  final String price;
  final String duration;

  Train({
    required this.trainName,
    required this.departure,
    required this.arrival,
    required this.price,
    required this.duration,
  });

  factory Train.fromJson(Map<String, dynamic> json) {
    return Train(
      trainName: json['train_name'] ?? '',
      departure: json['departure'] ?? '',
      arrival: json['arrival'] ?? '',
      price: json['price']?.toString() ?? '',
      duration: json['duration'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'train_name': trainName,
      'departure': departure,
      'arrival': arrival,
      'price': price,
      'duration': duration,
    };
  }
}
