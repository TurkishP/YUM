import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LikedFood {
  final String foodID;
//  final int price;
  final String userID;
  final String name;
  final String image;

  final DocumentReference reference;

  LikedFood.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['name'] != null),
        assert(map['image'] != null),


        foodID = map['foodID'],
        name = map['name'],
//        price = map['price'],
        userID = map['userID'],
        image = map['image'];



  LikedFood.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "Record<$name:$foodID>";
}