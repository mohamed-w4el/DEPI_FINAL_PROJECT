class Meal {
  final int mealId;
  final String name;
  final String imageUrl;
  final String description;

  Meal({
    required this.mealId,
    required this.name,
    required this.imageUrl,
    required this.description,
  });

  factory Meal.fromMap(Map<String, dynamic> map) {
    return Meal(
      mealId: map['meal_id'] ?? 0,
      name: map['name_en'] ?? '',
      imageUrl: map['image_url'] ?? '',
      description: map['description_en'] ?? '',
    );
  }
}
