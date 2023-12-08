class Recipe {
  int id;
  String name;
  String description;
  String ingredient;
  String imageUrl;


  Recipe({
    required this.id,
    required this.name,
    required this.description,
    required this.ingredient,
     required this.imageUrl,

  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      ingredient: json['ingredient'],
      imageUrl: json['imageUrl'],

    );
  }
}
