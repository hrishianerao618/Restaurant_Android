import 'package:flutter/material.dart';
import 'package:food_project/models/order.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderList extends StatefulWidget {
  @override
  _OrderListState createState() => _OrderListState();
}

class _OrderListState extends State<OrderList> {
  @override
  Widget build(BuildContext context) {

    final orders = Provider.of<QuerySnapshot>(context);
    /*orders.forEach((order) {
      print(order.address);
      print(order.telephone);
      print(order.food);
      order.food.forEach((item) {
        print(item);
      });
      print(order.price);
    });*/
    for(var doc in orders.documents) {
      print(doc.data);
    }

    return Container(
      
    );
  }
}