import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/recipe.dart';

class OpenAIService extends ChangeNotifier {
  final String _baseUrl = 'https://api.openai.com/v1/chat/completions';
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

    final apiKey = dotenv.env['OPENAI_API_KEY'];
    if (apiKey == null || apiKey.isEmpty) {
      _error = 'API key not found. Please add it to .env file';
      _isLoading = false;
      notifyListeners();
      return null;
    }

    final prompt = _buildPrompt(ingredients, dietaryPreference, cuisineType);

    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode({
          'model': 'gpt-3.5-turbo',
          'messages': [
            {
              'role': 'system',
              'content':
                  'You are a professional chef assistant that creates recipes in JSON format.'
            },
            {'role': 'user', 'content': prompt}
          ],
          'temperature': 0.8,
          'max_tokens': 1500,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final content = data['choices'][0]['message']['content'];
        final recipeJson = _extractJson(content);
        final recipe = Recipe.fromJson(recipeJson);

        _isLoading = false;
        notifyListeners();
        return recipe;
      } else {
        _error = 'Error: ${response.statusCode} - ${response.body}';
        _isLoading = false;
        notifyListeners();
        return null;
      }
    } catch (e) {
      _error = 'Failed to generate recipe: $e';
      _isLoading = false;
      notifyListeners();
      return null;
    }
  }

  String _buildPrompt(List<String> ingredients, String? dietaryPreference,
      String? cuisineType) {
    final ingredientsList = ingredients.join(', ');
    final dietary = dietaryPreference != null && dietaryPreference.isNotEmpty
        ? ' It should be $dietaryPreference.'
        : '';
    final cuisine = cuisineType != null && cuisineType.isNotEmpty
        ? ' Make it $cuisineType cuisine.'
        : '';

    return '''Create a recipe using these ingredients: $ingredientsList.$dietary$cuisine

Return ONLY a valid JSON object with this exact structure:
{
"name": "Recipe Name",
"description": "Brief description",
"ingredients": ["ingredient 1 with quantity", "ingredient 2 with quantity"],
"instructions": ["step 1", "step 2", "step 3"],
"prep_time": "X minutes",
"cook_time": "X minutes",
"servings": "X servings",
"difficulty": "Easy/Medium/Hard",
"nutritional_info": "Approximate calories and macros"
}''';
  }

  Map<String, dynamic> _extractJson(String content) {
    try {
      final jsonStart = content.indexOf('{');
      final jsonEnd = content.lastIndexOf('}') + 1;
      if (jsonStart != -1 && jsonEnd > jsonStart) {
        final jsonString = content.substring(jsonStart, jsonEnd);
        return jsonDecode(jsonString);
      }
      return jsonDecode(content);
    } catch (e) {
      throw Exception('Failed to parse recipe JSON: $e');
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
