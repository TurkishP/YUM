import 'package:flutter/material.dart';
//import 'login.dart' as globals;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:image_picker/image_picker.dart';
import 'dart:async';
//import 'dart:io';
//import 'package:firebase_storage/firebase_storage.dart';
import 'model/user.dart';
import 'model/restaurant.dart';
//import 'model/selectedRest.dart';

String userDocID = "";
String foodType='"';
String selectedRestID;
String restToFoodID;
//Restaurant restaurant;
Restaurant selectedRest;

class AddRestaurantToFoodPage extends StatefulWidget {
  final FirebaseUser user;
  CustomUser myUser;
  String likedFoodDocID;
  String foodID;


  AddRestaurantToFoodPage({Key key, this.user, this.likedFoodDocID, this.foodID})
      : super(key: key);

  @override
  AddRestaurantToFoodPageState createState() => AddRestaurantToFoodPageState();
}

class AddRestaurantToFoodPageState extends State<AddRestaurantToFoodPage> {
//  File _image;
  double _cost = 2;

//  Future getImage() async {
//    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
//
//    setState(() {
//      _image = image;
//    });
//  }

  @override
  Widget build(BuildContext context) {
    final _comment = TextEditingController();
    print("likedFoodDocID is " + widget.likedFoodDocID);
    Future<void> _selectRestaurant() async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.all(new Radius.circular(20.0)),
            ),
//          backgroundColor: Theme.of(context).primaryColor,
//          title: Text('Please Check Your Choices!'),
            titlePadding: EdgeInsets.only(
              top: 4,
            ),
            content: Container(
              height: 800,
//              crossAxisAlignment: CrossAxisAlignment.end,
//              mainAxisAlignment: MainAxisAlignment.center,
              child: _restaurantList(context, widget.user, widget.likedFoodDocID, widget.foodID, widget.myUser),
            ),
//                Row(
//                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                    children: <Widget>[
//                      Icon(
//                        Icons.location_on,
//                        color: Colors.lightBlue[100],
//                        size: 20,
//                      ),
//                    ])

            actions: <Widget>[
              ButtonTheme(
                  height: 45,
                  minWidth: 90,
                  child: RaisedButton(
                    color: Theme.of(context).primaryColor,
                    child: Text(
                      "Back",
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                  )),
            ],
          );
        },
      );
    }
