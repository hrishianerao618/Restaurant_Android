import 'package:flutter/material.dart';
import 'package:food_project/menu/menu.dart';
import 'package:food_project/notifier/auth_notifier.dart';
import 'package:food_project/notifier/food_notifier.dart';
import 'package:food_project/screens/authenticate/login.dart';
import 'package:provider/provider.dart';

//import 'notifier/auth_notifier.dart';


void main() => runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AuthNotifier(),
        ),
        ChangeNotifierProvider(
          create: (context) => FoodNotifier(),
        ),
      ],
      child: MyApp(),
    ));

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'HHM',
      /*theme: ThemeData(
        primarySwatch: Colors.blue,
        accentColor: Colors.lightBlue,
      ),*/
      home: Consumer<AuthNotifier>(
        builder: (context, notifier, child) {
          return notifier.user != null ? Menu() : Login();
        },
      ),
    );
  }
}

