import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'model/food.dart';
import 'model/user.dart';
//import 'model/likedFood.dart';
import 'model/restaurant.dart';
import 'addRestaurantToFood.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'model/selectedRest.dart';

//import 'edit.dart';
String foodType;
String thisLikedFood;
String userDocID = "";

class FoodDetailPage extends StatefulWidget {
  final FirebaseUser user;
  String foodID;
  String foodName;
  CustomUser myUser;
  FoodDetailPage({Key key, this.foodName, this.user, this.foodID})
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
          backgroundColor: Colors.red,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          centerTitle: true,
          title: Text('${widget.foodName}'),
          actions: <Widget>[],
        ),
        body: ListView(
          children: <Widget>[
            _getUser(context, widget.user),
            Row(
              children: <Widget>[
                Expanded(
                  child: _foodDetails(
                      context, widget.user, widget.foodID, widget.myUser),
                ),
              ],
            ),
            _restaurantsSellingThisFood(context, widget.user, widget.foodID),
          ],
        ),
      ),
    );
  }

  Widget _getUser(
    BuildContext context,
    FirebaseUser user,
  ) {
    print("user id is ${user.uid}");
    return StreamBuilder(
      stream: Firestore.instance.collection('user').snapshots(),
      builder: (context, snapshot) {
//      print(snapshot.data.documents.singleWhere((document)=>document['name']==documentID));
        if (!snapshot.hasData) return LinearProgressIndicator();
//        widget.myUser = snapshot.data;
//        print("custom user name?");
        widget.myUser = CustomUser.fromSnapshot(snapshot.data.documents
            .singleWhere((document) => document['uid'] == user.uid));
        print("getUser" + widget.myUser.reference.documentID);
        userDocID = widget.myUser.reference.documentID;
        print("userDocID " + userDocID);
        Firestore.instance.runTransaction((transaction) async {});

        return Container();
//        return _buildList(
//            context, snapshot.data, user, restaurantName, documentID);
      },
    );
  }
}

Widget _restaurantsSellingThisFood(
    BuildContext context, FirebaseUser user, String foodID) {
  print("foodID is what " + foodID);

  return StreamBuilder<QuerySnapshot>(
    stream: Firestore.instance.collection('restaurantToFood').snapshots(),
    builder: (context, snapshot) {
      if (!snapshot.hasData) return LinearProgressIndicator();

      return _buildRestaurantSellingThisFoodList(
          context, snapshot.data.documents, user, foodID);
    },
  );
}

Widget _buildRestaurantSellingThisFoodList(BuildContext context,
    List<DocumentSnapshot> snapshot, FirebaseUser user, String foodID) {
  return Container(
    height: 160,
    width: 200,
    padding: EdgeInsets.only(right: 4),
    child: ListView(
      shrinkWrap: true,
//    crossAxisCount: 2,
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.all(8.0),
//    childAspectRatio: 8.0 / 9.0,
//    padding: const EdgeInsets.only(top: 20.0),
      children: snapshot
          .map((data) =>
              _buildARestaurantSellingThisFood(context, data, user, foodID))
          .toList(),
    ),
  );
}

Widget _buildARestaurantSellingThisFood(BuildContext context,
    DocumentSnapshot data, FirebaseUser user, String foodID) {
  final restaurant = SelectedRest.fromSnapshot(data);
//  print("rest name is ${restaurant.restName}");
  if (restaurant.foodID == foodID) {
    return Container(
      margin: EdgeInsets.only(right: 3),
      width: 150,
//    height: 100,
      padding: EdgeInsets.only(right: 4),
      key: ValueKey(restaurant.restName.toString()),
      child: Card(
          child: Container(
              child: Column(
        children: [
          AspectRatio(
            aspectRatio: 18 / 9,
            child: Image.network(
              restaurant.restImg,
              fit: BoxFit.fitWidth,
//                  height: 190,
            ),
          ),

//            titleSection,
          Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 8, 4),
              child: Column(children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                      Flexible(
                          child: Text(
                        restaurant.restName,
                        style: TextStyle(
                            color: Colors.blueAccent[100], fontSize: 14),
                      )),
                      SizedBox(width: 4),
                    ]),
                    SizedBox(height: 8),
                    Row(
                      children: <Widget>[
                        ClipOval(
                          child: Image.network(
                            restaurant.userImg,
                            width: 25,
                            height: 25,
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                        SizedBox(width: 8),
                        Flexible(
                            child: Text(
                          restaurant.comment,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: TextStyle(
                              color: Colors.blueAccent[100], fontSize: 10),
                        )),
                      ],
                    )
                  ],
                ),
              ])),
        ],
      ))),
    );
  } else {
    return Container();
  }
}

