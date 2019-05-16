import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Food {
  final String name;
//  final int price;
  final String cuisine;
  final String type;
  final String image;
  final String description;
  final String writer;
  final String taste;
  final int level;
  final int yum_count;
  final DateTime created_time;
  final DateTime modified_time;
  final DocumentReference reference;

  Food.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['name'] != null),
        assert(map['description'] != null),
        assert(map['type'] != null),
        assert(map['writer'] != null),
        assert(map['image'] != null),
        assert(map['yum_count'] != null),

        writer = map['writer'],
        name = map['name'],
//        price = map['price'],
        cuisine = map['cuisine'],
        image = map['image'],
        created_time = map['created_time'],
        modified_time = map['modified_time'],
        description = map['description'],
        yum_count = map['yum_count'],
        taste = map['taste'],
        level = map['level'],
        type = map['type'];


  Food.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "Record<$name:$level>";
}