import 'package:flutter/material.dart';
import 'login.dart' as globals;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:async';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'addRestaurant.dart';
import 'addDish.dart';

class AddPage extends StatefulWidget {

  AddPage({Key key,}) : super(key: key);

  @override
  AddPageState createState() => AddPageState();
}

class AddPageState extends State<AddPage> {


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 3, child: Scaffold(
        appBar: PreferredSize(child: AppBar(
          bottom: TabBar(

            tabs: [
              Tab(text: "Restaurant"),
              Tab(text: "Dish"),

            ],
          ),
//          PreferredSize(child: TabBar(
//            tabs: [
//              Tab(text: "Restaurant"),
//              Tab(text: "Dish"),
//
//            ],
//          ), preferredSize: Size.fromHeight(70.0),),
          backgroundColor: Theme.of(context).primaryColor,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          centerTitle: true,
          title: Text('ADD'),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
//                (_image != null)
//                    ? _uploadImage().whenComplete(() => {
//                Firestore.instance.collection('restaurant').add({
//                  "name": _productName.text,
//                  "description": _description.text,
//                  "type": _type.text,
//                  "image": location.toString(),
//                  "creator": widget.user.uid,
//                  "created_time": DateTime.now(),
//                  "updated_time": DateTime.now(),
//                  "approved": 0,
//                  "like": 0,
//                  "unlike": 0,
//                }),
//                print(location.toString()),
//                })
//                    : Firestore.instance.collection('restaurant').add({
//                  "name": _productName.text,
//                  "price": int.parse(_price.text),
//                  "description": _description.text,
//                  "type": _type.text,
//                  "image":
//                  'https://images.pexels.com/photos/414612/pexels-photo-414612.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500',
//                  "creator": widget.user.uid,
//                  "created_time": DateTime.now(),
//                  "updated_time": DateTime.now(),
//                  "approved": 0,
//                  "like": 0,
//                  "unlike": 0,
//                });

                Navigator.of(context).pop();
              },
              child: const Text('Save', style: TextStyle(color:Colors.white),),
            ),
          ],
        ), preferredSize: Size.fromHeight(90.0),),
        body: TabBarView(
          children: [
            AddRestaurantPage(user: globals.globalUser,),
            AddDishPage(user: globals.globalUser,),
//                Icon(Icons.directions_transit),

          ],
        ),
//        DefaultTabController(
//          length: 3,
//          child: Scaffold(
//            appBar: AppBar(
//              bottom: TabBar(
//                tabs: [
//                  Tab(text: "Restaurant"),
//                  Tab(text: "Dish"),
//
//                ],
//              ),
//            ),
//            body: TabBarView(
//              children: [
//                AddRestaurantPage(user: globals.globalUser,),
//                AddDishPage(user: globals.globalUser,),
////                Icon(Icons.directions_transit),
//
//              ],
//            ),
//          ),
//        ),
      ),),
    );
//    return MaterialApp(
//      home: DefaultTabController(
//        length: 3,
//        child: Scaffold(
//          appBar: AppBar(
//            bottom: TabBar(
//              tabs: [
//                Tab(text: "Restaurant"),
//                Tab(text: "Dish"),
//
//              ],
//            ),
//            title: Text('Tabs Demo'),
//          ),
//          body: TabBarView(
//            children: [
//              Icon(Icons.directions_car),
//              Icon(Icons.directions_transit),
//
//            ],
//          ),
//        ),
//      ),
//    );
  }
}
