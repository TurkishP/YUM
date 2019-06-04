import 'package:flutter/material.dart';
import 'login.dart' as globals;
import 'package:firebase_auth/firebase_auth.dart';
import 'login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'model/user.dart';
import 'model/food.dart';
import 'foodDeatil.dart';
import 'model/likedFood.dart';

final GoogleSignIn _googleSignIn = GoogleSignIn();
final Set likedFoodTypes = Set();
String userDocID = "";

class ProfilePage extends StatefulWidget {
  FirebaseUser user;
  CustomUser myUser;
  ProfilePage({Key key, this.user}) : super(key: key);

  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
//    print(widget.user);
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
          title: _getUser(context, widget.user),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.exit_to_app,
                semanticLabel: 'exit',
              ),
              onPressed: () {
                _handleSignOut();
                Navigator.of(context).pop();

                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => LoginPage(),
                ));
              },
            ),
          ],
        ),
        body: Container(
          child: Center(
            child: ListView(
//          margin: const EdgeInsets.only( left: 4.0, right: 4.0),
                children: [
                  Stack(
                    children: <Widget>[
                      Container(
                        height: 200,
                        width: 360,
                        child: _getCoverImg(context, widget.user),
                      ),
                      Positioned(
                        left: 15.0,
                        top: 115.0,
//                  child: FavoriteWidget(saved, product.id),
                        child: ClipOval(
                          child: Image.network(
                            (widget.user.photoUrl != null)
                                ? widget.user.photoUrl
                                : 'https://images.pexels.com/photos/414612/pexels-photo-414612.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500',
                            width: 70,
                            height: 70,
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                      ),
                    ],
                  ),
                  _userInfo(context, userDocID, widget.user),
                  Container(
                    padding: EdgeInsets.fromLTRB(8, 15, 0, 0),
                    child: Text(
                      "Food",
                      style: Theme.of(context).textTheme.body2,
                    ),
                  ),
                  _foodList(context, widget.user),
                  Container(
                    padding: EdgeInsets.fromLTRB(8, 4, 0, 0),
                    child: Text(
                      "Suggestions",
                      style: Theme.of(context).textTheme.body2,
                    ),
                  ),
                  _suggestions(context, userDocID, widget.user),
                  _findSuggestions(context, widget.user),
                ]),
          ),
        ),
      ),
    );
  }

  Future<void> _handleSignOut() async {
    _googleSignIn.disconnect();
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

        return Text("Welcome ${widget.myUser.displayName}");
//        return _buildList(
//            context, snapshot.data, user, restaurantName, documentID);
      },
    );
  }

  Widget _getCoverImg(
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
//        print(widget.myUser.displayName);
        return Image.network(
          widget.myUser.coverImg,
          fit: BoxFit.fill,
        );
//        return _buildList(
//            context, snapshot.data, user, restaurantName, documentID);
      },
    );
  }
}

Widget _foodList(BuildContext context, FirebaseUser user) {
  return StreamBuilder<QuerySnapshot>(
    stream: Firestore.instance.collection('likedFood').snapshots(),
    builder: (context, snapshot) {
      if (!snapshot.hasData) return LinearProgressIndicator();

      return _buildFoodList(context, snapshot.data.documents, user);
    },
  );
}

Widget _buildFoodList(
    BuildContext context, List<DocumentSnapshot> snapshot, FirebaseUser user) {
  return Container(
//    padding: EdgeInsets.only(bottom: 3),
//    height: 800,
//    height: 208,
//    width: ,
//    padding: EdgeInsets.only(right:4),

    child: GridView.count(
      crossAxisCount: 3,
//      padding: EdgeInsets.all(8.0),
      shrinkWrap: true,
//    crossAxisCount: 2,
//      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.only(top: 4.0),
      children:
          snapshot.map((data) => _buildFood(context, data, user)).toList(),
    ),
  );
}

