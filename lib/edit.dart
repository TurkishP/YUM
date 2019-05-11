import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'model/restaurant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class EditPage extends StatefulWidget {
  Restaurant restaurant;
  final FirebaseUser user;
  EditPage({Key key, this.restaurant, this.user}) : super(key: key);

  @override
  EditPageState createState() => EditPageState();
}

class EditPageState extends State<EditPage> {
  final _productName = TextEditingController();
  final _price = TextEditingController();
  final _description = TextEditingController();
  final _type = TextEditingController();
  File _image;

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
    });
  }

  String location;
  Future<void> _uploadImage() async {
    FirebaseStorage _storage = FirebaseStorage.instance;
    final StorageReference reference =
        _storage.ref().child("${DateTime.now()}");
    final StorageUploadTask task = reference.putFile(_image);

//      location = (await task.future).downloadUrl;
//      location = await reference.getDownloadURL();
    location = await (await task.onComplete).ref.getDownloadURL();
    print("image url is ");
    print(location);
  }

  Widget _restaurantDetails(BuildContext context, FirebaseUser user, String restaurantName,
      String documentID) {
    return StreamBuilder(
//      stream: Firestore.instance.collection('final').snapshots(),
      stream: Firestore.instance.collection('final').document(documentID).snapshots(),

      builder: (context, snapshot) {
//      print(snapshot.data.documents.singleWhere((document)=>document['name']==documentID));
        if (!snapshot.hasData) return LinearProgressIndicator();
//        print("restaurant name is !!" + snapshot.data['name']);
//
//        var restaurant =snapshot.data;
        return _buildrestaurantDetails(
            context, snapshot.data, user, restaurantName, documentID);
      },
    );
  }

  Widget _buildrestaurantDetails(
      BuildContext context,
      restaurant,
      FirebaseUser user,
      String restaurantName,
      String documentID) {
//    final restaurant = restaurant.fromSnapshot(
//        snapshot.singleWhere((document) => document['name'] == restaurantName));
//    widget.restaurant = restaurant;
    print("restaurant reference is  " + restaurant.reference.documentID);
    print("restaurant image is  " + restaurant['image']);


    return ListView(
      children: [
        Center(
          child: _image == null
              ? Image.network(
                  (restaurant['image'] != null)
                      ? restaurant['image']
                      : 'https://images.pexels.com/photos/414612/pexels-photo-414612.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500',
                  fit: BoxFit.fitWidth,
                  height: 150,
                )
              : Image.file(_image),
        ),
        FloatingActionButton(
          onPressed: getImage,
          tooltip: 'Pick Image',
          child: Icon(Icons.add_a_photo),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              SizedBox(width: 4),
              Container(
                width: 300,
                height: 40,
                child: TextFormField(
//                        initialValue: "${widget.restaurant.type}",
                  controller: _type,
                  decoration: InputDecoration(
                    hintText: "${restaurant['type']}",
                    hintStyle: TextStyle(color: Colors.black),
                  ),
                  style: TextStyle(color: Colors.blueAccent[50], fontSize: 30),
                ),
              ),
            ]),
            SizedBox(height: 20),
            Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              SizedBox(width: 10),
              Container(
                width: 300,
                height: 20,
                child: TextFormField(
//                      initialValue: name,

                  controller: _productName,
                  decoration: InputDecoration(
                    hintText: "${restaurant['name']}",
                    hintStyle: TextStyle(color: Colors.black),
                  ),
//                      style: TextStyle(
//                          color: Colors.blueAccent[100], fontSize: 20),
                  style: TextStyle(color: Colors.blueAccent[100], fontSize: 20),

                ),
              ),
            ]),
            SizedBox(height: 20),
            Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              SizedBox(width: 10),
              Container(
                width: 300,
                height: 20,
                child: TextFormField(
                  controller: _price,
                  decoration: InputDecoration(
                    hintText: "\$${restaurant['price']}",
                    hintStyle: TextStyle(color: Colors.black),
                  ),
//                      initialValue: "\$${widget.restaurant.price}",
                  style: TextStyle(color: Colors.blueAccent[100], fontSize: 20),
                ),
              ),
            ]),
            SizedBox(height: 20),
            Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              SizedBox(width: 10),
              Container(
                width: 300,
                height: 20,
                child: TextFormField(
                  controller: _description,
                  decoration: InputDecoration(
                    hintText: "${restaurant['description']}",
                    hintStyle: TextStyle(color: Colors.black),
                  ),
//                      initialValue: "\$${widget.restaurant.price}",
                  style: TextStyle(color: Colors.blueAccent[100], fontSize: 20),
                ),
              ),
            ]),
          ],
        ),
        SizedBox(height: 40),
        Padding(
            padding: EdgeInsets.only(
              left: 30,
              right: 30,
            ),
            child:
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
              (restaurant['updated_time'] != null)
                  ? Text(
                      "${restaurant['updated_time'].toString()} : Modified",
                      style: TextStyle(
                          color: Colors.blueAccent[50], height: 1, fontSize: 8),
                    )
                  : Text(
                      "none : Modified",
                      style: TextStyle(
                          color: Colors.blueAccent[50], height: 1, fontSize: 8),
                    ),
            ])),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
