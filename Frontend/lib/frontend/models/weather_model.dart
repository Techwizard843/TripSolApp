class Weather {
  final String description;
  final String temperature;
  final String humidity;
  final String windSpeed;

  Weather({
    required this.description,
    required this.temperature,
    required this.humidity,
    required this.windSpeed,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      description: json['description'] ?? '',
      temperature: json['temperature']?.toString() ?? '',
      humidity: json['humidity']?.toString() ?? '',
      windSpeed: json['wind_speed']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'description': description,
      'temperature': temperature,
      'humidity': humidity,
      'wind_speed': windSpeed,
    };
  }
}
