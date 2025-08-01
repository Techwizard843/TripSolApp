class WeatherInfo {
  final String city;
  final double temperature;
  final String condition;
  final double humidity;
  final double windSpeed;
  final String iconUrl;

  WeatherInfo({
    required this.city,
    required this.temperature,
    required this.condition,
    required this.humidity,
    required this.windSpeed,
    required this.iconUrl,
  });

  factory WeatherInfo.fromJson(Map<String, dynamic> json) {
    return WeatherInfo(
      city: json['city'] ?? '',
      temperature: (json['temperature'] ?? 0).toDouble(),
      condition: json['condition'] ?? '',
      humidity: (json['humidity'] ?? 0).toDouble(),
      windSpeed: (json['windSpeed'] ?? 0).toDouble(),
      iconUrl: json['iconUrl'] ?? '',
    );
  }
}