//    print(widget.restaurant.name);
//    int price = widget.restaurant.price;
//    String description = widget.restaurant.description;
//    String name = widget.restaurant.name;
//    String type = widget.restaurant.type;

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
          title: Text('Edit'),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                (_image != null)
                    ? _uploadImage().whenComplete(() => {
                          print("widget reference"),
                          print(widget.restaurant.reference.documentID),
                          Firestore.instance
                              .collection('final')
                              .document(widget.restaurant.reference.documentID)
                              .updateData({
                            "name": (_productName.text.length != 0)
                                ? _productName.text
                                : widget.restaurant.name,
                            "price": (_price.text.length != 0)
                                ? int.parse(_price.text)
                                : widget.restaurant.price,
                            "description": (_description.text.length != 0)
                                ? _description.text
                                : widget.restaurant.description,
                            "type": (_type.text.length != 0)
                                ? _type.text
                                : widget.restaurant.type,
                            "image": location.toString(),
                            "updated_time": DateTime.now(),
                          }).whenComplete(() => {

                                  }),
//                Navigator.of(context).pop(),
                        })
                    : Firestore.instance
                        .collection('final')
                        .document(widget.restaurant.reference.documentID)
                        .updateData({
                        "name": (_productName.text.length != 0)
                            ? _productName.text
                            : widget.restaurant.name,
                        "price": (_price.text.length != 0)
                            ? int.parse(_price.text)
                            : widget.restaurant.price,
                        "description": (_description.text.length != 0)
                            ? _description.text
                            : widget.restaurant.description,
                        "type": (_type.text.length != 0)
                            ? _type.text
                            : widget.restaurant.type,
                        "image": widget.restaurant.image,
                        "updated_time": DateTime.now(),
                      }).whenComplete(() => {

                            });
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        ),
        body: _restaurantDetails(context, widget.user, widget.restaurant.name,
            widget.restaurant.reference.documentID),
      ),
    );
  }
}

//                Firestore.instance.runTransaction((transaction) async {
//                final freshSnapshot = await transaction.get(widget.restaurant.reference);
//                final fresh = restaurant.fromSnapshot(freshSnapshot);
//
//                await transaction
//                    .update(widget.restaurant.reference, {
//                        "name": _productName.text,
//                        "price": int.parse(_price.text),
//                        "description": _description.text,
//                        "type": _type.text,
//                        "image": (location != null)
//                            ? location.toString()
//                            : 'https://images.pexels.com/photos/414612/pexels-photo-414612.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500',
//                        "updated_time": DateTime.now(),
//                });
//                }),

//                      Firestore.instance.collection('final').add({
////                        "name": _productName.text,
////                        "price": int.parse(_price.text),
////                        "description": _description.text,
////                        "type": _type.text,
////                        "image": (location != null)
////                            ? location.toString()
////                            : 'https://images.pexels.com/photos/414612/pexels-photo-414612.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500',
////                        "creator": widget.user.uid,
////                        "created_time": DateTime.now(),
////                        "updated_time": DateTime.now(),
////                        "like": 0,
////                      }),
////                      print("HIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII"),
//                      print(location.toString()),
