import 'dart:convert';
import 'dart:io';
import 'package:cook_time/connection.dart';
import 'package:cook_time/inscrit.dart';
import 'package:cook_time/recepieModel.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'UserModel.dart';

class HttpService {
  final String baseUrl;

  HttpService({this.baseUrl = 'http://10.0.2.2:8080'});



  Future<String> imageToBase64(String path) async {
    final bytes = await File(path).readAsBytes();
    return base64Encode(bytes);
  }

  Future<List<Recipe>> fetchRecipes() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/recepie'));

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);

        List<Recipe> recipes = data.map((dynamic recipeData) {
          return Recipe.fromJson(recipeData as Map<String, dynamic>)
            ..name ??= 'Default Name'
            ..description ??= 'Default Description'
            ..ingredient ??= 'Default Ingredient'
            ..image ??= 'Default Image URL';
        }).toList();
        return recipes;
      } else {
        throw Exception('Failed to load recipes');
      }
    } catch (e) {
      throw Exception('Error fetching recipes: $e');
    }
  }



    Future<User> fetchUserById(String userId) async {
    final response = await http.get(Uri.parse('$baseUrl/user/$userId'));

    if (response.statusCode == 200) {
      return User.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load user');
    }
  }

  Future<User> fetchUserByMailAndPassword(String email, password) async {
    final response = await http.get(Uri.parse('$baseUrl/user/connexion/$email/$password'));

    if (response.statusCode == 200) {
      return User.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load user');
    }
  }
  // Function to save user ID to SharedPreferences
  void saveUserIdToSharedPreferences(int userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('userId', userId);
    prefs.setBool('registered', true);
    print('Login successful! User ID saved to SharedPreferences');
  }
  Future<int> getUserIdFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int userId = prefs.getInt('userId') ?? 0; // 0 is a default value if the key is not present
    return userId;
  }


  Future<bool> isUserRegistered() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getBool('registered') == true;
  }


  Future<void> checkUserLoginStatus(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getBool('registered') != true) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    }
  }

  Future<void> clearSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  Future<User> updateUser(User user) async {
    final response = await http.put(
      Uri.parse('$baseUrl/user'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(user.toJson()),
    );
    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update user');
    }
  }
  Future<void> addUser(User user) async {

    await http.post(
      Uri.parse('$baseUrl/user'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': user.name,
        'lastName': user.lastName,
        'email': user.email,
        'password': user.password,
      }),
    );
  }

  Future<void> addRecipe(Recipe recipe, File imageFile) async {

      String base64Image = await imageToBase64(imageFile.path);

      await http.post(
        Uri.parse('$baseUrl/recepie'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': recipe.name,
          'description': recipe.description,
          'ingredient': recipe.ingredient,
          'image': base64Image,
        }),
      );
     fetchRecipes();

  }
  Future<void> UpdateRecipe(Recipe recipe) async {
    final response = await http.put(
      Uri.parse('$baseUrl/recepie/${recipe.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': recipe.name,
        'description': recipe.description,
        'ingredient': recipe.ingredient,
        'imageUrl': recipe.image,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update recipe. Status code: ${response.statusCode}');
    }
  }

  Future<void> DeleteRecipe(Recipe recipe) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/recepie/supprimer/${recipe.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': recipe.name,
        'description': recipe.description,
        'ingredient': recipe.ingredient,
        'imageUrl': recipe.image,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to add recipe. Status code: ${response.statusCode}');
    }
  }


}
