import 'dart:convert';
import 'dart:io';

import 'package:cook_time/recepieModel.dart';
import 'package:flutter/material.dart';
import 'http_service.dart';
import 'package:image_picker/image_picker.dart';

class RecipeForm extends StatefulWidget {
  @override
  _RecipeFormState createState() => _RecipeFormState();
}

class _RecipeFormState extends State<RecipeForm> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController ingredientController = TextEditingController();
  late TextEditingController imageUrlController = TextEditingController();
  XFile? imageFile;
  final picker = ImagePicker();
  final HttpService httpService = HttpService();

  Future<String> imageToBase64(String path) async {
    final bytes = await File(path).readAsBytes();
    return base64Encode(bytes);
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
      if (imageFile != null) {
        Recipe addedRecipe = Recipe(
          id: 0,
          name: name,
          description: description,
          ingredient: ingredient,
          image: await imageToBase64(imageFile!.path),
          Userid:(await httpService.getUserIdFromSharedPreferences()).toString(),

        );
        print(addedRecipe.Userid);

        // Convert XFile to File
        File file = File(imageFile!.path);

        await httpService.addRecipe(addedRecipe, file);

        nameController.clear();
        descriptionController.clear();
        ingredientController.clear();
        imageUrlController.clear();
        imageFile = null;

        Navigator.pop(context, addedRecipe);
      } else {
        print('Error: imageFile is null');
      }
    } catch (e) {
      print('Error adding recipe: $e');
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
            _buildInputField('Ingredients (use / to go to the next lign)', ingredientController),
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
