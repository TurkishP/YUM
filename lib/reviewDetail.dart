import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'model/restaurant.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'edit.dart';

class DetailPage extends StatefulWidget {
  Restaurant restaurant;
  final FirebaseUser user;

  DetailPage({Key key, this.restaurant, this.user}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return DetailPageState();
  }
}

class DetailPageState extends State<DetailPage> {
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
          title: Text(
            'Restaurant Detail',
          ),
          actions: <Widget>[
//            IconButton(
//              icon: Icon(
//                Icons.edit,
//                semanticLabel: 'edit',
//              ),
//              onPressed: () {
////                (widget.user.uid == widget.restaurant.creator)
////                    ? Navigator.of(context).push(MaterialPageRoute(
////                        builder: (context) =>
////                            EditPage(restaurant: widget.restaurant, user: widget.user),
////                      ))
////                    : print('you are not allowed');
//              },
//            ),
//            IconButton(
//              icon: Icon(
//                Icons.delete,
//                semanticLabel: 'delete',
//              ),
//              onPressed: () => (widget.user.uid == widget.restaurant.creator)
//                  ? Firestore.instance.runTransaction((transaction) async {
//                      await transaction
//                          .delete(widget.restaurant.reference)
//                          .whenComplete(() => Navigator.of(context).pop());
//                    })
//                  : print('you are not allowed'),
//            ),
          ],
        ),
        body: _restaurantDetails(context, widget.user, widget.restaurant.name,
            widget.restaurant.reference.documentID),
      ),
    );
  }
}

Widget _restaurantDetails(BuildContext context, FirebaseUser user,
    String restaurantName, String documentID) {
  return StreamBuilder(
    stream: Firestore.instance
        .collection('restaurant')
        .document(documentID)
        .snapshots(),
    builder: (context, snapshot) {
//      print(snapshot.data.documents.singleWhere((document)=>document['name']==documentID));
      if (!snapshot.hasData) return LinearProgressIndicator();

      return _buildrestaurantDetails(
          context, snapshot.data, user, restaurantName, documentID);
    },
  );
}

Widget _buildrestaurantDetails(BuildContext context, restaurant,
    FirebaseUser user, String restaurantName, String documentID) {
  final _comment = TextEditingController();

//  final restaurant = restaurant.fromSnapshot(
//      snapshot.singleWhere((document) => document['name'] == restaurantName));
  return ListView(
    children: [
      Stack(
        children: <Widget>[
          AspectRatio(
            aspectRatio: 18 / 11,
            child: Hero(
              tag: 'mainImage${restaurant['name']}',
              child: Image.network(
                restaurant['image'],
                fit: BoxFit.fitWidth,
                height: 150,
              ),
            ),
          ),
        ],
      ),
//            titleSection,
      Padding(
          padding: const EdgeInsets.fromLTRB(15, 14, 14, 8),
          child: Column(children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                  Row(children: [
//                    SizedBox(width: 4),
                    Text(
                      restaurant['name'],
                      style: TextStyle(color: Colors.blue[900], fontSize: 30),
                      maxLines: 1,
                    ),
                    SizedBox(
                      width: 100,
                    ),
                    _buildBody(context, user, restaurant['name'],
                        restaurant.reference.documentID),
                  ]),
                ]),
                SizedBox(height: 10),
                Row(mainAxisAlignment: MainAxisAlignment.start, children: [
//                  SizedBox(width: 10),
                  Flexible(
                      child: Text(
                    restaurant['type'].toUpperCase(),
                    style:
                        TextStyle(color: Colors.blueAccent[100], fontSize: 20),
                  )),
                ]),
                SizedBox(height: 6),
                Row(mainAxisAlignment: MainAxisAlignment.start, children: [
//                  SizedBox(width: 10),
                  Flexible(
                      child: Text(
                    "\$ ${restaurant['price']}",
                    style:
                        TextStyle(color: Colors.blueAccent[100], fontSize: 14),
                  )),
                ]),
              ],
            ),
            SizedBox(height: 10),

            Padding(
              padding: EdgeInsets.only(
//                left: 10,
                right: 10,
              ),
              child: Divider(height: 0, color: Colors.black45),
            ),
            SizedBox(
              height: 10,
            ),
//            _restaurantDetails2(context, widget.user, widget.restaurant.name,
//        widget.restaurant.reference.documentID),
            Container(
//              width: 300,
              child: Row(children: [
                Flexible(
                  child: Text(
                    restaurant['description'],
                    style:
                        TextStyle(color: Colors.blueAccent[100], height: 1.2),
                  ),
                )
              ]),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: <Widget>[
                Container(
                  width: 280,
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
                IconButton(
                    icon: Icon(
                      Icons.send,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      Firestore.instance.collection('comment').add({
                        "userID": user.uid,
                        "userImg": user.photoUrl,
                        "comment": _comment.text,
                        "restDocID": documentID,
                      });
                      _comment.clear();
                    }),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            _comments(context, documentID),
          ])),
    ],
  );
}

