import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_project/models/order.dart';

class DatabaseService {

  final String uid;
  DatabaseService({ this.uid});

  // Collection Reference
  final CollectionReference orderCollection = Firestore.instance.collection('orders');

  Future<void> updateUserData(String address, int telephone, List<String> food, double price) async {
    return await orderCollection.document(uid).setData( {
      'address' : address,
      'telephone' : telephone,
      'food' : food,
      'price' : price,
    });
  }

  // order list from snapshot
  /*List<Order> _orderListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return Order(
        address: doc.data['address'] ?? '',
        telephone: doc.data['telephone'] ?? 0,
        food: doc.data['food'] ?? [],
        price: doc.data['price'] ?? 0
      );
    }).toList();
  }*/

  // get orders stream
  Stream<QuerySnapshot> get orders {
    return orderCollection.snapshots();
  }
}


