class Food {
  final String name;
  final String type;
  final String location;
  final String rating;

  Food({
    required this.name,
    required this.type,
    required this.location,
    required this.rating,
  });

  factory Food.fromJson(Map<String, dynamic> json) {
    return Food(
      name: json['name'] ?? '',
      type: json['type'] ?? '',
      location: json['location'] ?? '',
      rating: json['rating']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'type': type, 'location': location, 'rating': rating};
  }
}