Widget _buildFood(BuildContext context, DocumentSnapshot data, user) {
  LikedFood likedfood = LikedFood.fromSnapshot(data);
//  print("suggested food ${likedfood.name}");
  return Container(
    padding: EdgeInsets.fromLTRB(2, 0, 2, 0),
//    width: 140, height: 100,

//    width: cardWidth, height: 100,
//    clipBehavior: Clip.antiAlias,
    key: ValueKey(likedfood.name.toString()),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Stack(
          children: <Widget>[
            GestureDetector(
              onTap: () {
                print("foodID we sent is ${likedfood.foodID}");

                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => FoodDetailPage(
                      foodName: likedfood.name,
                      user: user,
                      foodID: likedfood.foodID),
                ));
              },
              onLongPress: () {
                Firestore.instance
                    .collection('likedFood')
                    .document(likedfood.reference.documentID)
                    .delete();
              },
              child: AspectRatio(
                aspectRatio: 1 / 1,
                child: Hero(
                  tag: '${likedfood.name}',
                  child: Image.network(
                    (likedfood.image != null)
                        ? likedfood.image
                        : 'https://images.pexels.com/photos/414612/pexels-photo-414612.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500',
                    fit: BoxFit.cover,
//                    height: 150,
                  ),
                ),
              ),
            ),
            Positioned(
              right: 10.0,
              top: 70.0,
//                  child: FavoriteWidget(saved, product.id),
              child: Row(
                children: <Widget>[
//                  Text(food.name, style: Theme.of(context).textTheme.subhead,),
                ],
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

Widget _userInfo(BuildContext context, String userDocID, FirebaseUser user) {
//  print("in suggestions" + userDocID);
  return StreamBuilder(
    stream:
        Firestore.instance.collection("user").document(userDocID).snapshots(),
    builder: (context, snapshot) {
      if (!snapshot.hasData) return LinearProgressIndicator();
      return _buildUserInfo(context, snapshot.data, user);
    },
  );
}

Widget _buildUserInfo(BuildContext context, userDoc, FirebaseUser user) {
  return Container(
    padding: EdgeInsets.fromLTRB(10, 4, 4, 4),
    child: Column(
      children: <Widget>[
        SizedBox(height: 8),
        Row(
          children: <Widget>[
            SizedBox(
              width: 4,
            ),


            Text(
              userDoc['displayName'],
              style: TextStyle(
                  fontSize: 20.0,
                  fontStyle: FontStyle.normal,
                  color: Colors.black),
            ),

          ],
        ),
        Row(
          children: <Widget>[
            SizedBox(
              width: 6,
            ),
            Text(
              "LEVEL " + userDoc['level'].toString(),
              style: TextStyle(
                  fontSize: 15.0,
                  fontStyle: FontStyle.normal,
                  color: Colors.black),
            ),

          ],
        ),

        SizedBox(
          height: 30,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 100,
              child: Card(
                  child: Container(
                      child: Column(
                        children: [
                          AspectRatio(
                            aspectRatio: 18 / 14,
                            child:  Icon(
                              Icons.location_on,
                              size: 40,
                              color: Colors.red,
                            ),
                          ),
                          Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          SizedBox(width: 4),
                                          Flexible(
                                              child: Text(
                                                userDoc['visitedRestCnt'].toString(),
                                                style: TextStyle(
                                                    color: Colors.red,
                                                    fontSize: 30),
                                              )),
                                          SizedBox(width: 4),
                                        ]),
                                  ],
                                ),
                              ])),
                        ],
                      ))),
            ),
            Container(
              width: 100,
              child: Card(
                  child: Container(
                      child: Column(
                        children: [
                          AspectRatio(
                            aspectRatio: 18 / 14,
                            child:  Icon(
                              Icons.restaurant,
                              size: 40,
                              color: Colors.blueAccent,

                            ),
                          ),
                          Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          SizedBox(width: 4),
                                          Flexible(
                                              child: Text(
                                                userDoc['eatenFoodCnt'].toString(),
                                                style: TextStyle(
                                                    color: Colors.blueAccent,
                                                    fontSize: 30),
                                              )),
                                          SizedBox(width: 4),
                                        ]),
                                  ],
                                ),
                              ])),
                        ],
                      ))),
            ),
            Container(
              width: 100,
              child: Card(
                  child: Container(
                      child: Column(
                        children: [
                          AspectRatio(
                            aspectRatio: 18 / 14,
                            child:  Icon(
                              Icons.comment,
                              size: 40,
                              color: Colors.black,

                            ),
                          ),
                          Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          SizedBox(width: 4),
                                          Flexible(
                                              child: Text(
                                                userDoc['commentCnt'].toString(),
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 30),
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
        ),
      ],
    ),
  );
}

Widget _suggestions(
    BuildContext context, String referenceID, FirebaseUser user) {
  print("in suggestions" + userDocID);
  return StreamBuilder<QuerySnapshot>(
    stream: Firestore.instance
        .collection("likedFood")
        .where('userID', isEqualTo: '$userDocID')
        .snapshots(),
    builder: (context, snapshot) {
      if (!snapshot.hasData) return LinearProgressIndicator();
      print("suggestions is working");
      return _buildSuggestions(context, snapshot.data.documents, user);
    },
  );
}

Widget _buildSuggestions(
    BuildContext context, List<DocumentSnapshot> snapshot, FirebaseUser user) {
  return Container(
    padding: EdgeInsets.only(bottom: 3),
//    height: 400,
//    height: 208,
//    width: ,
//    padding: EdgeInsets.only(right:4),

    child: Row(
//      crossAxisCount: 3,
//      padding: EdgeInsets.all(8.0),
//      shrinkWrap: true,
////    crossAxisCount: 2,
////      scrollDirection: Axis.horizontal,
//      padding: EdgeInsets.only(top: 4.0),
      children: snapshot
          .map((data) => _buildSuggestion(context, data, user))
          .toList(),
    ),
  );
}

Widget _buildSuggestion(
    BuildContext context, DocumentSnapshot data, FirebaseUser user) {
  LikedFood likedfood = LikedFood.fromSnapshot(data);
  print("_buildSuggestion" + likedfood.type);
  likedFoodTypes.add(likedfood.type);
  print("llikedFoodTypes length ${likedFoodTypes.length}");
  return Container();
}

Widget _findSuggestions(BuildContext context, FirebaseUser user) {
  return Container(
    padding: EdgeInsets.only(bottom: 3),
    height: 600,
//    height: 208,
//    width: ,
//    padding: EdgeInsets.only(right:4),

    child: ListView(
//      crossAxisCount: 3,
//      padding: EdgeInsets.all(8.0),
//      shrinkWrap: true,
////    crossAxisCount: 2,
      scrollDirection: Axis.vertical,
//      padding: EdgeInsets.only(top: 4.0),
      children: likedFoodTypes
          .map((data) => _foundSuggestions(context, data, user))
          .toList(),
    ),
  );
}

Widget _foundSuggestions(BuildContext context, String type, FirebaseUser user) {
  return StreamBuilder<QuerySnapshot>(
    stream: Firestore.instance
        .collection("food")
        .where('type', isEqualTo: '$type')
        .snapshots(),
    builder: (context, snapshot) {
      if (!snapshot.hasData) return LinearProgressIndicator();
      return Column(
        children: [
          Text(type),
          _finalSuggestions(context, snapshot.data.documents, user),
        ],
      );
    },
  );
}

Widget _finalSuggestions(
    BuildContext context, List<DocumentSnapshot> snapshot, FirebaseUser user) {
  return Container(
      height: 100,
//      width: 180,
      padding: EdgeInsets.only(right: 4),
      child: Row(
        children: [
          ListView(
//      crossAxisCount: 3,
            shrinkWrap: true,
//    crossAxisCount: 2,
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.all(4.0),
//    childAspectRatio: 8.0 / 9.0,
//    padding: const EdgeInsets.only(top: 20.0),
            children: snapshot
                .map((data) => _buildFood2(context, data, user))
                .toList(),
          ),
        ],
      ));
}

Widget _buildFood2(
    BuildContext context, DocumentSnapshot data, FirebaseUser user) {
  final food = Food.fromSnapshot(data);

  return Container(
    padding: EdgeInsets.only(right: 4),
    width: 90, height: 100,

//    width: cardWidth, height: 100,
//    clipBehavior: Clip.antiAlias,
    key: ValueKey(food.name.toString()),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Stack(
          children: <Widget>[
            GestureDetector(
              onTap: () {
                print("foodID we sent is ${food.reference.documentID}");
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => FoodDetailPage(
                      foodName: food.name,
                      user: user,
                      foodID: food.reference.documentID),
                ));
              },
              child: AspectRatio(
                aspectRatio: 1 / 1,
                child: Hero(
                  tag: 'mainImage${food.name}',
                  child: Image.network(
                    (food.image != null)
                        ? food.image
                        : 'https://images.pexels.com/photos/414612/pexels-photo-414612.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500',
                    fit: BoxFit.cover,
                    height: 150,
                  ),
                ),
              ),
            ),
            Positioned(
              right: 10.0,
              top: 70.0,
//                  child: FavoriteWidget(saved, product.id),
              child: Row(
                children: <Widget>[
//                  Text(food.name, style: Theme.of(context).textTheme.subhead,),
                ],
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
