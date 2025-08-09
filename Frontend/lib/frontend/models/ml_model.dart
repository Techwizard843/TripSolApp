class Recommendation {
  final String attraction;
  final String entryFee;
  final String timeRequired;
  final String bestTimeToVisit;

  Recommendation({
    required this.attraction,
    required this.entryFee,
    required this.timeRequired,
    required this.bestTimeToVisit,
  });

  factory Recommendation.fromJson(Map<String, dynamic> json) {
    return Recommendation(
      attraction: json['attraction'] ?? '',
      entryFee: json['entry_fee'] ?? '',
      timeRequired: json['time_required'] ?? '',
      bestTimeToVisit: json['best_time_to_visit'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'attraction': attraction,
      'entry_fee': entryFee,
      'time_required': timeRequired,
      'best_time_to_visit': bestTimeToVisit,
    };
  }
}
