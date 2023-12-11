import 'package:cook_time/connection.dart';
import 'package:cook_time/inscrit.dart';
import 'package:cook_time/recepie_list.dart';
import 'package:flutter/material.dart';


void main() {
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recipe App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: RecipeList(),
    );
  }
}