//    print(globals.globalUser.toString());

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          centerTitle: true,
          title: Text("WHERE HAVE YOU TRIED IT?"),
          actions: <Widget>[],
        ),
        body: ListView(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: _foodDetails(context, widget.user, widget.likedFoodDocID),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    children: <Widget>[
                      _getUser(context, widget.user),
                      _getSelectedRest(
                          context, widget.user, widget.foodID),

//              Text("${widget.likedFoodDocID}"),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: <Widget>[
                      Text(
                        "$_cost",
                        style: TextStyle(fontSize: 30),
                      ),
                      Slider(
                        activeColor: Colors.indigoAccent,
                        min: 0.0,
                        max: 5,
                        divisions: 50,
                        onChanged: (newRating) {
                          setState(() => _cost = newRating);
                          print(_cost);
                        },
                        value: _cost,
                      ),
//              Text("${widget.likedFoodDocID}"),
                    ],
                  ),
                ),
              ],
            ),
            Column(
              children: <Widget>[
//                Expanded(
//                  child:
                Padding(
                  padding: EdgeInsets.all(12),
                  child: TextFormField(
                    controller: _comment,
                    decoration: InputDecoration(
//                  filled: true,
                      labelText: 'Comment',
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter a product name';
                      } else {}
                    },
                  ),
                ),

//                ),
//                Expanded(
//                  child:
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    IconButton(
                      icon: const Icon(Icons.add_circle),
                      onPressed: _selectRestaurant,
                    ),
                    IconButton(
                      icon: const Icon(Icons.check),
                      iconSize: 40,
                      color: Colors.red,
                      onPressed: () {
                        Firestore.instance
                            .collection('restaurantToFood')
                            .document(restToFoodID)
                            .updateData({
                          "comment": _comment.text,
                          "rating": _cost,
//                          "docID": restToFoodID,

                        }).whenComplete(() => {
                        selectedRestID = "",
                        widget.myUser.reference.updateData({'visitedRestCnt': widget.myUser.visitedRestCnt+1}),
                        widget.myUser.reference.updateData({'yumPoint': widget.myUser.yumPoint+1}),
                        });
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
//                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _foodDetails(BuildContext context, FirebaseUser user, String foodID) {
//  print("foodID is " + foodID);

    return StreamBuilder(
      stream:
      Firestore.instance.collection('likedFood').document(foodID).snapshots(),
      builder: (context, snapshot) {
//      print(snapshot.data.documents.singleWhere((document)=>document['name']==documentID));
        if (!snapshot.hasData) return LinearProgressIndicator();
        print("type is " + snapshot.data['type']);
        foodType = snapshot.data['type'];
//      print("type is 222" + foodType);
        return _buildfoodDetails(context, snapshot.data, user, foodID);
      },
    );
  }

  Widget _buildfoodDetails(
      BuildContext context, foodSnapshot, FirebaseUser user, String foodID) {
//  final restaurant = restaurant.fromSnapshot(
//      snapshot.singleWhere((document) => document['name'] == restaurantName));
    return Column(
      children: [
        Stack(
          children: <Widget>[
            AspectRatio(
              aspectRatio: 18 / 11,
              child: Hero(
                tag: 'mainImage${foodSnapshot['name']}',
                child: Image.network(
                  foodSnapshot['image'],
                  fit: BoxFit.fitWidth,
                  height: 150,
                ),
              ),
            ),
          ],
        ),
//            titleSection,
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                    SizedBox(width: 10),
                    Flexible(
                        child: Text(
                          foodSnapshot['name'],
                          style:
                          TextStyle(color: Colors.blueAccent[100], fontSize: 20),
                        )),
                    SizedBox(width: 10),
                    Flexible(
                        child: Text(
                          "${foodSnapshot['cuisine']}",
                          style:
                          TextStyle(color: Colors.blueAccent[100], fontSize: 14),
                        )),
                  ]),
                  SizedBox(height: 6),
                ],
              ),
              SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.only(
                  left: 10,
                  right: 10,
                ),
                child: Divider(height: 0, color: Colors.black45),
              ),
            ])),
      ],
    );
  }

  Widget _getUser(
    BuildContext context,
    FirebaseUser user,
  ) {
//    print("user id is ${user.uid}");
    return StreamBuilder(
      stream: Firestore.instance.collection('user').snapshots(),
      builder: (context, snapshot) {
//      print(snapshot.data.documents.singleWhere((document)=>document['name']==documentID));
        if (!snapshot.hasData) return LinearProgressIndicator();
//        widget.myUser = snapshot.data;
//        print("custom user name?");
        widget.myUser = CustomUser.fromSnapshot(snapshot.data.documents
            .singleWhere((document) => document['uid'] == user.uid));
//        print("getUser" + widget.myUser.reference.documentID);
        userDocID = widget.myUser.reference.documentID;
//        print("userDocID " + userDocID);
        Firestore.instance.runTransaction((transaction) async {});

        return (Container());
//        return _buildList(
//            context, snapshot.data, user, restaurantName, documentID);
      },
    );
  }
}

//Widget _getSelectedRest(
//    BuildContext context, FirebaseUser user, String foodID) {
//  return StreamBuilder(
//    stream: Firestore.instance
//        .collection('restaurantToFood')
//        .document(restToFoodID)
//        .snapshots(),
//    builder: (context, snapshot) {
////      print(snapshot.data.documents.singleWhere((document)=>document['name']==documentID));
//      if (!snapshot.hasData) return LinearProgressIndicator();
//
//      return _buildSelectedRest(context, snapshot.data, user, foodID);
//    },
//  );
//}
Widget _getSelectedRest(
    BuildContext context, FirebaseUser user, String foodID) {
  return StreamBuilder<QuerySnapshot>(
    stream: Firestore.instance
        .collection("restaurantToFood")
        .where('foodID', isEqualTo: foodID)
//        .where('restID', isEqualTo: selectedRestID)
        .where('userID', isEqualTo: userDocID)
        .snapshots(),
    builder: (context, snapshot) {
      if (!snapshot.hasData) return CircularProgressIndicator();
      print("foodID that im looking for is " + foodID);
      return _buildSelectedRest(context, snapshot.data.documents, user, foodID);
    },
  );
}

