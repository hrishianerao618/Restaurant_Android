import 'package:flutter/material.dart';
import 'package:food_project/models/user.dart';
import 'package:food_project/screens/authenticate/authenticate.dart';
import 'package:food_project/screens/home/home.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    
    final user = Provider.of<User>(context);

    // return either home or authenticate widget
    if(user == null) {
      return Authenticate();
    } else {
      return Home();
    }
  }
}