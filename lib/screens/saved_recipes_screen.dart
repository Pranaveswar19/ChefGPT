import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/openai_services.dart';
import '../widgets/recipe_card.dart';
import 'recipe_detail_screen.dart';

class SavedRecipesScreen extends StatelessWidget {
  const SavedRecipesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Recipes'),
      ),
      body: Consumer<OpenAIService>(
        builder: (context, service, _) {
          if (service.savedRecipes.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.bookmark_border,
                      size: 80, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'No saved recipes yet',
                    style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Generate recipes and save your favorites!',
                    style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: service.savedRecipes.length,
            itemBuilder: (context, index) {
              final recipe = service.savedRecipes[index];
              return RecipeCard(
                recipe: recipe,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => RecipeDetailScreen(recipe: recipe)),
                ),
                onDelete: () => service.removeRecipe(recipe),
              );
            },
          );
        },
      ),
    );
  }
}