Widget _buildSelectedRest(BuildContext context, List<DocumentSnapshot> snapshot,
    FirebaseUser user, String foodID) {
  return Container(
//    height: 200,
    child: ListView(
      shrinkWrap: true,
//    crossAxisCount: 2,
//      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.all(10.0),
//    childAspectRatio: 8.0 / 9.0,
//    padding: const EdgeInsets.only(top: 20.0),
      children: snapshot
          .map((data) => _buildRest(context, data, user, foodID))
          .toList(),
    ),
  );
}

Widget _buildRest(
    BuildContext context, restToFoodSnap, FirebaseUser user, String foodID) {
  if (restToFoodSnap['restID'] == selectedRestID) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Container(
          width: 150,
          child: Card(
              child: Container(
                  child: Column(
            children: [
              AspectRatio(
                aspectRatio: 18 / 11,
                child: Image.network(
                  restToFoodSnap['restImg'],
                  fit: BoxFit.fitWidth,
//                  height: 190,
                ),
              ),

//            titleSection,
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(width: 4),
                              Flexible(
                                  child: Text(
                                restToFoodSnap['restName'],
                                style: TextStyle(
                                    color: Colors.blueAccent[100],
                                    fontSize: 14),
                              )),
                              SizedBox(width: 4),
                            ]),
                      ],
                    ),
                  ])),
            ],
          ))),
        ),
      ],
    );
  } else {
    return Container();
  }
}

Widget _restaurantList(
    BuildContext context, FirebaseUser user, String likedFoodDocID, String foodID,CustomUser myUser) {
  return StreamBuilder<QuerySnapshot>(
    stream: Firestore.instance.collection('restaurant').snapshots(),
    builder: (context, snapshot) {
      if (!snapshot.hasData) return LinearProgressIndicator();

      return _buildRestaurantList(
          context, snapshot.data.documents, user, likedFoodDocID, foodID,myUser);
    },
  );
}

Widget _buildRestaurantList(BuildContext context,
    List<DocumentSnapshot> snapshot, FirebaseUser user, String likedFoodDocID, String foodID, CustomUser myUser) {
  return ListView(
//      shrinkWrap: true,
//    crossAxisCount: 2,
//    childAspectRatio: 8.0 / 9.0,
//    padding: const EdgeInsets.only(top: 20.0),
    children: snapshot
        .map((data) => _buildRestaurant(context, data, user, likedFoodDocID,foodID, myUser))
        .toList(),
  );
}

Widget _buildRestaurant(BuildContext context, DocumentSnapshot data,
    FirebaseUser user, String likedFoodDocID, String foodID, CustomUser myUser) {
  final restaurant = Restaurant.fromSnapshot(data);
//  print(restaurant.type);
//  print("food type is " + foodType);
  if (!(restaurant.type == foodType)) {
    return (Container());
  }
  return SizedBox(
      height: 200,
      child: Column(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              Firestore.instance.runTransaction((transaction) async {
                DocumentReference docRef = await Firestore.instance
                    .collection('restaurantToFood')
                    .add({
                  "userID": userDocID,
                  "foodID": foodID,
                  "likedFoodDocID" : likedFoodDocID,
                  "restImg": restaurant.image,
                  "userImg": user.photoUrl,
                  "restName": restaurant.name,
                  "restID": restaurant.reference.documentID,
                  "comment": "",
                  "rating":0,
                });
                restToFoodID = docRef.documentID;

              });

              selectedRestID = restaurant.reference.documentID;
              print("selected rest is now " + selectedRestID);
            },
            child: Card(
              child: Container(
                padding: EdgeInsets.all(2.0),
                child: Column(
                  children: <Widget>[
                    AspectRatio(
                      aspectRatio: 18 / 12,
                      child: Hero(
                        tag: '${restaurant.name}',
                        child: Image.network(
                          (restaurant.image != null)
                              ? restaurant.image
                              : 'https://images.pexels.com/photos/414612/pexels-photo-414612.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500',
                          fit: BoxFit.cover,
//                height: 200,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(4),
                      child: Text(
                        restaurant.name,
                        style: Theme.of(context).textTheme.body2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ));
}


