import 'dart:convert';
import 'dart:io';

import 'package:cook_time/UserModel.dart';

class Recipe {
  int id;
  String name;
  String description;
  String ingredient;
  String image;
  String Userid;

  Recipe({
    required this.id,
    required this.name,
    required this.description,
    required this.ingredient,
    required this.image,
    required this.Userid,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'ingredient': ingredient,
      'image': image,
      'Userid': Userid,
    };
  }

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['id'] ?? 0,
      name: json['name'] ?? 'Default Name',
      description: json['description'] ?? 'Default Description',
      ingredient: json['ingredient'] ?? 'Default Ingredient',
      image: json['image'] ?? 'Default Image URL',
      Userid: json['Userid'] ?? 'Default ',
    );
  }

  // Convert the image to base64
  Future<String> imageToBase64() async {

    if (image.startsWith('data:image')) {
      return image;
    }
    final bytes = await File(image).readAsBytes();
    return base64Encode(bytes);
  }
}
