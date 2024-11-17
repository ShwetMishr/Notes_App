import 'package:database_in_flutter/Screen.dart';
import 'package:flutter/material.dart';

void main(){
  runApp(ThemeApp());
}
class ThemeApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Databse in flutter ",
      debugShowCheckedModeBanner: false,
      home: DatabaseScreen(),
    );
  }

}