import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'profile.dart';
import 'search.dart';
import 'package:flutter/material.dart';
import 'addRestaurant.dart';
import 'model/restaurant.dart';
import 'model/image.dart';
import 'model/food.dart';
import 'model/review.dart';
import 'foodDeatil.dart';
import 'detail.dart';
import 'add.dart';

FirebaseUser global;
final cardHeight = 195.0;
final cardWidth = 140.0;

class HomePage extends StatefulWidget {
  // TODO: Add a variable for Category (104)
//  final FirebaseStorage storage = FirebaseStorage(
//      app: Firestore.instance.app,
//      storageBucket: 'gs://db-connect-af808.appspot.com');
  FirebaseUser user;
//  List<DropdownMenurestaurant<String>> _dropDownMenurestaurants;
  String category = "ALL";
  String searchType = "ASC";

  CollectionReference foodCount = Firestore.instance.collection('food');

  HomePage({Key key, this.user}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.notifications,
            semanticLabel: 'mypage',
          ),
          onPressed: () {},
        ),
        title: Text(
          'YUM',
          style: Theme.of(context).textTheme.title,
        ),
        actions: <Widget>[],
      ),
//        body:CustomScrollView(
//          slivers: <Widget>[
//            const SliverAppBar(
//              pinned: true,
//              expandedHeight: 100.0,
//              flexibleSpace: FlexibleSpaceBar(
//                title: Text('Demo'),
//              ),
//            ),
//            SliverGrid(
//              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//            crossAxisCount: 2,
//              ),
//              delegate: SliverChildBuilderDelegate(
//
//
//                    (BuildContext context, int index) {
//                  return Container(
//                    alignment: Alignment.center,
////                    color: Colors.teal[100 * (index % 9)],
//                    child: Text('grid item $index'),
//                  );
//                },
//                childCount: 20,
//              ),
//            ),
//
//          ],
//        ),
      body: Container(
        child: Center(
          child: ListView(
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(8, 8, 0, 0),
                child: Text(
                  "Retaurants",
                  style: Theme.of(context).textTheme.body2,
                ),
              ),
              _restaurantList(context, widget.user),
              Container(
                padding: EdgeInsets.fromLTRB(8, 4, 0, 0),
                child: Text(
                  "Reviews",
                  style: Theme.of(context).textTheme.body2,
                ),
              ),
              _reviewList(context, widget.user),
              Container(
                padding: EdgeInsets.fromLTRB(8, 4, 0, 0),
                child: Text(
                  "Foods",
                  style: Theme.of(context).textTheme.body2,
                ),
              ),
              _foodList(context, widget.user),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 4.0,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.new_releases),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.star_border),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(
                Icons.add,
              ),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => AddPage(),
                ));
              },
            ),
            IconButton(
              icon: Icon(Icons.comment),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.person),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ProfilePage(user: widget.user),
                ));
              },
            ),
          ],
        ),
      ),
    );
  }
}

Widget _reviewList(BuildContext context, FirebaseUser user) {
  return StreamBuilder<QuerySnapshot>(
    stream: Firestore.instance.collection('review').snapshots(),
    builder: (context, snapshot) {
      if (!snapshot.hasData) return CircularProgressIndicator();

      return _buildReviewList(context, snapshot.data.documents, user);
    },
  );
}

Widget _buildReviewList(
    BuildContext context, List<DocumentSnapshot> snapshot, FirebaseUser user) {
  return Container(
    height: cardHeight + 21,
    width: 200,
    child: ListView(
      shrinkWrap: true,
//    crossAxisCount: 2,
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.all(8.0),
//    childAspectRatio: 8.0 / 9.0,
//    padding: const EdgeInsets.only(top: 20.0),
      children:
          snapshot.map((data) => _buildReview(context, data, user)).toList(),
    ),
  );
}

