import 'package:cook_time/recepieModel.dart';
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
  late TextEditingController imageUrlController = TextEditingController();
  final HttpService httpService = HttpService();

  Future<void> submitForm() async {
    String name = nameController.text;
    String description = descriptionController.text;
    String ingredient = ingredientController.text;
    String imageUrl = imageUrlController.text;

    if (name.isEmpty || description.isEmpty || ingredient.isEmpty) {
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

    try {
      Recipe addedRecipe = Recipe(
        id: 0,
        name: name,
        description: description,
        ingredient: ingredient,
        imageUrl: imageUrl,
      );

      nameController.clear();
      descriptionController.clear();
      ingredientController.clear();
      imageUrlController.clear();

      Navigator.pop(context, addedRecipe);
    } catch (e) {
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
        backgroundColor: Color(0xFF02F896),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildInputField('Recipe Name', nameController),
            _buildInputField('Description', descriptionController),
            _buildInputField('Ingredients', ingredientController),
            _buildImageUrlInput(),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                submitForm();
              },
              style: ElevatedButton.styleFrom(
                primary: Color(0xFF02F896),
                shadowColor: Colors.black.withOpacity(0.3),
                elevation: 5,
              ),
              child: Text('Add Recipe'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(String labelText, TextEditingController controller) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        ),
      ),
    );
  }

  Widget _buildImageUrlInput() {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('Image URL'),
          SizedBox(height: 8),
          TextField(
            controller: imageUrlController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
            ),
          ),
        ],
      ),
    );
  }
}
