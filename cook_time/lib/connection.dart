

import 'package:cook_time/inscrit.dart';
import 'package:cook_time/recepie_list.dart';
import 'package:flutter/material.dart';


import 'UserModel.dart';
import 'http_service.dart';




class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final HttpService httpService = HttpService();

  // Dummy user data for demonstration purposes


  Future<void> submit() async {
    // Validate email and password (add your own validation logic)
    String email = _emailController.text;
    String password = _passwordController.text;
    User user = await httpService.fetchUserByMailAndPassword(email,password);
    if (user!= null) {
    httpService.saveUserIdToSharedPreferences(user.id);
    httpService.isUserRegistered();
      Navigator.push(context, MaterialPageRoute(builder: (context) => RecipeList()),);
    } else {
      // Show an error message or perform other actions for unsuccessful login
      print('Invalid credentials. Please try again.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(

          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Password'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: submit,
              child: Text('Login'),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => RegistrationPage()));
              },
              child: Text('S\'inscrire'),
            ),
          ],
        ),
      ),
    );
  }
}
