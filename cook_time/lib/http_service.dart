import 'dart:convert';
import 'package:cook_time/recepieModel.dart';
import 'package:http/http.dart' as http;

import 'UserModel.dart';

class HttpService {
  final String baseUrl;

  HttpService({this.baseUrl = 'http://10.0.2.2:8080'});

  Future<List<Recipe>> fetchRecipes() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/recepie'));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        List<Recipe> recipes = data.map((recipeData) => Recipe.fromJson(recipeData)).toList();
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

  Future<void> addRecipe(Recipe recipe) async {
    final response = await http.post(
      Uri.parse('$baseUrl/recepie'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': recipe.name,
        'description': recipe.description,
        'ingredient': recipe.ingredient,
        'imageUrl': recipe.imageUrl,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to add recipe. Status code: ${response.statusCode}');
    }
  }
  Future<void> UpdateRecipe(Recipe recipe) async {
    final response = await http.put(
      Uri.parse('$baseUrl/recepie/${recipe.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': recipe.name,
        'description': recipe.description,
        'ingredient': recipe.ingredient,
        'imageUrl': recipe.imageUrl,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update recipe. Status code: ${response.statusCode}');
    }
  }

  Future<void> DeleteRecipe(Recipe recipe) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/recepie//supprimer/${recipe.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': recipe.name,
        'description': recipe.description,
        'ingredient': recipe.ingredient,
        'imageUrl': recipe.imageUrl,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to add recipe. Status code: ${response.statusCode}');
    }
  }
}
