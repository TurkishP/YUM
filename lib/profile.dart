import 'package:flutter/material.dart';
import 'login.dart' as globals;
import 'package:firebase_auth/firebase_auth.dart';
import 'login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'model/user.dart';
import 'model/food.dart';

final GoogleSignIn _googleSignIn = GoogleSignIn();

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
//          Text(
//            'Hi ${globals.globalUser.displayName} !',
//            style: Theme.of(context).textTheme.title,
//          ),
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
        body: ListView(
//          margin: const EdgeInsets.only( left: 4.0, right: 4.0),
            children: [
              Column(
                  children: [        Stack(
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
                        child:                 ClipOval(
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

//Container( height:1000, width:380, child:DefaultTabController(
//  length: 3,
//  child: Scaffold(
//    appBar: AppBar(
//      bottom: TabBar(
//        tabs: [
//          Tab(icon: Icon(Icons.directions_car)),
//          Tab(icon: Icon(Icons.directions_transit)),
//          Tab(icon: Icon(Icons.directions_bike)),
//        ],
//      ),
//    ),
//    body: TabBarView(
//      children: [
//
//
//      _foodList(context,widget.user),
//
//      ],
//    ),
//  ),
//),),
                  Container(
                    padding: EdgeInsets.fromLTRB(8, 4, 0, 0),
                    child: Text(
                      "Food",
                      style: Theme.of(context).textTheme.body2,
                    ),
                  ),
                  _foodList(context,widget.user),
              ]),
            ]),
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
//        print(widget.myUser.displayName);
        Firestore.instance.runTransaction((transaction) async {

        });

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
    height: 800,
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

Widget _buildFood(
    BuildContext context, DocumentSnapshot data, FirebaseUser user) {
  final food = Food.fromSnapshot(data);

  return Container(
    padding: EdgeInsets.only(right: 3),
//    width: 140, height: 100,

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
                print("HI");
              },
              child: AspectRatio(
                aspectRatio: 1 / 1,
                child: Hero(
                  tag: '${food.name}',
                  child: Image.network(
                    (food.image != null)
                        ? food.image
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
