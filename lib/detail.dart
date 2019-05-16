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
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          centerTitle: true,
          title: Text('Detail'),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.edit,
                semanticLabel: 'edit',
              ),
              onPressed: () {
//                (widget.user.uid == widget.restaurant.creator)
//                    ? Navigator.of(context).push(MaterialPageRoute(
//                        builder: (context) =>
//                            EditPage(restaurant: widget.restaurant, user: widget.user),
//                      ))
//                    : print('you are not allowed');
              },
            ),
            IconButton(
              icon: Icon(
                Icons.delete,
                semanticLabel: 'delete',
              ),
              onPressed: () => (widget.user.uid == widget.restaurant.creator)
                  ? Firestore.instance.runTransaction((transaction) async {
                      await transaction
                          .delete(widget.restaurant.reference)
                          .whenComplete(() => Navigator.of(context).pop());
                    })
                  : print('you are not allowed'),
            ),
          ],
        ),
        body: _restaurantDetails(context, widget.user, widget.restaurant.name,
            widget.restaurant.reference.documentID),
      ),
    );
  }
}

Widget _restaurantDetails(BuildContext context, FirebaseUser user, String restaurantName,
    String documentID) {
  return StreamBuilder(
    stream: Firestore.instance.collection('restaurant').document(documentID).snapshots(),
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
          padding: const EdgeInsets.all(8.0),
          child: Column(children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                  Row(children: [
                    SizedBox(width: 4),
                    Text(
                      restaurant['type'],
                      style: TextStyle(color: Colors.blue[900], fontSize: 30),
                      maxLines: 1,
                    ),
                  ]),
                ]),
                SizedBox(height: 10),
                Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                  SizedBox(width: 10),
                  Flexible(
                      child: Text(
                        restaurant['name'],
                    style:
                        TextStyle(color: Colors.blueAccent[100], fontSize: 20),
                  )),
                ]),
                SizedBox(height: 6),
                Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                  SizedBox(width: 10),
                  Flexible(
                      child: Text(
                    "\$${restaurant['price']}",
                    style:
                        TextStyle(color: Colors.blueAccent[100], fontSize: 14),
                  )),
                ]),
              ],
            ),
            _buildBody(context, user, restaurant['name'], restaurant.reference.documentID),
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
//            _restaurantDetails2(context, widget.user, widget.restaurant.name,
//        widget.restaurant.reference.documentID),
            Container( width: 300,child:            Row( children:[         Flexible(child:

            Text(
              restaurant['description'],
              style: TextStyle(color: Colors.blueAccent[100], height: 1.2),
            ),
            )]),),


            SizedBox(
              height: 80,
            ),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                "${restaurant['creator']} : Creator",
                style: TextStyle(
                    color: Colors.blueAccent[50], height: 1, fontSize: 8),
              ),
              ( restaurant['created_time'] != null)
                  ? Text(
                "${restaurant['created_time'].toString()} : Created",
                style: TextStyle(
                    color: Colors.blueAccent[50], height: 1, fontSize: 8),
              )
                  : Text(
                "none : Created",
                style: TextStyle(
                    color: Colors.blueAccent[50], height: 1, fontSize: 8),
              ),
              (restaurant['modified_time'] != null)
                  ? Text(
                "${restaurant['modified_time'].toString()} : Modified",
                style: TextStyle(
                    color: Colors.blueAccent[50], height: 1, fontSize: 8),
              )
                  : Text(
                "none : Modified",
                style: TextStyle(
                    color: Colors.blueAccent[50], height: 1, fontSize: 8),
              ),
            ])
          ])),
    ],
  );
}

//Widget _restaurantDetails2(BuildContext context, FirebaseUser user, String restaurantName,
//    String documentID) {
//
//  return StreamBuilder<QuerySnapshot>(
//    stream: Firestore.instance.collection('final').snapshots(),
//    builder: (context, snapshot) {
////      print(snapshot.data.documents.singleWhere((document)=>document['name']==documentID));
//      if (!snapshot.hasData) return LinearProgressIndicator();
//
//      return _buildrestaurantDetails2(
//          context, snapshot.data.documents, user, restaurantName, documentID);
//    },
//  );
//}
//
//Widget _buildrestaurantDetails2(BuildContext context, List<DocumentSnapshot> snapshot,
//    FirebaseUser user, String restaurantName, String documentID) {
//  final restaurant = restaurant.fromSnapshot(
//      snapshot.singleWhere((document) => document['name'] == restaurantName));
//  return             Container(
//    padding: EdgeInsets.only(
//      left: 30,
//      right: 30,
//      bottom: 60,
//    ),
//    child: Text(
//      restaurant.description,
//      style: TextStyle(color: Colors.blueAccent[100], height: 1.2),
//    ),
//  );
//}

