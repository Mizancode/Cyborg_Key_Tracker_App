import 'package:cyborg_key_15_aug_2023/Screens/Home.dart';
import 'package:cyborg_key_15_aug_2023/Screens/Login%20In.dart';
import 'package:cyborg_key_15_aug_2023/Screens/Splash.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
void main()async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyMain());
}
class MyMain extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Splash(),
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold
          )
        )
      ),
      routes: {
        '/home':(context)=>Home(),
        '/login':(context)=>LoginIn(),
        '/splash':(context)=>Splash()
      },
    );
  }
}