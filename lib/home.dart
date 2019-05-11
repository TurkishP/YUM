import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'profile.dart';
import 'search.dart';
import 'package:flutter/material.dart';
import 'addRestaurant.dart';
import 'model/restaurant.dart';
import 'detail.dart';
import 'add.dart';

FirebaseUser global;
class HomePage extends StatefulWidget {
  // TODO: Add a variable for Category (104)
//  final FirebaseStorage storage = FirebaseStorage(
//      app: Firestore.instance.app,
//      storageBucket: 'gs://db-connect-af808.appspot.com');
  FirebaseUser user;
//  List<DropdownMenurestaurant<String>> _dropDownMenurestaurants;
  String category = "ALL";
  String searchType = "ASC";

  HomePage({Key key, this.user}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return HomePageState(

    );

  }
}


class HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    // TODO: Return an AsymmetricView (104)
    // TODO: Pass Category variable to AsymmetricView (104)

    return Scaffold(
        appBar: AppBar(

          centerTitle: true,
          leading: IconButton(
            icon: Icon(
              Icons.notifications,
              semanticLabel: 'mypage',
            ),
            onPressed: () {
//              Navigator.of(context).push(MaterialPageRoute(
//                builder: (context) => ProfilePage(user: widget.user),
//              )
//              );
            },
          ),
          title: Text('YUM', style: Theme.of(context).textTheme.title,),
          actions: <Widget>[

          ],
        ),
        body: ListView(
//          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(height: 500),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
//                  Text("hi")
              ],
            ),
            Container(
                height: 508,
                child: _buildBody(context, widget.user)),
          ],
        ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 4.0,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(icon: Icon(Icons.new_releases ), onPressed: () {},),
            IconButton(icon: Icon(Icons.star_border), onPressed: () {},),
            IconButton(icon: Icon(Icons.add,), onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => AddPage(),
                ));
              },
            ),
            IconButton(icon: Icon(Icons.comment), onPressed: () {},),
            IconButton(icon: Icon(Icons.person), onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ProfilePage(user: widget.user),
              ));
            },),
          ],
        ),
      ),

    );

  }
}


Widget _buildBody(BuildContext context, FirebaseUser user) {
  return StreamBuilder<QuerySnapshot>(
    stream: Firestore.instance
        .collection('restaurant')
        .snapshots(),

    builder: (context, snapshot) {
      if (!snapshot.hasData) return LinearProgressIndicator();

      return _buildList(context, snapshot.data.documents, user);
    },
  );
}

Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot, FirebaseUser user) {
  return GridView.count(
    crossAxisCount: 2,
    padding: EdgeInsets.all(16.0),
    childAspectRatio: 8.0 / 9.0,
//    padding: const EdgeInsets.only(top: 20.0),
    children: snapshot.map((data) => _buildListRestaurant(context, data, user)).toList(),
  );
}

Widget _buildListRestaurant(BuildContext context, DocumentSnapshot data, FirebaseUser user) {
  final restaurant = Restaurant.fromSnapshot(data);

  return Card(
    clipBehavior: Clip.antiAlias,
    key: ValueKey(restaurant.name.toString()),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        AspectRatio(
          aspectRatio: 18 / 11,
          child: Hero(
            tag: 'mainImage${restaurant.name}',
            child: Image.network(
              (restaurant.image != null) ? restaurant.image:
              'https://images.pexels.com/photos/414612/pexels-photo-414612.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500',
              fit: BoxFit.fitWidth,
              height: 150,
            ),
          ),
        ),
        Row(
          children: <Widget>[
            Text(restaurant.name),
          ],
        ),
        Row(
          children: <Widget>[
            Column(
              children: <Widget>[
                Text("\$${restaurant.price}"),
              ],
            ),
          ],
        ),
        Row(
            children: [FlatButton(
              child: const Text(
                'more',
                style: TextStyle(fontSize: 9),
              ),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => DetailPage(restaurant: restaurant, user: user),
                ));
              },
            ),]
        ),
      ],
    ),
  );
}
