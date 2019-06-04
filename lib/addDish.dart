import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:async';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'home.dart';
import 'model/user.dart';
String userDocID = "";

class AddDishPage extends StatefulWidget {
  final FirebaseUser user;
  CustomUser myUser;
  AddDishPage({Key key, this.user}) : super(key: key);

  @override
  AddDishPageState createState() => AddDishPageState();
}

class AddDishPageState extends State<AddDishPage> {
  final _taste = TextEditingController();
  final _name = TextEditingController();
  final _description = TextEditingController();
  final _type = TextEditingController();
  final _level = TextEditingController();
  final _cuisine = TextEditingController();

  File _image;

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery , maxWidth: 500);

    setState(() {
      _image = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    String location;
    Future<void> _uploadImage() async {
      FirebaseStorage _storage = FirebaseStorage.instance;
      final StorageReference reference =
          _storage.ref().child("${DateTime.now()}");
      final StorageUploadTask task = reference.putFile(_image);

//      location = (await task.future).downloadUrl;
//      location = await reference.getDownloadURL();
      location = await (await task.onComplete).ref.getDownloadURL();
    }

    print(widget.user.uid);

    return ListView(
      padding: EdgeInsets.fromLTRB(40, 0, 40, 0.0),
      children: [
        Column(
//          margin: const EdgeInsets.only(top: 50, left: 30.0, right: 30.0),
            children: [
              _getUser(context, widget.user),
              SizedBox(height: 20),
              SizedBox(
                height: 200,
                child: Center(
                  child: _image == null
                      ? Icon(
                          Icons.image,
                          size: 60,
                        )
                      : Image.file(_image),
                ),
              ),
              _image == null
                  ? FloatingActionButton(
                      onPressed: getImage,
                      tooltip: 'Pick Image',
                      child: Icon(Icons.add_a_photo),
                    )
                  : Container(),
              SizedBox(height: 10.0),
              TextFormField(
                controller: _cuisine,
                decoration: InputDecoration(
//                  filled: true,
                  labelText: 'Country of Origin',
                ),
//                    validator: (value) {
//                      if (value.isEmpty) {
//                        return 'Please enter a product name';
//                      } else {}
//                    },
              ),
              SizedBox(height: 10.0),
              TextFormField(
                controller: _name,
                decoration: InputDecoration(
//                  filled: true,
                  labelText: 'Name',
                ),
//                    validator: (value) {
//                      if (value.isEmpty) {
//                        return 'Please enter a price';
//                      } else {}
//                    },
              ),
              SizedBox(height: 10.0),
              TextFormField(
                controller: _description,
                decoration: InputDecoration(
//                  filled: true,
                  labelText: 'Description',
                ),
//                    validator: (value) {
//                      if (value.isEmpty) {
//                        return '';
//                      } else {}
//                    },
              ),
              SizedBox(height: 10.0),
              TextFormField(
                controller: _level,
                decoration: InputDecoration(
//                  filled: true,
                  labelText: 'Level',
                ),
              ),
              SizedBox(height: 10.0),
              TextFormField(
                controller: _taste,
                decoration: InputDecoration(
//                  filled: true,
                  labelText: 'Significant Taste',
                ),
              ),
              SizedBox(height: 10.0),
              TextFormField(
                controller: _type,
                decoration: InputDecoration(
//                  filled: true,
                  labelText: 'Type',
                ),
              ),
              IconButton(
                icon: const Icon(Icons.check),
                iconSize: 40,
                color: Colors.red,
                onPressed: () {
                  _uploadImage().whenComplete(() => {
                        Firestore.instance.collection('food').add({
                          "cuisine": _cuisine.text,
                          "description": _description.text,
                          "image": location.toString(),
                          "level": int.parse(_level.text),
                          "type": _type.text,
                          "taste": _taste.text,
                          "name": _name.text,
                          "writer": widget.user.displayName,
                          "yum_count": 0,
                        }),
//                        Navigator.of(context).push(new MaterialPageRoute(
//                          builder: (context) => HomePage(user: widget.user),
//                        )),
                  _name.clear(),
                  _taste.clear(),
                  _description.clear(),
                  _type.clear(),
                  _cuisine.clear(),
                  setState(() {
                    _image = null;
                  }),
                  widget.myUser.reference.updateData({'visitedRestCnt': widget.myUser.visitedRestCnt+1}),
                  widget.myUser.reference.updateData({'yumPoint': widget.myUser.yumPoint+1}),
                      });
                },
              ),
            ])
      ],
    );
//      ),
//    );
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
