import 'package:flutter/material.dart';
import 'login.dart' as globals;
import 'package:firebase_auth/firebase_auth.dart';
import 'login.dart';
import 'package:google_sign_in/google_sign_in.dart';


final GoogleSignIn _googleSignIn = GoogleSignIn();

class ProfilePage extends StatefulWidget {
  FirebaseUser user;

  ProfilePage({Key key, this.user}) : super(key: key);

  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    print(widget.user);

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          centerTitle: true,
          title: Text('${globals.globalUser.displayName}', style: Theme.of(context).textTheme.title,),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.exit_to_app,
                semanticLabel: 'exit',
              ),
              onPressed: () {
                _handleSignOut();
                Navigator.of(context).pop();

                Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => LoginPage(),

                    )
                );
              },
            ),
          ],
        ),

        body: Container(
          margin: const EdgeInsets.only(top: 50, left: 30.0, right: 30.0),
          child:Column(
            children:[

ClipOval(
                  child: Image.network(
                    (widget.user.photoUrl != null) ? widget.user.photoUrl : 'https://images.pexels.com/photos/414612/pexels-photo-414612.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500',    width: 100,
                    height: 100,    fit: BoxFit.cover,
                  ),
                ),

//              Container(
//                height: 200,
//                width: 200,
//                decoration: BoxDecoration(
//                  color: Colors.yellow,
//
//                  border: Border.all(color: Colors.black, width: 3),
//                    borderRadius: BorderRadius.all(Radius.circular(18)),
//                ),
//                child: Image.network(
//                    (widget.user.photoUrl != null) ? widget.user.photoUrl : 'https://images.pexels.com/photos/414612/pexels-photo-414612.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500',
//                  ),
//              ),



              SizedBox(height: 60.0),
              Text(
                "UID: ${widget.user.uid}",

              ),
              SizedBox(height: 10.0),
              Text(
                (widget.user.email != null) ? "Email: ${widget.user.email}" : 'Email: anonymous',

              ),
//              SizedBox(height: 10.0),
//              Text(
//                products[productId].location,
//                style:
//                TextStyle(color: Colors.blueAccent[100], fontSize: 14),
//              )


            ]

          ),

        ),
      ),
    );
  }

  Future<void> _handleSignOut() async {
    _googleSignIn.disconnect();
  }

}

