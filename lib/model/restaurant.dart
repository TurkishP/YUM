import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Restaurant {
  final String name;
  final int price;
  final String type;
  final String image;
  final String description;
  final String creator;
  final int like;
  final int unlike;
  final int approved;
  final DateTime created_time;
  final DateTime updated_time;
  final DocumentReference reference;

  Restaurant.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['name'] != null),
//        assert(map['price'] != null),
        assert(map['type'] != null),
        assert(map['creator'] != null),
        creator = map['creator'],
        like = map['like'],
        unlike = map['like'],
        approved = map['like'],
        name = map['name'],
        price = map['price'],
        type = map['type'],
        image = map['image'],
        created_time = map['created_time'],
        updated_time = map['updated_time'],
        description = map['description'];

  Restaurant.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "Record<$name:$price>";
}