
import 'package:flutter/material.dart';
import 'http_service.dart';

class RecipeForm extends StatefulWidget {
  @override
  _RecipeFormState createState() => _RecipeFormState();
}

class _RecipeFormState extends State<RecipeForm> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController ingredientController = TextEditingController();
  final HttpService httpService = HttpService(); // Change the name here

  Future<void> submitForm() async {
    // Extract values from controllers
    String name = nameController.text;
    String description = descriptionController.text;
    String ingredient = ingredientController.text;

    // Check if any of the fields are empty
    if (name.isEmpty || description.isEmpty || ingredient.isEmpty) {
      // Show an alert or message indicating that all fields must be filled
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('All fields must be filled.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
      return;
    }

    // Send a request to your backend to add the new recipe
    try {
      Map<String, dynamic> addedRecipe = {
        'name': name,
        'description': description,
        'ingredient': ingredient,
        // Add other properties if needed
      };

      // Clear the text controllers
      nameController.clear();
      descriptionController.clear();
      ingredientController.clear();

      Navigator.pop(context, addedRecipe);
    } catch (e) {
      // Handle network or other errors
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Error adding recipe: $e'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Recipe'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Recipe Name'),
            ),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            TextField(
              controller: ingredientController,
              decoration: InputDecoration(labelText: 'Ingredients'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Call the submitForm method when the button is pressed
                submitForm();
              },
              child: Text('Add Recipe'),
            ),
          ],
        ),
      ),
    );
  }
}
