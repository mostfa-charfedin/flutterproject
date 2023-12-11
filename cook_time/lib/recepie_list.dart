import 'dart:convert';
import 'dart:io';

import 'package:cook_time/recepieModel.dart';
import 'package:cook_time/recipe_form.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'UserModel.dart';
import 'connection.dart';
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
    httpService.checkUserLoginStatus(context);
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

  void refreshModifiedList(Recipe modifiedRecipe) {
    print('Refreshed Modified Recipe ID: ${modifiedRecipe.id}');
    print('Refreshed Modified Recipe Image URL: ${modifiedRecipe.image}');

    int index = recipes.indexWhere((recipe) => recipe.id == modifiedRecipe.id);
    setState(() {
      recipes[index] = modifiedRecipe;
      filterRecipes(searchController.text);
    });
  }

  Future<void> addRecipe(Recipe recipe, XFile? imageFile) async {
    try {
      if (imageFile != null) {
        await httpService.addRecipe(recipe, imageFile as File);
        fetchRecipes(); // Refresh the list after adding a recipe
      } else {
        // Handle the case where imageFile is null, maybe show an error message
        print('Error: imageFile is null');
        // You might want to handle this case according to your application's logic
      }
    } catch (e) {
      print('Error adding recipe: $e');
    }
  }


  Future<void> viewProfile() async {

    String userId = (await httpService.getUserIdFromSharedPreferences()).toString();

    try {
      User userProfile = await _fetchUserProfile(userId);
      bool isEditing = false;
      bool showPassword = false;
      TextEditingController nameController = TextEditingController(text: userProfile.name);
      TextEditingController lastNameController = TextEditingController(text: userProfile.lastName);
      TextEditingController emailController = TextEditingController(text: userProfile.email);
      TextEditingController pwdController = TextEditingController(text: userProfile.password);
      final HttpService httpService = HttpService();

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
                      Text('Password: ********'), // Display masked password
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
            onPressed: () async {

              await httpService.clearSharedPreferences();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
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
            child: FutureBuilder(
              future: httpService.fetchRecipes(),
              builder: (context,AsyncSnapshot<List<Recipe>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {

                  return ListView.builder(
                    itemCount: filteredRecipes.length,
                    itemBuilder: (context, index) {
                      final recipe = filteredRecipes[index];

                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ListTile(
                          onTap: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ModifyRecipe(recipe: recipe)),
                            );

                            if (result is Recipe) {
                              refreshModifiedList(result);
                            }
                          },
                          leading: Image.memory(
                            base64Decode(recipe.image),
                            height: double.maxFinite,
                            width: 100,
                            fit: BoxFit.cover,
                          ),
                          title: Text(
                            recipe.name,
                            style: TextStyle(
                              fontFamily: 'Norican',
                              fontSize: 28,
                              color: Color(0xFF04C7DC),
                            ),
                          ),
                          subtitle: Text(
                            'Description: ${recipe.description}',
                            style: TextStyle(fontSize: 18, color: Colors.black54),
                          ),
                        ),
                      );
                    },
                  );
                }
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
            addRecipe(result, null);
            fetchRecipes();
          }
        },
        tooltip: 'Add Recipe',
        child: Icon(Icons.add),
        backgroundColor: Color(0xFF02F696),
      ),
    );
  }
}
