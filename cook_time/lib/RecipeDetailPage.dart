import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:cook_time/recepieModel.dart';

class RecipeDetailPage extends StatelessWidget {
  final Recipe recipe;

  RecipeDetailPage({required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recipe Details'),
        backgroundColor: Color(0xFF02F896),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Display recipe image
            Image.memory(
              base64Decode(recipe.image),
              height: 200,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 16),
            // Display recipe name
            Text(
              'Name: ${recipe.name}',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF04C7DC),
              ),
            ),
            SizedBox(height: 8),
            // Display recipe description
            Text(
              'Description: ${recipe.description}',
              style: TextStyle(fontSize: 18, color: Colors.black54),
            ),
            SizedBox(height: 16),
            // Display recipe ingredients
            Text(
              'Ingredients:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (final ingredient in recipe.ingredient.split('/'))
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text('- $ingredient', style: TextStyle(fontSize: 16)),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
