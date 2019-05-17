import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CustomUser {
  final String displayName;
  final String image;
  final String coverImg;
  final int eatenFoodCount;
  final String uid;
  final String description;
  final int age;
  final int level;
  final DateTime created_time;
  final DocumentReference reference;

  CustomUser.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['uid'] != null),

        displayName = map['displayName'],
        description = map['description'],
        uid = map['uid'],
        age = map['age'],
        image = map['image'],
        created_time = map['created_time'],
        coverImg = map['coverImg'],
        eatenFoodCount = map['eatenFoodCount'],
        level = map['level'];


  CustomUser.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "Record<$displayName:$level>";
}