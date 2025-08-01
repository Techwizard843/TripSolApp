class FoodPlace {
  final String name;
  final String address;
  final double rating;
  final String cuisine;
  final String imageUrl;

  FoodPlace({
    required this.name,
    required this.address,
    required this.rating,
    required this.cuisine,
    required this.imageUrl,
  });

  factory FoodPlace.fromJson(Map<String, dynamic> json) {
    return FoodPlace(
      name: json['name'] ?? '',
      address: json['address'] ?? '',
      rating: (json['rating'] ?? 0).toDouble(),
      cuisine: json['cuisine'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
    );
  }
}
