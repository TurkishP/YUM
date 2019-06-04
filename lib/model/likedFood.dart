import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LikedFood {
  final String foodID;
//  final int price;
  final String userID;
  final String name;
  final String image;
  final String type;
  final String cuisine;

  final DocumentReference reference;

  LikedFood.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['name'] != null),
        assert(map['image'] != null),


        foodID = map['foodID'],
        name = map['name'],
        type = map['type'],
        userID = map['userID'],
        cuisine = map['cuisine'],
        image = map['image'];



  LikedFood.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

//  @override
//  String toString() => "Record<$name:$foodID>";
}