import 'package:cyborg_key_15_aug_2023/Utils/Toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_button/sign_in_button.dart';
class LoginIn extends StatelessWidget{
  final auth=FirebaseAuth.instance;
  final googleSignIn=GoogleSignIn();
  LoginIn({super.key});
  @override
  Widget build(BuildContext context) {
    void google()async{
    GoogleSignInAccount? googleSignInAccount=await googleSignIn.signIn();
    GoogleSignInAuthentication googleSignInAuthentication=await googleSignInAccount!.authentication;
    final credential=GoogleAuthProvider.credential(
      idToken: googleSignInAuthentication.idToken,
      accessToken: googleSignInAuthentication.accessToken
    );
    auth.signInWithCredential(credential).then((value){
      Toast.toastMessage('Successfully Sign In ${value.user!.displayName}');
      Navigator.pushReplacementNamed(context, '/home');
    }).catchError((e){
      Toast.toastMessage(e.toString());
    });
    }
    final mediaQuery=MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color(0xffFCFBF4),
      body: SizedBox(
        height: mediaQuery.height,
        width: mediaQuery.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
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
            SizedBox(height: mediaQuery.height*0.06,),
            SizedBox(
              height: 40,
              child: Center(
                  child: SignInButton(
                    Buttons.google,
                    text: "Sign up with Google",
                    onPressed: () {
                      google();
                    },
                  )
              ),
            ),
          ],
        ),
      ),
    );
  }
}