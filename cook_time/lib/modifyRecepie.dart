import 'package:cook_time/recepieModel.dart';
import 'package:flutter/material.dart';

import 'http_service.dart';

class ModifyRecipe extends StatefulWidget {
  final Recipe recipe;

  ModifyRecipe({required this.recipe});

  @override
  _ModifyRecipeState createState() => _ModifyRecipeState();
}

class _ModifyRecipeState extends State<ModifyRecipe> {
  final HttpService httpService = HttpService();
  late TextEditingController nameController;
  late TextEditingController descriptionController;
  late TextEditingController ingredientController;
  late TextEditingController imageUrlController;

  @override
  void initState() {
    super.initState();

    nameController = TextEditingController(text: widget.recipe.name);
    descriptionController = TextEditingController(text: widget.recipe.description);
    ingredientController = TextEditingController(text: widget.recipe.ingredient);
    imageUrlController = TextEditingController(text: widget.recipe.imageUrl);
  }

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


    Recipe modifiedRecipe = Recipe(
      id: widget.recipe.id,
      name: name,
      description: description,
      ingredient: ingredient,
      imageUrl: imageUrl,
    );

    Navigator.pop(context, modifiedRecipe);

    try {
      await httpService.UpdateRecipe(modifiedRecipe);
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Error updating recipe: $e'),
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
        title: Text('Modify Recipe'),
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
              child: Text('Modify Recipe'),
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
          SizedBox(height: 8),

          imageUrlController.text.isNotEmpty
              ? Image.network(
            imageUrlController.text,
            key: UniqueKey(),
            height: 200,
            width: 200,
            fit: BoxFit.cover,
          )
              : Container(),
        ],
      ),
    );
  }
}
