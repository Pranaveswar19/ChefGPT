# ChefGPT - AI Recipe Generator 🍳

An AI-powered mobile app that generates creative recipes from ingredients you have at home. Built with Flutter and OpenAI's GPT API.

## ✨ Features

- 🥘 **Smart Recipe Generation**: Input your available ingredients and get personalized recipes
- 🌍 **Cuisine Preferences**: Choose from Italian, Chinese, Indian, Mexican, Japanese, Thai, American, or any cuisine
- 🥗 **Dietary Options**: Support for Vegetarian, Vegan, Gluten-Free, Keto, and Low-Carb diets
- 📖 **Detailed Instructions**: Step-by-step cooking instructions with prep time and difficulty level
- 💾 **Save Favorites**: Bookmark your favorite recipes for quick access
- 📊 **Nutritional Info**: Get approximate calorie and macro information for each recipe

## 🛠️ Tech Stack

- **Framework**: Flutter
- **State Management**: Provider
- **AI Integration**: OpenAI GPT-3.5 Turbo API
- **HTTP Client**: http package
- **Environment Variables**: flutter_dotenv
- **UI Fonts**: Google Fonts (Poppins)

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (3.0.0 or higher)
- Dart SDK
- Android Studio / Xcode (for emulators)
- OpenAI API Key

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/chefgpt_ai_recipe.git
   cd chefgpt_ai_recipe
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Set up environment variables**
   - Create a `.env` file in the root directory
   - Add your OpenAI API key:
     ```
     OPENAI_API_KEY=your_api_key_here
     ```
   - Get your API key from: https://platform.openai.com/api-keys

4. **Run the app**
   ```bash
   flutter run
   ```

## 📂 Project Structure

```
lib/
├── main.dart                          # App entry point
├── models/
│   └── recipe.dart                    # Recipe data model
├── services/
│   └── openai_services.dart           # OpenAI API integration
├── screens/
│   ├── home_screen.dart               # Home screen with navigation
│   ├── recipe_generator_screen.dart   # Recipe generation interface
│   ├── recipe_detail_screen.dart      # Detailed recipe view
│   └── saved_recipes_screen.dart      # Saved recipes list
└── widgets/
    ├── ingredient_chip.dart           # Ingredient tag widget
    └── recipe_card.dart               # Recipe card component
```

## 🤖 How AI Was Used in Development

This project was built using **AI-assisted development** (Vibe Coding) to accelerate the development process:

1. **Code Generation**: Used AI tools (GitHub Copilot, ChatGPT) to generate boilerplate code and UI components
2. **API Integration**: AI helped structure the OpenAI API calls and JSON parsing logic
3. **Error Debugging**: Quick troubleshooting of import paths and dependency issues
4. **UI/UX Design**: AI suggestions for color schemes, layouts, and user flow
5. **Documentation**: AI-assisted README and code comments generation

### Key Prompts Used:
- "Create a Flutter recipe model with all necessary fields"
- "Generate a service class for OpenAI API integration with error handling"
- "Build a Material 3 UI for ingredient input with chips"
- "Fix import path errors in Flutter project structure"

## 🎯 Usage

1. **Add Ingredients**: Enter ingredients you have (e.g., "chicken, tomatoes, onions")
2. **Set Preferences**: Optionally choose dietary restrictions and cuisine type
3. **Generate Recipe**: Tap "Generate Recipe with AI" and wait for your personalized recipe
4. **View Details**: See ingredients, step-by-step instructions, and nutritional info
5. **Save Favorites**: Bookmark recipes you love for later

## 🔑 API Configuration

The app uses OpenAI's GPT-3.5-turbo model. To use your own API key:

1. Sign up at https://platform.openai.com
2. Generate an API key
3. Add it to your `.env` file (never commit this file!)
4. The app will automatically load it on startup

**Note**: API calls cost money. Monitor your usage at https://platform.openai.com/usage

## 🧪 Testing

Run the app in debug mode to test features:

```bash
flutter run --debug
```

For production build:

```bash
flutter build apk --release  # Android
flutter build ios --release  # iOS
```

## 🐛 Known Issues

- Recipes are not persisted between app restarts (using in-memory storage)
- API responses may vary in quality depending on ingredient combinations
- No image generation for recipes (potential future feature)

## 📄 License

This project is open source and available under the [MIT License](LICENSE).

## 👨‍💻 Author

Built as part of an AI Vibe Coding Sprint to demonstrate rapid mobile app development using AI assistance.

---

**Made with ❤️ using Flutter and AI**
