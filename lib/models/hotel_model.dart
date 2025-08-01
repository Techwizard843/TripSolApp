class Hotel {
  final String name;
  final String address;
  final double pricePerNight;
  final double rating;
  final String imageUrl;

  Hotel({
    required this.name,
    required this.address,
    required this.pricePerNight,
    required this.rating,
    required this.imageUrl,
  });

  factory Hotel.fromJson(Map<String, dynamic> json) {
    return Hotel(
      name: json['name'] ?? '',
      address: json['address'] ?? '',
      pricePerNight: (json['pricePerNight'] ?? 0).toDouble(),
      rating: (json['rating'] ?? 0).toDouble(),
      imageUrl: json['imageUrl'] ?? '',
    );
  }
}
