import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/recipe.dart';
import '../services/openai_services.dart';

class RecipeDetailScreen extends StatelessWidget {
  final Recipe recipe;

  const RecipeDetailScreen({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(recipe.name),
        actions: [
          Consumer<OpenAIService>(
            builder: (context, service, _) {
              final isSaved = service.isRecipeSaved(recipe);
              return IconButton(
                onPressed: () {
                  if (isSaved) {
                    service.removeRecipe(recipe);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Recipe removed from saved')),
                    );
                  } else {
                    service.saveRecipe(recipe);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Recipe saved!')),
                    );
                  }
                },
                icon: Icon(isSaved ? Icons.bookmark : Icons.bookmark_border),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      recipe.name,
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(recipe.description,
                        style: const TextStyle(fontSize: 16)),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildInfoChip(Icons.timer, 'Prep', recipe.prepTime),
                        _buildInfoChip(
                            Icons.restaurant, 'Cook', recipe.cookTime),
                        _buildInfoChip(Icons.people, 'Serves', recipe.servings),
                        _buildInfoChip(Icons.star, recipe.difficulty, ''),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildSection(
              'Ingredients',
              Icons.list_alt,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: recipe.ingredients.map((ingredient) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.check_circle,
                            size: 20, color: Colors.green),
                        const SizedBox(width: 8),
                        Expanded(
                            child: Text(ingredient,
                                style: const TextStyle(fontSize: 16))),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 16),
            _buildSection(
              'Instructions',
              Icons.format_list_numbered,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: recipe.instructions.asMap().entries.map((entry) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 14,
                          child: Text('${entry.key + 1}'),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(entry.value,
                              style: const TextStyle(fontSize: 16)),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 16),
            _buildSection(
              'Nutritional Information',
              Icons.health_and_safety,
              Text(recipe.nutritionalInfo,
                  style: const TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, size: 24),
        const SizedBox(height: 4),
        Text(label,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
        Text(value, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _buildSection(String title, IconData icon, Widget content) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 24),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 12),
            content,
          ],
        ),
      ),
    );
  }
}