Widget _foodDetails(
    BuildContext context, FirebaseUser user, String foodID, CustomUser myUser) {
//  print("foodID is " + foodID);

  return StreamBuilder(
    stream: Firestore.instance.collection('food').document(foodID).snapshots(),
    builder: (context, snapshot) {
//      print(snapshot.data.documents.singleWhere((document)=>document['name']==documentID));
      if (!snapshot.hasData) return LinearProgressIndicator();
      print("type is " + snapshot.data['type']);
      foodType = snapshot.data['type'];
//      print("type is 222" + foodType);
      return _buildfoodDetails(context, snapshot.data, user, foodID, myUser);
    },
  );
}

Widget _buildfoodDetails(BuildContext context, foodSnapshot, FirebaseUser user,
    String foodID, CustomUser myUser) {
//  final restaurant = restaurant.fromSnapshot(
//      snapshot.singleWhere((document) => document['name'] == restaurantName));
  return Column(
    children: [
      Stack(
        children: <Widget>[
          AspectRatio(
            aspectRatio: 18 / 9,
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
                SizedBox(height: 9),
                Row(children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(width: 9),
                        Text(
                          "LVL ${foodSnapshot['level']}",
                          style:
                              TextStyle(color: Colors.blue[900], fontSize: 30),
                          maxLines: 1,
                        ),
                        SizedBox(width: 135),
                        SizedBox(
                          width: 35,
                          height: 35,
                          child: _haveEaten(context, user, foodID, foodSnapshot,
                              myUser), //button to add the food to eaten list
                        ),
                        SizedBox(
                          width: 35,
                          height: 35,
                          child: SizedBox(
                            height: 35.0,
                            width: 35.0,
                            child: IconButton(
                                icon: Icon(
                                  Icons.add_location,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        AddRestaurantToFoodPage(
                                          user: user,
                                          likedFoodDocID: thisLikedFood,
                                          foodID: foodID,
                                        ),
                                  ));
                                }),
                          ), //button to add the food to eaten list
                        ),
                        SizedBox(
                          width: 35,
                          height: 35,
                          child: _addToWishlist(context, user, foodID,
                              foodSnapshot), //button to add the food to eaten list
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

Widget _haveEaten(BuildContext context, FirebaseUser user, String foodID,
    foodSnapshot, CustomUser myUser) {
  return StreamBuilder(
    stream: Firestore.instance.collection('user').snapshots(),
    builder: (context, snapshot) {
      if (!snapshot.hasData) return LinearProgressIndicator();

      return _haveEatenButton(
          context, snapshot.data.documents, user, foodID, foodSnapshot, myUser);
    },
  );
}

Widget _haveEatenButton(BuildContext context, List<DocumentSnapshot> snapshot,
    FirebaseUser user, String foodID, foodSnapshot, CustomUser myUser) {
//  SnackBar snackBar;
  final appUser = CustomUser.fromSnapshot(
      snapshot.singleWhere((document) => document['uid'] == user.uid));

  var dataExists;
//  String thisLikedFood;
  Firestore.instance.runTransaction((transaction) async {
    Firestore.instance
        .collection("likedFood")
        .where('foodID', isEqualTo: '$foodID')
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
          Icons.local_dining,
          color: Colors.red,
        ),
        onPressed: () {
          (dataExists == null)
              ? Firestore.instance.runTransaction((transaction) async {
                  Firestore.instance.collection('likedFood').add({
                    "userID": appUser.reference.documentID,
                    "image": foodSnapshot['image'],
                    "foodID": foodID,
                    "name": foodSnapshot['name'],
                    "type": foodSnapshot['type'],
                    "cuisine": foodSnapshot['cuisine'],
                  }).whenComplete(() => {
                        myUser.reference.updateData(
                            {'eatenFoodCnt': myUser.eatenFoodCnt + 1}),
                        myUser.reference
                            .updateData({'yumPoint': myUser.yumPoint + 1}),
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
                        .where('foodID', isEqualTo: '$foodID')
                        .where('userID',
                            isEqualTo: '${appUser.reference.documentID}')
                        .getDocuments()
                        .then((data) {
                      print("undo docID " +
                          data.documents.first.reference.documentID);

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

Widget _addToWishlist(
    BuildContext context, FirebaseUser user, String foodID, foodSnapshot) {
  return StreamBuilder(
    stream: Firestore.instance.collection('user').snapshots(),
    builder: (context, snapshot) {
      if (!snapshot.hasData) return LinearProgressIndicator();

      return _wishButton(
          context, snapshot.data.documents, user, foodID, foodSnapshot);
    },
  );
}

Widget _wishButton(BuildContext context, List<DocumentSnapshot> snapshot,
    FirebaseUser user, String foodID, foodSnapshot) {
  final appUser = CustomUser.fromSnapshot(
      snapshot.singleWhere((document) => document['uid'] == user.uid));

  var dataExists;
  String thisLikedFood;
  Firestore.instance.runTransaction((transaction) async {
    Firestore.instance
        .collection("wishList")
        .where('foodID', isEqualTo: '$foodID')
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
          Icons.favorite,
          color: Colors.red,
        ),
        onPressed: () {
          (dataExists == null)
              ? Firestore.instance.runTransaction((transaction) async {
                  Firestore.instance.collection('wishList').add({
                    "userID": appUser.reference.documentID,
                    "image": foodSnapshot['image'],
                    "foodID": foodID,
                    "name": foodSnapshot['name'],
                    "type": foodSnapshot['type'],
                    "cuisine": foodSnapshot['cuisine'],
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
                        .collection("wishList")
                        .where('foodID', isEqualTo: '$foodID')
                        .where('userID',
                            isEqualTo: '${appUser.reference.documentID}')
                        .getDocuments()
                        .then((data) {
                      print("undo docID " +
                          data.documents.first.reference.documentID);

                      thisLikedFood = data.documents.first.reference.documentID;
                    });
                  });
                  Future.delayed(const Duration(milliseconds: 600), () {
                    Firestore.instance
                        .collection('wishList')
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

Widget _restaurantList(BuildContext context, FirebaseUser user) {
  return StreamBuilder<QuerySnapshot>(
    stream: Firestore.instance.collection('restaurant').snapshots(),
    builder: (context, snapshot) {
      if (!snapshot.hasData) return LinearProgressIndicator();

      return _buildRestaurantList(context, snapshot.data.documents, user);
    },
  );
}

Widget _buildRestaurantList(
    BuildContext context, List<DocumentSnapshot> snapshot, FirebaseUser user) {
  return ListView(
//      shrinkWrap: true,
//    crossAxisCount: 2,
//    childAspectRatio: 8.0 / 9.0,
//    padding: const EdgeInsets.only(top: 20.0),
    children:
        snapshot.map((data) => _buildRestaurant(context, data, user)).toList(),
  );
}

Widget _buildRestaurant(
    BuildContext context, DocumentSnapshot data, FirebaseUser user) {
  final restaurant = Restaurant.fromSnapshot(data);
  print(restaurant.type);
  if (!(restaurant.type == foodType)) {
    return (Container());
  }
  return SizedBox(
      height: 200,
      child: Column(
        children: <Widget>[
          GestureDetector(
            onTap: () {
//            Navigator.of(context).push(MaterialPageRoute(
//              builder: (context) =>
//                  DetailPage(restaurant: restaurant, user: user),
//            ));
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
