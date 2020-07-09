import 'package:flutter/material.dart';
import 'package:food_project/menu/menu.dart';
import 'package:food_project/models/order.dart';
import 'package:food_project/screens/home/order_list.dart';
import 'package:food_project/services/auth.dart';
import 'package:food_project/services/database.dart';
import 'package:food_project/shared/loading.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AuthService _auth = AuthService();
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : StreamProvider<QuerySnapshot>.value(
        value: DatabaseService().orders,
        child: Scaffold(
        backgroundColor: Colors.brown[50],
        appBar: AppBar(
          title: Text('HHM'),
          backgroundColor: Colors.brown[400],
          elevation: 0.0,
          actions: <Widget>[
            FlatButton.icon(
              icon: Icon(Icons.person),
              label: Text('Logout'),
              onPressed: () async {
                await _auth.signOut();
              },
            ),
          ],
        ),
        //body: OrderList(),
        body: Center (
          child: RaisedButton.icon(
            icon: Icon(
              Icons.fastfood,
              size: 70.0,
            ),
            label: Text('Place an order'),
            color: Colors.pink[400],
            onPressed: () {
              //Use`Navigator` widget to push the second screen to out stack of screens
              //setState(() => loading = true);
              Navigator.of(context).push(MaterialPageRoute<Null>(builder: (BuildContext context) {
                loading = false;
                return new Menu();
              }));
            },
          ),
        ),
      ),
    );
  }
}
