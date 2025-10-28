import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/openai_services.dart';
import '../widgets/ingredient_chip.dart';
import 'recipe_detail_screen.dart';

class RecipeGeneratorScreen extends StatefulWidget {
  const RecipeGeneratorScreen({super.key});

  @override
  State<RecipeGeneratorScreen> createState() => _RecipeGeneratorScreenState();
}

class _RecipeGeneratorScreenState extends State<RecipeGeneratorScreen> {
  final TextEditingController _ingredientController = TextEditingController();
  final List<String> _ingredients = [];
  String? _selectedDiet;
  String? _selectedCuisine;

  final List<String> _dietOptions = [
    'None',
    'Vegetarian',
    'Vegan',
    'Gluten-Free',
    'Keto',
    'Low-Carb'
  ];
  final List<String> _cuisineOptions = [
    'Any',
    'Italian',
    'Chinese',
    'Indian',
    'Mexican',
    'Japanese',
    'Thai',
    'American'
  ];

  @override
  void dispose() {
    _ingredientController.dispose();
    super.dispose();
  }

  void _addIngredient() {
    final ingredient = _ingredientController.text.trim();
    if (ingredient.isNotEmpty && !_ingredients.contains(ingredient)) {
      setState(() {
        _ingredients.add(ingredient);
        _ingredientController.clear();
      });
    }
  }

  void _removeIngredient(String ingredient) {
    setState(() {
      _ingredients.remove(ingredient);
    });
  }

  Future<void> _generateRecipe() async {
    if (_ingredients.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add at least one ingredient')),
      );
      return;
    }

    final service = Provider.of<OpenAIService>(context, listen: false);
    final dietary =
        _selectedDiet != null && _selectedDiet != 'None' ? _selectedDiet : null;
    final cuisine = _selectedCuisine != null && _selectedCuisine != 'Any'
        ? _selectedCuisine
        : null;

    final recipe = await service.generateRecipe(_ingredients,
        dietaryPreference: dietary, cuisineType: cuisine);

    if (recipe != null && mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => RecipeDetailScreen(recipe: recipe)),
      );
    } else if (service.error != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(service.error!)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Generate Recipe'),
        elevation: 0,
      ),
      body: Consumer<OpenAIService>(
        builder: (context, service, _) {
          if (service.isLoading) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 20),
                  Text('Cooking up something delicious...',
                      style: TextStyle(fontSize: 16)),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Add Ingredients',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _ingredientController,
                                decoration: const InputDecoration(
                                  hintText: 'e.g., chicken, tomatoes',
                                  border: OutlineInputBorder(),
                                ),
                                onSubmitted: (_) => _addIngredient(),
                              ),
                            ),
                            const SizedBox(width: 8),
                            IconButton.filled(
                              onPressed: _addIngredient,
                              icon: const Icon(Icons.add),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        if (_ingredients.isNotEmpty)
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: _ingredients.map((ingredient) {
                              return IngredientChip(
                                label: ingredient,
                                onDeleted: () => _removeIngredient(ingredient),
                              );
                            }).toList(),
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Preferences (Optional)',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 12),
                        DropdownButtonFormField<String>(
                          decoration: const InputDecoration(
                            labelText: 'Dietary Preference',
                            border: OutlineInputBorder(),
                          ),
                          value: _selectedDiet,
                          items: _dietOptions.map((diet) {
                            return DropdownMenuItem(
                                value: diet, child: Text(diet));
                          }).toList(),
                          onChanged: (value) =>
                              setState(() => _selectedDiet = value),
                        ),
                        const SizedBox(height: 12),
                        DropdownButtonFormField<String>(
                          decoration: const InputDecoration(
                            labelText: 'Cuisine Type',
                            border: OutlineInputBorder(),
                          ),
                          value: _selectedCuisine,
                          items: _cuisineOptions.map((cuisine) {
                            return DropdownMenuItem(
                                value: cuisine, child: Text(cuisine));
                          }).toList(),
                          onChanged: (value) =>
                              setState(() => _selectedCuisine = value),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                FilledButton.icon(
                  onPressed: _generateRecipe,
                  icon: const Icon(Icons.auto_awesome),
                  label: const Text('Generate Recipe with AI'),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.all(16),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
