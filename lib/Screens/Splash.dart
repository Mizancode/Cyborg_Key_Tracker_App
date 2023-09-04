import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
class Splash extends StatefulWidget{
  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  final googleSignIn=GoogleSignIn();
  @override
  void initState() {
    checkState();
    super.initState();
  }
  void checkState()async{
    if(await googleSignIn.isSignedIn()){
      Timer(Duration(seconds: 3),(){
        Navigator.pushReplacementNamed(context, '/home');
      });
    }else{
      Timer(Duration(seconds: 3),(){
        Navigator.pushReplacementNamed(context, '/login');
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    final mediaQuery=MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color(0xffFCFBF4),
      body: Container(
        width: mediaQuery.width,
        height: mediaQuery.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              children: [
                Stack(
                  children: [
                    Container(
                      height: 180,
                      width: 180,
                      decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(90)
                      ),
                    ),
                    Positioned(
                      left: 10,
                      top: 10,
                      bottom: 10,
                      right: 10,
                      child: Container(
                        height: 160,
                        width: 160,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(80)
                        ),
                        child: const CircleAvatar(
                          backgroundImage: AssetImage('images/cyborg.png'),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: mediaQuery.height*0.02,
            ),
            Text('Welcome To',style: TextStyle(fontSize: 30,color: Colors.black,fontWeight: FontWeight.bold),),
            Text('Cyborg Tracker',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 30,color: Colors.black),)
          ],
        ),
      ),
    );
  }
}