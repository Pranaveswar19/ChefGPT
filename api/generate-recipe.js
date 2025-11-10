export default async function handler(req, res) {
  if (req.method !== 'POST') {
    return res.status(405).json({ error: 'Method not allowed' });
  }

  const { ingredients, dietaryPreference, cuisineType } = req.body;

  if (!ingredients || ingredients.length === 0) {
    return res.status(400).json({ error: 'Ingredients are required' });
  }

  const apiKey = process.env.OPENAI_API_KEY;
  if (!apiKey) {
    return res.status(500).json({ error: 'API key not configured' });
  }

  const ingredientsList = ingredients.join(', ');
  const dietary = dietaryPreference ? ` It should be ${dietaryPreference}.` : '';
  const cuisine = cuisineType ? ` Make it ${cuisineType} cuisine.` : '';

  const prompt = `Create a recipe using these ingredients: ${ingredientsList}.${dietary}${cuisine}

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
}`;

  try {
    const response = await fetch('https://api.openai.com/v1/chat/completions', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${apiKey}`,
      },
      body: JSON.stringify({
        model: 'gpt-3.5-turbo',
        messages: [
          {
            role: 'system',
            content: 'You are a professional chef assistant that creates recipes in JSON format.'
          },
          { role: 'user', content: prompt }
        ],
        temperature: 0.7,
        max_tokens: 1000,
      }),
    });

    if (!response.ok) {
      const error = await response.text();
      return res.status(response.status).json({ error: `OpenAI API error: ${error}` });
    }

    const data = await response.json();
    const content = data.choices[0].message.content;
    
    const jsonStart = content.indexOf('{');
    const jsonEnd = content.lastIndexOf('}') + 1;
    const jsonString = content.substring(jsonStart, jsonEnd);
    const recipe = JSON.parse(jsonString);

    return res.status(200).json(recipe);
  } catch (error) {
    console.error('Error:', error);
    return res.status(500).json({ error: 'Failed to generate recipe', details: error.message });
  }
}
