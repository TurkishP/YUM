import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Review {
  final String rest_name;
//  final int price;
  final String cuisine;
  final String image;
  final String content;
  final String writer;
  final String writer_img;
  final String rest_id;
  //  final String taste;
  final double star;
  final int view;
  final DateTime created_time;
  final DateTime modified_time;
  final DocumentReference reference;

  Review.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['rest_name'] != null),
//        assert(map['price'] != null),
//        assert(map['type'] != null),
        assert(map['writer'] != null),
        writer = map['writer'],
        writer_img = map['writer_img'],
        content = map['content'],
        cuisine = map['cuisine'],
        image = map['image'],
        view = map['view'],
        rest_name = map['rest_name'],
        rest_id = map['rest_id'],
//        price = map['price'],
        star = map['star'],
        created_time = map['created_time'],
        modified_time = map['modified_time'];


  Review.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "Record<$writer:$star>";
}