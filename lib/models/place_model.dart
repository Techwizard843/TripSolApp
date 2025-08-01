class Place {
  final String title;
  final String description;
  final String imageUrl;
  final List<String> tripPlan;
  final String budget;
  final String travelMode;

  Place({
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.tripPlan,
    required this.budget,
    required this.travelMode,
  });

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      tripPlan: List<String>.from(json['tripPlan'] ?? []),
      budget: json['budget'] ?? '',
      travelMode: json['travelMode'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'tripPlan': tripPlan,
      'budget': budget,
      'travelMode': travelMode,
    };
  }
}
