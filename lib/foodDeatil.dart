import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'model/food.dart';
import 'model/user.dart';
import 'model/likedFood.dart';

import 'package:firebase_auth/firebase_auth.dart';
//import 'edit.dart';

class FoodDetailPage extends StatefulWidget {
  final Food food;
  final FirebaseUser user;
  String foodID;
  FoodDetailPage({Key key, this.food, this.user, this.foodID})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return FoodDetailPageState();
  }
}

class FoodDetailPageState extends State<FoodDetailPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,

          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          centerTitle: true,
          title: Text('${widget.food.name}'),
          actions: <Widget>[
//            IconButton(
//              icon: Icon(
//                Icons.delete,
//                semanticLabel: 'delete',
//              ),
//              onPressed: () => (widget.user.uid == widget.restaurant.creator)
//                  ? Firestore.instance.runTransaction((transaction) async {
//                await transaction
//                    .delete(widget.restaurant.reference)
//                    .whenComplete(() => Navigator.of(context).pop());
//              })
//                  : print('you are not allowed'),
//            ),
          ],
        ),
        body: _foodDetails(context, widget.user, widget.foodID, widget.food),
      ),
    );
  }
}

Widget _foodDetails(
    BuildContext context, FirebaseUser user, String foodID, Food food) {
  return StreamBuilder(
    stream: Firestore.instance
        .collection('food')
        .document(food.reference.documentID)
        .snapshots(),
    builder: (context, snapshot) {
//      print(snapshot.data.documents.singleWhere((document)=>document['name']==documentID));
      if (!snapshot.hasData) return LinearProgressIndicator();
      print(snapshot.data);
      return _buildfoodDetails(context, snapshot.data, user, foodID, food);
    },
  );
}

Widget _buildfoodDetails(BuildContext context, foodSnapshot, FirebaseUser user,
    String foodID, Food food) {
//  final restaurant = restaurant.fromSnapshot(
//      snapshot.singleWhere((document) => document['name'] == restaurantName));
  return ListView(
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
                  Row(children: [
                    SizedBox(width: 4),
                    Text(
                      "${foodSnapshot['level']}",
                      style: TextStyle(color: Colors.blue[900], fontSize: 30),
                      maxLines: 1,
                    ),
                    SizedBox(
                      width: 35,
                      height: 35,
                      child: _haveEaten(context, user, foodID, food), //button to add the food to eaten list
                    ),
                  ]),
                ]),
                SizedBox(height: 10),
                Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                  SizedBox(width: 10),
                  Flexible(
                      child: Text(
                    foodSnapshot['name'],
                    style:
                        TextStyle(color: Colors.blueAccent[100], fontSize: 20),
                  )),
                ]),
                SizedBox(height: 6),
                Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                  SizedBox(width: 10),
                  Flexible(
                      child: Text(
                    "${foodSnapshot['cuisine']}",
                    style:
                        TextStyle(color: Colors.blueAccent[100], fontSize: 14),
                  )),
                ]),
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
            SizedBox(
              height: 10,
            ),
            Container(
              width: 300,
              child: Row(children: [
                Flexible(
                  child: Text(
                    foodSnapshot['description'],
                    style:
                        TextStyle(color: Colors.blueAccent[100], height: 1.2),
                  ),
                )
              ]),
            ),
          ])),
    ],
  );
}

Widget _haveEaten(
    BuildContext context, FirebaseUser user, String foodID, Food food) {
  return StreamBuilder(
    stream: Firestore.instance.collection('user').snapshots(),
    builder: (context, snapshot) {
      if (!snapshot.hasData) return LinearProgressIndicator();

      return _haveEatenButton(
          context, snapshot.data.documents, user, foodID, food);
    },
  );
}

Widget _haveEatenButton(BuildContext context, List<DocumentSnapshot> snapshot,
    FirebaseUser user, String foodID, Food food) {
  SnackBar snackBar;
  final appUser = CustomUser.fromSnapshot(
      snapshot.singleWhere((document) => document['uid'] == user.uid));

  var dataExists;
  String thisLikedFood;
  Firestore.instance.runTransaction((transaction) async {
    Firestore.instance
        .collection("likedFood")
        .where('foodID', isEqualTo: '${foodID}')
        .where('userID', isEqualTo: '${appUser.reference.documentID}')
        .getDocuments()
        .then((data) {
      if (data.documents.first.data['userID'] ==
          '${appUser.reference.documentID}') {
        print(data.documents.first.reference.documentID);
        dataExists = true;
        thisLikedFood = data.documents.first.reference.documentID;
        print(dataExists);
      } else {
        dataExists = null;
        print(dataExists);
      }
    });
  });

  return SizedBox(
    height: 35.0,
    width: 35.0,
    child: IconButton(
        icon: Icon(
          Icons.thumb_up,
          color: Colors.red,
        ),
        onPressed: () {
          (dataExists == null)
              ? Firestore.instance.runTransaction((transaction) async {
                  Firestore.instance.collection('likedFood').add({
                    "userID": appUser.reference.documentID,
                    "image": food.image,
                    "foodID": food.reference.documentID,
                    "name": food.name,
                  });

                  dataExists = true;
                  print(dataExists);
                })
              : print(dataExists);

          Scaffold.of(context).showSnackBar(SnackBar(
              content: (dataExists == null)
                  ? Text('Added Successfully!')
                  : Text('You can only do it once!!'),
              action: SnackBarAction(
                label: 'Undo',
                onPressed: () {
                  Firestore.instance.runTransaction((transaction) async {
                    Firestore.instance
                        .collection("likedFood")
                        .where('foodID', isEqualTo: '${foodID}')
                        .where('userID', isEqualTo: '${appUser.reference.documentID}')
                        .getDocuments()
                        .then((data) {
                        print("undo docID " + data.documents.first.reference.documentID);

                        thisLikedFood = data.documents.first.reference.documentID;

                    });
                  });
                  Future.delayed(const Duration(milliseconds: 600), () {
                    Firestore.instance
                        .collection('likedFood')
                        .document(thisLikedFood)
                        .delete()
                        .whenComplete(
                            () => {dataExists = null, print(dataExists)});

                  });

                },
              )));
        }),
  );
}
