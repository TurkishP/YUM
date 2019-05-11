import 'package:flutter/material.dart';
import 'login.dart' as globals;
import 'home.dart';
import 'profile.dart';
import 'search.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'addDish.dart';
import 'addRestaurant.dart';

//import 'model/product.dart';

class PageViewPage extends StatefulWidget {
  FirebaseUser user;

  PageViewPage({Key key, this.user}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return PageViewPageState();
  }

}

class PageViewPageState extends State<PageViewPage> {
  @override
  Widget build(BuildContext context) {
    // TODO: Return an AsymmetricView (104)
    // TODO: Pass Category variable to AsymmetricView (104)

    return pageView;
  }

  static var controller  = PageController(
      initialPage: 2
  );
  Widget pageView = PageView(
    controller: controller,
    children:[
      ProfilePage(user:globals.globalUser),
      HomePage(),
      SearchPage(),
    ],
  );
}
