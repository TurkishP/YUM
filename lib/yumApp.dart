// Copyright 2018-present the Flutter authors. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'package:flutter/material.dart';
import 'login.dart';
import 'home.dart';
import 'profile.dart';
import 'pageview.dart';

class YumApp extends StatelessWidget {
//Product product = Product();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Shrine',
        theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: Colors.red,
          accentColor: Colors.cyan[600],
          bottomAppBarColor: Colors.red,
          // Define the default Font Family
          fontFamily: 'Montserrat',
          iconTheme: IconThemeData(
            color: Colors.white,

          ),
          appBarTheme: AppBarTheme(
            elevation: 2,
          ),
          bottomAppBarTheme: BottomAppBarTheme(),
          buttonTheme: ButtonThemeData(
            buttonColor: Colors.yellow[700],
          ),
          primaryIconTheme: IconThemeData(
            color: Colors.white,
          ),
          // Define the default TextTheme. Use this to specify the default
          // text styling for headlines, titles, bodies of text, and more.
          textTheme: TextTheme(
            headline: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold, color: Colors.white),
            title: TextStyle(fontSize: 20.0, fontStyle: FontStyle.normal, color: Colors.white),
            body1: TextStyle(fontSize: 13.0, fontFamily: 'Hind', color: Colors.black),
            body2: TextStyle(fontSize: 15.0, fontFamily: 'Hind', color: Colors.black),
            subhead: TextStyle(fontSize: 15.0, color: Colors.white),

          ),
        ),
        home: LoginPage(),
        initialRoute: '/login',
        onGenerateRoute: _getRoute,
        routes: {
          '/home': (context) => HomePage(),
//          '/mypage': (context) => MyPage(),



        }
    );
  }

  Route<dynamic> _getRoute(RouteSettings settings) {
    if (settings.name != '/login') {
      return null;
    }

    return MaterialPageRoute<void>(
      settings: settings,
      builder: (BuildContext context) => LoginPage(),
      fullscreenDialog: true,
    );
  }
}

