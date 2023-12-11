
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'http_service.dart';
import 'recepieModel.dart';

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

  late XFile? imageFile;
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();

    nameController = TextEditingController(text: widget.recipe.name);
    descriptionController = TextEditingController(text: widget.recipe.description);
    ingredientController = TextEditingController(text: widget.recipe.ingredient);
    imageFile = null;
  }

  Future<void> submitForm() async {
    String name = nameController.text;
    String description = descriptionController.text;
    String ingredient = ingredientController.text;

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
      String imageUrl = widget.recipe.image;

      if (imageFile != null) {
        imageUrl = await httpService.imageToBase64(imageFile!.path);
      }

      Recipe modifiedRecipe = Recipe(
        id: widget.recipe.id,
        name: name,
        description: description,
        ingredient: ingredient,
        image: imageUrl,
      );

      Navigator.pop(context, modifiedRecipe);

      await httpService.UpdateRecipe(modifiedRecipe, imageFile: imageFile);


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

  Future<void> pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        imageFile = pickedFile;
      });
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
          Text('Select Image'),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              pickImage();
            },
            child: Text('Pick Image'),
          ),
          SizedBox(height: 16),
          if (imageFile != null)
            Image.file(
              File(imageFile!.path),
              height: 100,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
        ],
      ),
    );
  }
}