Widget _buildReview(
    BuildContext context, DocumentSnapshot data, FirebaseUser user) {
  final review = Review.fromSnapshot(data);

  return Container(
    margin: EdgeInsets.only(right: 3),
    padding: EdgeInsets.only(right: 4),

//    clipBehavior: Clip.antiAlias,
    height: 200, width: cardWidth,
    key: ValueKey(review.writer.toString()),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        AspectRatio(
          aspectRatio: 18 / 16,
          child: Hero(
            tag: 'mainImage${review.image}',
            child: Image.network(
              (review.image != null)
                  ? review.image
                  : 'https://images.pexels.com/photos/414612/pexels-photo-414612.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500',
              fit: BoxFit.cover,
              height: 150,
            ),
          ),
        ),
        SizedBox(height: 3),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(review.rest_name),
            SizedBox(
              height: 20,
              width: 40,
              child: RaisedButton(
                padding: EdgeInsets.all(0),
                child: const Text(
                  'more',
                  style: TextStyle(fontSize: 9),
                ),
                onPressed: () {
//              Navigator.of(context).push(MaterialPageRoute(
//                builder: (context) =>
//                    DetailPage(restaurant: restaurant, user: user),
//              ));
                },
              ),
            )
          ],
        ),
        SizedBox(height: 3),
        Row(
          children: <Widget>[],
        ),
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

          Column(
            children: <Widget>[
              Text("${review.writer}"),
            ],
          ),

        ]),
      ],
    ),
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
  return Container(
    height: cardHeight + 13,
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
          .map((data) => _buildRestaurant(context, data, user))
          .toList(),
    ),
  );
}

Widget _buildRestaurant(
    BuildContext context, DocumentSnapshot data, FirebaseUser user) {
  final restaurant = Restaurant.fromSnapshot(data);

  return Container(
    margin: EdgeInsets.only(right: 3),
    width: cardWidth,
    height: 100,
    padding: EdgeInsets.only(right: 4),
    key: ValueKey(restaurant.name.toString()),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        GestureDetector(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) =>
                  DetailPage(restaurant: restaurant, user: user),
            ));
          },
          child: AspectRatio(
            aspectRatio: 18 / 17,
            child: Hero(
              tag: '${restaurant.name}',
              child: Image.network(
                (restaurant.image != null)
                    ? restaurant.image
                    : 'https://images.pexels.com/photos/414612/pexels-photo-414612.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500',
                fit: BoxFit.cover,
                height: 150,
              ),
            ),
          ),
        ),
        SizedBox(
          height: 4,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Text(restaurant.name),
          ],
        ),
        SizedBox(
          height: 3,
        ),
        Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          SizedBox(
            height: 18,
            width: 36,
            child: RaisedButton(
              padding: EdgeInsets.all(0),
              child: const Text(
                'more',
                style: TextStyle(fontSize: 9),
              ),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      DetailPage(restaurant: restaurant, user: user),
                ));
              },
            ),
          )
        ]),
      ],
    ),
  );
}

Widget _foodList(BuildContext context, FirebaseUser user) {
  return StreamBuilder<QuerySnapshot>(
    stream: Firestore.instance.collection('food').snapshots(),
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
//    height: 600,
    height: cardHeight + 13,
    width: 200,
    padding: EdgeInsets.only(right: 4),

    child: ListView(
//    crossAxisCount: 2,
//      padding: EdgeInsets.all(8.0),
      shrinkWrap: true,
//    crossAxisCount: 2,
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.all(8.0),
      children:
          snapshot.map((data) => _buildFood(context, data, user)).toList(),
    ),
  );
}

Widget _buildFood(
    BuildContext context, DocumentSnapshot data, FirebaseUser user) {
  final food = Food.fromSnapshot(data);

  return Container(
    padding: EdgeInsets.only(right: 4),
    width: cardWidth, height: 100,

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
                  builder: (context) => FoodDetailPage(foodName: food.name, user: user, foodID: food.reference.documentID),
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
