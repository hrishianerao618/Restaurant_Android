import 'package:flutter/material.dart';
import 'package:food_project/models/food.dart';
import 'package:food_project/notifier/food_notifier.dart';
import 'package:provider/provider.dart';

class FoodForm extends StatefulWidget {
  final bool isUpdating;

  FoodForm({@required this.isUpdating});

  @override
  _FoodFormState createState() => _FoodFormState();
}

class _FoodFormState extends State<FoodForm> {
  Food _currentFood;

  @override
  void initState() {
    super.initState();
    FoodNotifier foodNotifier = Provider.of<FoodNotifier>(context, listen: false);

    if (foodNotifier.currentFood != null) {
      _currentFood = foodNotifier.currentFood;
    } else {
      _currentFood = Food();
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return null;
  }
}