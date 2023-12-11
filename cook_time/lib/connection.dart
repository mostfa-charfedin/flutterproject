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

  Future<void> submit() async {
    String email = _emailController.text;
    String password = _passwordController.text;
    User user = await httpService.fetchUserByMailAndPassword(email, password);
    if (user != null) {
      httpService.saveUserIdToSharedPreferences(user.id);
      httpService.isUserRegistered();
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => RecipeList()),
      );
    } else {
      print('Invalid credentials. Please try again.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Page'),
        backgroundColor: Color(0xFF02F896),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF02F896)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF02F896)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: submit,
              child: Text('Login'),
              style: ElevatedButton.styleFrom(
                primary: Color(0xFF02F896),
              ),
            ),
            SizedBox(height: 8.0),
            GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => RegistrationPage()));
              },
              child: Text(

                'S\'inscrire',
                style: TextStyle(
                  color: Color(0xFF02F896),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
