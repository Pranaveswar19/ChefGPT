class Recipe {
  final String name;
  final String description;
  final List<String> ingredients;
  final List<String> instructions;
  final String prepTime;
  final String cookTime;
  final String servings;
  final String difficulty;
  final String nutritionalInfo;

  Recipe({
    required this.name,
    required this.description,
    required this.ingredients,
    required this.instructions,
    required this.prepTime,
    required this.cookTime,
    required this.servings,
    required this.difficulty,
    required this.nutritionalInfo,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      name: json['name'] ?? 'Untitled Recipe',
      description: json['description'] ?? '',
      ingredients: List<String>.from(json['ingredients'] ?? []),
      instructions: List<String>.from(json['instructions'] ?? []),
      prepTime: json['prep_time'] ?? 'N/A',
      cookTime: json['cook_time'] ?? 'N/A',
      servings: json['servings'] ?? 'N/A',
      difficulty: json['difficulty'] ?? 'Medium',
      nutritionalInfo: json['nutritional_info'] ?? 'Not available',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'ingredients': ingredients,
      'instructions': instructions,
      'prep_time': prepTime,
      'cook_time': cookTime,
      'servings': servings,
      'difficulty': difficulty,
      'nutritional_info': nutritionalInfo,
    };
  }
}
