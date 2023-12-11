import 'package:flutter/material.dart';

import 'UserModel.dart';
import 'connection.dart';
import 'http_service.dart';

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final HttpService httpService = HttpService();

  Future<void> addUser() async {
    String name = _nameController.text;
    String lastName = _lastNameController.text;
    String email = _emailController.text;
    String password = _passwordController.text;


    if (name.isEmpty || lastName.isEmpty || email.isEmpty || password.isEmpty) {
      // Handle the case where any of the required fields is empty
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('All fields must be filled.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
      return;
    }

    try {

        User addedUser = User(
          id: 0,
          name: name,
          lastName: lastName,
          email: email,
          password: password,
        );

        await httpService.addUser(addedUser);

        _nameController.clear();
        _lastNameController.clear();
        _emailController.clear();
        _passwordController.clear();
        Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()),);

    } catch (e) {
      print('Error adding user: $e');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inscription'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Nom'),
            ),
            TextField(
              controller: _lastNameController,
              decoration: InputDecoration(labelText: 'Prénom'),
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Mot de passe'),
              obscureText: true,
            ),

            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: addUser,
              child: Text('S\'inscrire'),
            ),
          ],
        ),
      ),
    );
  }
}

