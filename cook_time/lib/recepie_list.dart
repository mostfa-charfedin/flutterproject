import 'package:cook_time/recepieModel.dart';
import 'package:cook_time/recipe_form.dart';
import 'package:flutter/material.dart';

import 'UserModel.dart';
import 'http_service.dart';
import 'modifyRecepie.dart';

class RecipeList extends StatefulWidget {
  @override
  _RecipeListState createState() => _RecipeListState();
}

class _RecipeListState extends State<RecipeList> {
  final HttpService httpService = HttpService();
  List<Recipe> recipes = [];
  List<Recipe> filteredRecipes = [];

  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchRecipes();
  }

  Future<void> fetchRecipes() async {
    try {
      final List<Recipe> data = await httpService.fetchRecipes();
      setState(() {
        recipes = data;
        filteredRecipes = List.from(recipes);
      });
    } catch (e) {
      print('Error fetching recipes: $e');
    }
  }

  Future<void> addRecipe(Recipe recipe) async {
    try {
      await httpService.addRecipe(recipe);
      fetchRecipes();
    } catch (e) {
      print('Error adding recipe: $e');
    }
  }

  Future<void> viewProfile() async {
    String userId = '1';

    try {
      User userProfile = await _fetchUserProfile(userId);

      bool isEditing = false;
      bool showPassword = false;
      TextEditingController nameController = TextEditingController(text: userProfile.name);
      TextEditingController lastNameController = TextEditingController(text: userProfile.lastName);
      TextEditingController emailController = TextEditingController(text: userProfile.email);
      TextEditingController pwdController = TextEditingController(text: userProfile.password);

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: Text(isEditing ? 'Edit Profile' : 'User Profile'),
                icon: Icon(Icons.man),
                content: Container(
                  width: double.maxFinite,
                  child: isEditing
                      ? Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: nameController,
                        decoration: InputDecoration(labelText: 'Name'),
                      ),
                      TextField(
                        controller: lastNameController,
                        decoration: InputDecoration(labelText: 'Last Name'),
                      ),
                      TextField(
                        controller: emailController,
                        decoration: InputDecoration(labelText: 'Email'),
                      ),
                      TextField(
                        controller: pwdController,
                        obscureText: !showPassword,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          suffixIcon: IconButton(
                            icon: Icon(showPassword ? Icons.visibility : Icons.visibility_off),
                            onPressed: () {
                              setState(() {
                                showPassword = !showPassword;
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  )
                      : Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Name: ${userProfile.name} ${userProfile.lastName}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text('Email: ${userProfile.email}'),
                      Text('Password: ****'), // Display masked password
                    ],
                  ),
                ),
                actions: [
                  if (!isEditing)
                    TextButton(
                      onPressed: () {
                        setState(() {
                          isEditing = true;
                        });
                      },
                      child: Text('Modify'),
                    ),
                  TextButton(
                    onPressed: () async {
                      if (isEditing) {
                        User updatedUser = User(
                          id: userProfile.id,
                          name: nameController.text,
                          lastName: lastNameController.text,
                          email: emailController.text,
                          password: pwdController.text,
                          role: 'User',
                        );

                        await httpService.updateUser(updatedUser);

                        userProfile = await _fetchUserProfile(userId);

                        setState(() {
                          isEditing = false;
                          nameController.clear();
                          lastNameController.clear();
                          emailController.clear();
                        });
                      } else {
                        Navigator.of(context).pop();
                      }
                    },
                    child: Text(isEditing ? 'Save' : 'Close'),
                  ),
                ],
              );
            },
          );
        },
      );
    } catch (e) {
      print('Error fetching user profile: $e');
    }
  }

  Future<User> _fetchUserProfile(String userId) async {
    try {
      User userProfile = await httpService.fetchUserById(userId);
      return userProfile;
    } catch (e) {
      print('Error fetching user profile: $e');
      rethrow;
    }
  }


  void filterRecipes(String query) {
    setState(() {
      filteredRecipes = recipes
          .where((recipe) => recipe.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recipe List'),
        backgroundColor: Color(0xFF02F896),
        actions: [
          IconButton(
            icon: Icon(Icons.face),
            onPressed: () {
              viewProfile();
            },
          ),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: TextField(
              controller: searchController,
              onChanged: (query) {
                filterRecipes(query);
              },
              decoration: InputDecoration(
                labelText: 'Search by name',
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredRecipes.length,
              itemBuilder: (context, index) {
                final recipe = filteredRecipes[index];
                return GestureDetector(
                  onTap: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ModifyRecipe(recipe: recipe)),
                    );

                    if (result is Recipe) {
                      refreshModifiedList(result);
                    }
                  },
                  child: Card(
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.network(
                            recipe.imageUrl,
                            height: 100,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                          SizedBox(height: 8),
                          Text(
                            recipe.name,
                            style: TextStyle(
                              fontFamily: 'Norican',
                              fontSize: 28,
                              color: Color(0xFF04C7DC),
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Description: ${recipe.description}',
                            style: TextStyle(fontSize: 18, color: Colors.black54),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => RecipeForm()),
          );

          if (result is Recipe) {
            addRecipe(result);
          }
        },
        tooltip: 'Add Recipe',
        child: Icon(Icons.add),
        backgroundColor: Color(0xFF02F896),
      ),
    );
  }

  void refreshModifiedList(Recipe modifiedRecipe) {
    print('Refreshed Modified Recipe ID: ${modifiedRecipe.id}');
    print('Refreshed Modified Recipe Image URL: ${modifiedRecipe.imageUrl}');

    int index = recipes.indexWhere((recipe) => recipe.id == modifiedRecipe.id);
    setState(() {
      recipes[index] = modifiedRecipe;
      filterRecipes(searchController.text);
    });
  }
}
