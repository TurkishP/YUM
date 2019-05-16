import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:async';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class AddDishPage extends StatefulWidget {
  final FirebaseUser user;

  AddDishPage({Key key, this.user}) : super(key: key);

  @override
  AddDishPageState createState() => AddDishPageState();
}

class AddDishPageState extends State<AddDishPage> {
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

    return
//        appBar: AppBar(
//          backgroundColor: Theme.of(context).primaryColor,
//          leading: IconButton(
//            icon: const Icon(Icons.arrow_back),
//            onPressed: () {
//              Navigator.of(context).pop();
//            },
//          ),
//          centerTitle: true,
//          title: Text('ADD'),
//          actions: <Widget>[
//            FlatButton(
//              onPressed: () {
//                (_image != null)
//                    ? _uploadImage().whenComplete(() => {
//                          Firestore.instance.collection('dish').add({
//                            "name": _productName.text,
//                            "description": _description.text,
//                            "type": _type.text,
//                            "image": location.toString(),
//                            "creator": widget.user.uid,
//                            "created_time": DateTime.now(),
//                            "updated_time": DateTime.now(),
//                            "approved": 0,
//                            "like": 0,
//                            "unlike": 0,
//                          }),
//                          print(location.toString()),
//                        })
//                    : Firestore.instance.collection('dish').add({
//                        "name": _productName.text,
//                        "price": int.parse(_price.text),
//                        "description": _description.text,
//                        "type": _type.text,
//                        "image":
//                            'https://images.pexels.com/photos/414612/pexels-photo-414612.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500',
//                        "creator": widget.user.uid,
//                        "created_time": DateTime.now(),
//                        "updated_time": DateTime.now(),
//                        "approved": 0,
//                        "like": 0,
//                        "unlike": 0,
//                      });
//
//                Navigator.of(context).pop();
//              },
//              child: const Text('Save', style: TextStyle(color:Colors.white),),
//            ),
//          ],
//        ),
        ListView(
          padding: EdgeInsets.fromLTRB(40, 0, 40, 0.0),
          children: [
            Column(
//          margin: const EdgeInsets.only(top: 50, left: 30.0, right: 30.0),
                children: [
                  SizedBox(height:20),
                  SizedBox(
                    height: 200,
                    child: Center(
                      child: _image == null
                          ? Icon(Icons.image, size: 60,)
                          : Image.file(_image),
                    ),
                  ),
                  _image == null ? FloatingActionButton(
                    onPressed: getImage,
                    tooltip: 'Pick Image',
                    child: Icon(Icons.add_a_photo),
                  ): Container(),
                  SizedBox(height: 10.0),
                  TextFormField(
                    controller: _productName,
                    decoration: InputDecoration(
//                  filled: true,
                      labelText: 'Product Name',
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter a product name';
                      } else {}
                    },
                  ),
                  SizedBox(height: 10.0),
                  TextFormField(
                    controller: _price,
                    decoration: InputDecoration(
//                  filled: true,
                      labelText: 'Price',
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter a price';
                      } else {}
                    },
                  ),
                  SizedBox(height: 10.0),
                  TextFormField(
                    controller: _description,
                    decoration: InputDecoration(
//                  filled: true,
                      labelText: 'Description',
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return '';
                      } else {}
                    },
                  ),
                  SizedBox(height: 10.0),
                  TextFormField(
                    controller: _type,
                    decoration: InputDecoration(
//                  filled: true,
                      labelText: 'Category',
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter a category';
                      } else {}
                    },
                  ),
                ])
          ],
        );
//      ),
//    );
  }
}