Widget _buildBody(BuildContext context, FirebaseUser user,
    String restaurantName, String documentID) {
  print("Document ID is $documentID");
//  print("restaurantName ID is $restaurantName");
//  print("user id is ${user.uid}");
  return StreamBuilder(
    stream: Firestore.instance
        .collection('restaurant')
        .document(documentID)
        .snapshots(),
    builder: (context, snapshot) {
//      print(snapshot.data.documents.singleWhere((document)=>document['name']==documentID));
      if (!snapshot.hasData) return LinearProgressIndicator();

      return _buildList(
          context, snapshot.data, user, restaurantName, documentID);
    },
  );
}

Widget _buildList(BuildContext context, restaurant, FirebaseUser user,
    String restaurantName, String documentID) {
  SnackBar snackBar;

  var dataExists;

  Firestore.instance.runTransaction((transaction) async {
    Firestore.instance
        .collection("restaurant")
        .document(documentID)
        .collection('likedUsers')
        .where('uid', isEqualTo: '${user.uid}')
        .getDocuments()
        .then((data) {
      if (data.documents.first.data['uid'] == '${user.uid}') {
        print(data.documents.first.data['uid']);
        dataExists = true;
        print(dataExists);
      } else {
        dataExists = null;
        print(dataExists);
      }
    });
  });

  return Row(
//    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      SizedBox(
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
                      print("Liked + 1");
                      final freshSnapshot = await transaction.get(restaurant.reference);
                      final fresh = Restaurant.fromSnapshot(freshSnapshot);
                      await transaction.update(
                          restaurant.reference, {'like': fresh.like + 1});
                      await transaction.set(
                          restaurant.reference
                              .collection('likedUsers')
                              .document('${user.uid}'),
                          {'uid': '${user.uid}'});
//                     Scaffold.of(context).showSnackBar(snackBar);
                    })
                  : print("User exists");

              Scaffold.of(context).showSnackBar(SnackBar(
                  content: (dataExists == null)
                      ? Text('I Like it!')
                      : Text('You can only do it once!!'),
                  action: SnackBarAction(
                    label: 'Undo',
                    onPressed: () {
                      // Some code to undo the change!
                      Firestore.instance.runTransaction((transaction) async {
                        final freshSnapshot =
                            await transaction.get(restaurant.reference);
                        final fresh = restaurant.fromSnapshot(freshSnapshot);
                        await transaction.update(
                            restaurant.reference, {'like': fresh.like - 1});
                        await transaction
                            .delete(
                              restaurant.reference
                                  .collection('likedUsers')
                                  .document('${user.uid}'),
                            )
                            .whenComplete(
                                () => {dataExists = null, print(dataExists)});
                      });
                      print("Liked - 1");
                    },
                  )));
            }),
      ),
      Text(
        restaurant['like'].toString(),
        style: TextStyle(color: Colors.red, fontSize: 20),
      ),
    ],
  );
}

Widget _comments(BuildContext context, String restDocID) {
  return StreamBuilder<QuerySnapshot>(
    stream: Firestore.instance.collection('comment').snapshots(),
    builder: (context, snapshot) {
      if (!snapshot.hasData) return LinearProgressIndicator();

      return _buildComments(context, snapshot.data.documents, restDocID);
    },
  );
}

Widget _buildComments(BuildContext context, List<DocumentSnapshot> snapshot, String restDocID) {
  return Container(
//    padding: EdgeInsets.only(bottom: 3),
//    height: 600,
    height: 400,
    width: 350,
    padding: EdgeInsets.only(right: 4),

    child: ListView(
//    crossAxisCount: 2,
//      padding: EdgeInsets.all(8.0),
      shrinkWrap: true,
//    crossAxisCount: 2,
//      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.all(8.0),
      children: snapshot.map((data) => _buildComment(context, data, restDocID)).toList(),
    ),
  );
}

Widget _buildComment(BuildContext context, DocumentSnapshot data, String restDocID) {
  if(data['restDocID']==restDocID){
    return Container(
      padding: EdgeInsets.fromLTRB(0,4,0,4),
      width: 150,
//    height: 100,

//    width: cardWidth, height: 100,
//    clipBehavior: Clip.antiAlias,
//    key: ValueKey(food.name.toString()),
      child: Row(
        children: <Widget>[
          ClipOval(
            child: Image.network(
              data['userImg'],
              width: 35,
              height: 35,
              fit: BoxFit.fitWidth,
            ),
          ),
          SizedBox(width: 10,),
          Text(
            data['comment'],
            style: Theme.of(context).textTheme.subhead,
          ),
        ],
      ),
    );
  }else{
    return Container();
  }

}
