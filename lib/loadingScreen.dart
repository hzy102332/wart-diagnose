import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutterproject/mainpage.dart';


class loadingScreen extends StatefulWidget {
  @override
  _loadingScreenState createState() => _loadingScreenState();
}

class _loadingScreenState extends State<loadingScreen> {
  
  @override
  void initState() {
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FlatButton(onPressed: (){
              sleep(Duration(milliseconds: 1000));
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context)=> mainpage()
                  ));
            },
                child: Text('loadind'),
            ),
            SpinKitPumpingHeart(
              color: Colors.pink,
              size: 20,
            ),
            SpinKitPumpingHeart(
              color: Colors.pink,
              size: 17,
            ),
            SpinKitPumpingHeart(
              color: Colors.pink,
              size: 14,
            ),
          ],
        ),
      ),
    );
  }
}