Widget _buildBody(BuildContext context, FirebaseUser user, String restaurantName,
    String documentID) {
  print("Document ID is $documentID");
  print("restaurantName ID is $restaurantName");
  print("user id is ${user.uid}");
  return StreamBuilder(
    stream: Firestore.instance.collection('restaurant').document(documentID).snapshots(),
    builder: (context, snapshot) {
//      print(snapshot.data.documents.singleWhere((document)=>document['name']==documentID));
      if (!snapshot.hasData) return LinearProgressIndicator();

      return _buildList(
          context, snapshot.data, user, restaurantName, documentID);
    },
  );
}

Widget _buildList(BuildContext context, restaurant,
    FirebaseUser user, String restaurantName, String documentID) {
  SnackBar snackBar;

  var dataExists = null;

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
                      final freshSnapshot =
                          await transaction.get(restaurant.reference);
                      final fresh = restaurant.fromSnapshot(freshSnapshot);
                      await transaction
                          .update(restaurant.reference, {'like': fresh.like + 1});
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
                        await transaction
                            .update(restaurant.reference, {'like': fresh.like - 1});
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

//  Firestore.instance.runTransaction((transaction) async {
//    final freshSnapshot = await transaction.get(restaurant.reference.collection('likedUsers').document(user.uid));
//    final fresh = restaurant.fromSnapshot(freshSnapshot);
//    await transaction.get(restaurant.reference.collection('likedUsers').document(user.uid)).then((data){
//      print("HIIIIIIIIIIII");
//      print(data.documentID);
//    });
//
//  });
//  DocumentReference documentReference =
//  Firestore.instance.collection("final").document(restaurantName).collection('likedUsers').document('${user.uid}');
//  documentReference.get().then((datasnapshot){
//    print("HIIIIIIIIIIII");
//    print(datasnapshot.data['status'].toString());
//  });
//  documentReference.get().then((datasnapshot){
//
//  }
//  documentReference.get().then((datasnapshot) {
//    if (datasnapshot.exists) {
//      print(datasnapshot.data['${user.uid}'].toString());
//      dataExists = datasnapshot.data['${user.uid}'].toString();
//    }
//  });
//  var snapshot2 = snapshot.singleWhere((document)=>document['name']==documentID).reference.collection('likedUsers').snapshots();
//  var singleSnap = snapshot.
//      final restaurant2 = restaurant.fromSnapshot(snapshot2.singleWhere((document)=>document['${user.uid}']=='liked'));

//
//    DocumentReference doc = Firestore.instance.collection("final").document(documentID).collection('likedUsers').document('${user.uid}');
//
//    await transaction.get(doc).then((data){
//    if (data.documentID.length!=0) {
//      print("Data's documentID is "+data.documentID);
//
//      dataExists = true;
//      print(dataExists);
//    }
//    else{
//      dataExists = null;
//      print("No such user");
//    }
//    });
//Row(
//                  mainAxisSize: MainAxisSize.min,
//                  children: <Widget>[
////                    SizedBox(
////                      height: 35.0,
////                      width: 35.0,
////                      child: IconButton(
////
////                        icon: Icon(
////                          Icons.thumb_up,
//////                    size: 20,
////                        ),
////                        onPressed: (){
////                          setState((){Firestore.instance.runTransaction((transaction) async {
////                          final freshSnapshot = await transaction.get(widget.restaurant.reference);
////                          final fresh = restaurant.fromSnapshot(freshSnapshot);
////                          await transaction
////                              .update(widget.restaurant.reference, {'like': fresh.like + 1});
////                          await transaction.set(
////                              widget.restaurant.reference
////                                  .collection('likedUsers')
////                                  .document('${widget.user.uid}'),
////                              {'widget.user.uid': 'liked'});
////
////                        });});
////                        }
////                      ),
////                    ),
////                    Text(
////                      widget.restaurant.like.toString(),
////                      style: TextStyle(color: Colors.red, fontSize: 20),
////                    ),
//                  ],
//                ),
