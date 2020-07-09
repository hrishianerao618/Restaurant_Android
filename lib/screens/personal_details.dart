import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:food_project/menu/menu.dart';
import 'package:food_project/notifier/auth_notifier.dart';
import 'package:food_project/shared/constants.dart';
import 'package:food_project/shared/loading.dart';
import 'package:provider/provider.dart';

class PersonalDetails extends StatefulWidget {
  @override
  _PersonalDetailsState createState() => _PersonalDetailsState();
}

class _PersonalDetailsState extends State<PersonalDetails> {
  String address = '';
  int telephone;
  //bool _validate = false;
  final databaseReference = Firestore.instance;
  final TextEditingController textFieldController = new TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  get foodItems => Menu.foodItems;
  get price => Menu.totalCost;
  
  void addFood() async {
    AuthNotifier authNotifier = Provider.of<AuthNotifier>(context, listen: false);
    DocumentReference ref = await databaseReference.collection("orders")
      .add({
        'name': authNotifier.user.displayName,
        'address': address,
        'telephone': telephone,
        'food': foodItems,
        'price': price
      });
    print(ref.documentID);
  }

  void orderPlacedDialog(BuildContext context) {
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () { 
        Menu.totalCost = 0;
        Menu.foodItems = [];
        Navigator.pop(context);
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Yummy"),
      content: Text("Order has been placed"),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void confirmOrNotDialog(BuildContext context) {
    String order = '';
    Menu.foodItems.forEach((f) {
      order += f + '\n';
    });
    Widget confirmButton = RaisedButton(
      child: Text("Confirm"),
      onPressed: () { 
        addFood();
        Navigator.pop(context);
        orderPlacedDialog(context);
      },
    );
    Widget cancelButton = RaisedButton(
      child: Text("Cancel"),
      onPressed: () { 
        Menu.totalCost = 0;
        Menu.foodItems = [];
        Navigator.pop(context);
        Navigator.pop(context);
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Order"),
      content: Text(order+'\nAmount: '+price.toString()),
      actions: [
        confirmButton,
        cancelButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[200],
      appBar: AppBar(
        backgroundColor: Colors.brown[400],
        elevation: 0.0,
        title: Text('Personal Details'),
      ),
      body: Container(
        child: Form(
          autovalidate: true,
          key: _formKey,
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
            child: Column(
              children: <Widget>[
                SizedBox(height: 20.0),
                TextFormField(
                  decoration: textInputDecoration.copyWith(hintText: 'Building No./Flat No.'),
                  validator: (String value) {
                    if (value.isEmpty) {
                      return 'Building No./Flat No. is required';
                    }
                    return null;
                  },
                  onSaved: (val) {
                    setState(() => address += val + ', ');
                  }
                ),
                SizedBox(height: 20.0),
                TextFormField(
                  decoration: textInputDecoration.copyWith(hintText: 'Building Name'),
                  validator: (String value) {
                    if (value.isEmpty) {
                      return 'Building Name is required';
                    }
                    return null;
                  },
                  onSaved: (val) {
                    setState(() => address += val + ', ');
                  }
                ),
                SizedBox(height: 20.0),
                TextFormField(
                  decoration: textInputDecoration.copyWith(hintText: 'Street'),
                  validator: (String value) {
                    if (value.isEmpty) {
                      return 'Street is required';
                    }
                    return null;
                  },
                  onSaved: (val) {
                    setState(() => address += val + ', ');
                  }
                ),
                SizedBox(height: 20.0),
                TextFormField(
                  decoration: textInputDecoration.copyWith(hintText: 'Area'),
                  validator: (String value) {
                    if (value.isEmpty) {
                      return 'Area is required';
                    }
                    return null;
                  },
                  onSaved: (val) {
                    setState(() => address += val);
                  }
                ),
                SizedBox(height: 20.0),
                TextFormField(
                  decoration: textInputDecoration.copyWith(hintText: 'Telephone Number'),
                  validator: (String value) {
                    if (value.length != 10) {
                      return 'Enter a phone number with 10 digits';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                    WhitelistingTextInputFormatter.digitsOnly
                  ],
                  onSaved: (val) {
                    setState(() => telephone = int.parse(val));
                  }
                ),
                SizedBox(height:20.0),
                RaisedButton(
                  color: Colors.pink[400],
                  child: Text(
                    'Order',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    if (!_formKey.currentState.validate()) {
                      return;
                    }
                    _formKey.currentState.save();
                    confirmOrNotDialog(context);
                  }
                ),
              ],
            ),
          ),
        ),
      ),
    ); 
  }
}