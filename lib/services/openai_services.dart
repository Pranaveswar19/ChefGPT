import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/recipe.dart';

class OpenAIService extends ChangeNotifier {
  bool _isLoading = false;
  String? _error;
  List<Recipe> _savedRecipes = [];

  bool get isLoading => _isLoading;
  String? get error => _error;
  List<Recipe> get savedRecipes => _savedRecipes;

  Future<Recipe?> generateRecipe(List<String> ingredients,
      {String? dietaryPreference, String? cuisineType}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final apiUrl = kIsWeb 
        ? '/api/generate-recipe'
        : 'https://chef-gpt-pranaveswar19s-projects.vercel.app/api/generate-recipe';

    try {
      if (kDebugMode) {
        print('Sending request to: $apiUrl');
      }
      
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'ingredients': ingredients,
          'dietaryPreference': dietaryPreference,
          'cuisineType': cuisineType,
        }),
      ).timeout(const Duration(seconds: 30));

      if (kDebugMode) {
        print('Response status: ${response.statusCode}');
      }

      if (response.statusCode == 200) {
        final recipeJson = jsonDecode(response.body);
        final recipe = Recipe.fromJson(recipeJson);

        _isLoading = false;
        notifyListeners();
        return recipe;
      } else {
        final errorData = jsonDecode(response.body);
        _error = 'Error: ${errorData['error'] ?? 'Unknown error'}';
        _isLoading = false;
        notifyListeners();
        return null;
      }
    } catch (e) {
      _error = 'Failed to generate recipe: $e';
      if (kDebugMode) {
        print('Error generating recipe: $e');
      }
      _isLoading = false;
      notifyListeners();
      return null;
    }
  }

  void saveRecipe(Recipe recipe) {
    if (!_savedRecipes.any((r) => r.name == recipe.name)) {
      _savedRecipes.add(recipe);
      notifyListeners();
    }
  }

  void removeRecipe(Recipe recipe) {
    _savedRecipes.removeWhere((r) => r.name == recipe.name);
    notifyListeners();
  }

  bool isRecipeSaved(Recipe recipe) {
    return _savedRecipes.any((r) => r.name == recipe.name);
  }
}
