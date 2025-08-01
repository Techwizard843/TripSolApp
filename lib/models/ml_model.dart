class MLRecommendation {
  final String title;
  final String imageUrl;
  final String description;
  final String category;

  MLRecommendation({
    required this.title,
    required this.imageUrl,
    required this.description,
    required this.category,
  });

  factory MLRecommendation.fromJson(Map<String, dynamic> json) {
    return MLRecommendation(
      title: json['title'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      description: json['description'] ?? '',
      category: json['category'] ?? '',
    );
  }
}
