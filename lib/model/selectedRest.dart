import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SelectedRest {
  final String comment;
  final String likedFoodDocID;
  final String foodID;
  final double rating;
  final String restID;
  final String restImg;
  final String restName;
  final String userID;
  final String userImg;

  final DocumentReference reference;

  SelectedRest.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['restID'] != null),
        assert(map['foodID'] != null),
        assert(map['userID'] != null),
        comment = map['comment'],
        likedFoodDocID = map['likedFoodDocID'],
        foodID = map['foodID'],
        rating = map['rating'],
        restID = map['restID'],
        restImg = map['restImg'],
        restName = map['restName'],
        userID = map['userID'],
        userImg = map['userImg'];

  SelectedRest.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "Record<$restName:$rating>";
}