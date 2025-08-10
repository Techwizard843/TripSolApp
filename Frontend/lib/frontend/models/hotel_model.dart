class Hotel {
  final String name;
  final String location;
  final String price;
  final String rating;

  Hotel({
    required this.name,
    required this.location,
    required this.price,
    required this.rating,
  });

  factory Hotel.fromJson(Map<String, dynamic> json) {
    return Hotel(
      name: json['name'] ?? '',
      location: json['location'] ?? '',
      price: json['price']?.toString() ?? '',
      rating: json['rating']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'location': location,
      'price': price,
      'rating': rating,
    };
  }
}
