import 'dart:convert';
import 'package:http/http.dart' as http;

class HttpService {
  final String baseUrl;

  HttpService({this.baseUrl = 'http://192.168.1.19:8080'});

  Future<List<Map<String, dynamic>>> fetchRecipes() async {
    final response = await http.get(Uri.parse('$baseUrl/recepie'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to load recipes');
    }
  }

  Future<void> addRecipe(Map<String, dynamic> recipe) async {
    final response = await http.post(
      Uri.parse('$baseUrl/recepie'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(recipe),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to add recipe. Status code: ${response.statusCode}');
    }
  }
}
