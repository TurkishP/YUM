import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DBImage {
  final int no;
//  final int price;
  final String rest_name;
  final String type;
  final String url;
  final String uploader;

  final DocumentReference reference;

  DBImage.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['rest_name'] != null),
//        assert(map['price'] != null),
        assert(map['type'] != null),
        assert(map['writer'] != null),
        no = map['no'],
        rest_name = map['rest_name'],
        type = map['type'],
        url = map['url'],
        uploader = map['uploader'];


  DBImage.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "Image<$uploader:$no>";
}