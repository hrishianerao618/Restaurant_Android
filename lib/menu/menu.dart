import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:food_project/api/food_api.dart';
import 'package:food_project/notifier/auth_notifier.dart';
import 'package:food_project/notifier/food_notifier.dart';
import 'package:food_project/screens/food_detail.dart';
import 'package:food_project/screens/personal_details.dart';
import 'package:provider/provider.dart';

class Menu extends StatefulWidget {
  static List<String> foodItems = [];
  static double totalCost = 0;

  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  int quantity = 0;

  @override
  void initState() {
    FoodNotifier foodNotifier = Provider.of<FoodNotifier>(context, listen: false);
    getFoods(foodNotifier);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AuthNotifier authNotifier = Provider.of<AuthNotifier>(context, listen: false);
    FoodNotifier foodNotifier = Provider.of<FoodNotifier>(context);
    return Scaffold(
      backgroundColor: Colors.brown[200],
      appBar: AppBar(
        backgroundColor: Colors.brown[400],
        elevation: 0.0,
        title: Text(
          authNotifier.user != null ? authNotifier.user.displayName : "Menu",
        ),
        actions: <Widget>[
          // action button
          FlatButton(
            onPressed: () => signout(authNotifier),
            child: Text(
              "Logout",
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
          ),
        ],
      ),
      body: ListView.separated(
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              leading: Image.network(foodNotifier.foodList[index].image,
                width: 120,
                fit: BoxFit.fitWidth,
              ),
              title: Text(foodNotifier.foodList[index].name,
                style: TextStyle(color: Colors.white,
                  fontSize: 16,
                ),  
              ),
              subtitle: Text('Price: ₹'+foodNotifier.foodList[index].price.toString(),
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
              trailing: RaisedButton(
                color: Colors.pink[400],
                child: Text(
                  "Add to Cart",
                  style: TextStyle(color: Colors.white,
                    fontSize: 14
                  ),
                ),
                onPressed: () {
                  foodNotifier.currentFood = foodNotifier.foodList[index];
                  print(foodNotifier.currentFood.name);
                  Menu.foodItems.add(foodNotifier.currentFood.name);
                  showQuantityDialog(context, foodNotifier.currentFood.name, foodNotifier.currentFood.price);
                }
              ),
              onTap: () {
                /*foodNotifier.currentFood = foodNotifier.foodList[index];
                Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
                  return FoodDetail();
                }));*/
              },
            );
          },
          itemCount: foodNotifier.foodList.length,
          separatorBuilder: (BuildContext context, int index) {
            return Divider(
              color: Colors.black,
            );
          },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.done),
        foregroundColor: Colors.white,
        onPressed: () {
          if(Menu.totalCost == 0) {
            print('Please choose an item!');
            pleaseBuyDialog(context);
          } else {
            Navigator.push(context, MaterialPageRoute(builder: (context) => PersonalDetails()));
          }
        },
      ),
    );
  }

  void pleaseBuyDialog(BuildContext context) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () { 
        Navigator.pop(context);
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Order List Empty"),
      content: Text("Please select an item!"),
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

    /*
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown[400],
        elevation: 0.0,
        title: Text('Order Details'),
      ),
      body: ListView.separated(
        itemBuilder: (BuildContext ontext, int index) {
          return ListTile(
            leading: Image.network(
              foodNotifier.foodList[index].image,
              width: 120,
              fit: BoxFit.fitWidth,
            ),
            title: Text(foodNotifier.foodList[index].name),
            subtitle: Text(foodNotifier.foodList[index].price.toString()),
          );
        },
        itemCount: foodNotifier.foodList.length, 
        separatorBuilder: (BuildContext context, int index) {
          return Divider(
            color: Colors.pink[400],
          );
        },
      )
      /*body: Column (
        children: <Widget>[
          Expanded(
            child: SizedBox(
              child: new GridView.extent (
                maxCrossAxisExtent: 180.0,
                mainAxisSpacing: 5.0,
                crossAxisSpacing: 5.0,
                children: _buildGridTiles(context, 4),
              ),
            ),
          ),
          Container(
            child: RaisedButton(
              color: Colors.pink[400],
              child: Text(
                'Proceed',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () async {
                foodPrices.forEach((food){
                  totalCost += food;
                });
                print(totalCost);
              }
            ),
          ),
        ],
      ),*/
    );
  }*/
  
  void showQuantityDialog(BuildContext context, String name, int price) {
  Dialog fancyDialog = Dialog(
    child: Container(
      height: 150.0,
      width: 150.0,
      child: Stack(
        children: <Widget>[
          Container(
            width: double.infinity,
            height: 300,
          ),
          Container(
            width: double.infinity,
            height: 50,
            alignment: Alignment.bottomCenter,
            child: Column(
              children: <Widget>[ Align(
                alignment: Alignment.center,
                child: Text(
                  "How many $name?",
                  style: TextStyle(
                    color: Colors.pink,
                    fontSize: 20,
                    fontWeight: FontWeight.w600
                  ),
                ),
              ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: TextFormField(
              style: new TextStyle(
                fontSize: 18.0,            
              ),
              textAlign: TextAlign.center,
              decoration: new InputDecoration(
                hintText: 'Enter quantity'
              ),
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                WhitelistingTextInputFormatter.digitsOnly
              ],
              onChanged: (val) {
                setState(() => quantity = int.parse(val));
              }
              ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: RaisedButton(
                color: Colors.pink[400],
                child: Text(
                  'Done',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () async {
                  Menu.totalCost += (quantity * price);
                  Navigator.pop(context);
                  /*foodPrices[index-1] = prices[index-1] * foodQuantity[index-1];
                  foodPrices.forEach((price) {
                    print(price);
                  });
                  Navigator.pop(context);*/
                }
              ),
          ),
          /*Align(
            alignment: Alignment.center,
            child: new DropdownButton<String>(
              items: <String>['1','2','3','4','5'].map((String value) {
                return new DropdownMenuItem<String>(
                  value: dropDownValue,
                  child: new Text(value),
                );
              }).toList(),
              onChanged: (String newValue) {
                dropDownValue = newValue;
              },
            ),
          ),*/
          
          /*Align(
            alignment: Alignment.bottomCenter,
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                width: double.infinity,
                height: 50,
                child: Align(
                  alignment: Alignment.center,
                    child: Text(
                      "Done",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600
                      ),
                    ),  
                ),
              ),
            ),
          ),*/
          /*Align(
          // These values are based on trial & error method
            alignment: Alignment(1.05, -1.05),
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.close,
                  color: Colors.black,
                ),
              ),
            ),
          ),*/
        ],
      ),
    ),
  );
  showDialog(
      context: context, builder: (BuildContext context) => fancyDialog);
 }
  /*
  List<Widget> _buildGridTiles(context, numberOfTiles) {
    List<Container> containers = new List<Container>.generate(numberOfTiles, 
    (int index) {
      String description='';
      // index = 0,1,2,...
      if(index + 1 == 1) {
        description = 'Burger (Price: 50)';
      }else if (index + 1 == 2) {
        description = 'Pizza (Price: 80)';
      }else if (index + 1 == 3) {
        description = 'Noodles (Price: 70)';
      }else if (index + 1 == 4) {
        description = 'Ice Cream (Price: 60)';
      }
      final imageName = 'images/image0${index+1}.jpg';
      return new Container(
        child: InkWell(
            onTap: () {
              showQuantityDialog(context, index+1);
            },
            child: Container(
              child: ClipRRect(
                child: Column (
                  children: <Widget>[
                    new Image.asset(
                    imageName,
                    fit: BoxFit.fill,
                    ),
                    Text(
                      description,
                      style: TextStyle(color: Colors.pink, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
        ),
      );
    }
    );
    return containers;
  }*/
}




