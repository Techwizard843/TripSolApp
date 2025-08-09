class Place {
  final String title;
  final String imageUrl;
  final String budget;
  final String travelMode;
  final String tripPlan;
  final String description;

  Place({
    required this.title,
    required this.imageUrl,
    required this.budget,
    required this.travelMode,
    required this.tripPlan,
    required this.description,
  });

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      title: json['title'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      budget: json['budget']?.toString() ?? '',
      travelMode: json['travelMode'] ?? '',
      tripPlan: json['tripPlan'] ?? '',
      description: json['description'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'imageUrl': imageUrl,
      'budget': budget,
      'travelMode': travelMode,
      'tripPlan': tripPlan,
      'description': description,
    };
  }
}
