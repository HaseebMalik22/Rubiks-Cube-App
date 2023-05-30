import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rubikscube/Homepage.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key? key}) : super(key : key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>{

  @override
  void initState(){

    super.initState();
    Timer(Duration(seconds: 3), ()=>Navigator.pushReplacement(context as BuildContext, MaterialPageRoute(builder: (context)=>Home())));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFFF800B),
              Color(0xFFF3BF17),
            ],

          )
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
          Column(

            children: [
              Image.asset(
                'assets/images/rubiks-logo.png',
                height: 300.0,width: 300.0,
              ),
              Text("Rubik's Cube App\n for managing Results",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 21.0,

                ),
              ),
            ],
          ),

          CircularProgressIndicator(color: Colors.white),
         ],
        ),
      ),
    );
  }
}

