import 'package:flutter/material.dart';
import 'http_service.dart';
import 'recipe_form.dart';

class RecipeList extends StatefulWidget {
  @override
  _RecipeListState createState() => _RecipeListState();
}

class _RecipeListState extends State<RecipeList> {
  final HttpService httpService = HttpService();
  List<Map<String, dynamic>> recipes = [];

  @override
  void initState() {
    super.initState();
    fetchRecipes();
  }

  Future<void> fetchRecipes() async {
    try {
      final List<Map<String, dynamic>> data = await httpService.fetchRecipes();
      setState(() {
        recipes = data;
      });
    } catch (e) {
      print('Error fetching recipes: $e');
    }
  }

  Future<void> addRecipe(Map<String, dynamic> recipe) async {
    try {
      await httpService.addRecipe(recipe);
      // After successfully adding the recipe, refresh the recipe list
      fetchRecipes();
    } catch (e) {
      print('Error adding recipe: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recipe List'),
      ),
      body: ListView.builder(
        itemCount: recipes.length,
        itemBuilder: (context, index) {
          final recipe = recipes[index];
          return ListTile(
            title: Text('${recipe['name']}'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Description: ${recipe['description']}'),
                Text('Ingredients: ${recipe['ingredient']}'),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Navigate to RecipeForm and wait for it to complete
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => RecipeForm()),
          );

          // Check if the result is a Map (indicating a new recipe was added)
          if (result is Map<String, dynamic>) {
            // Add the new recipe to the list
            addRecipe(result);
          }
        },
        tooltip: 'Add Recipe',
        child: Icon(Icons.add),
      ),
    );
  }
}
