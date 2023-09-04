// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cyborg_key_15_aug_2023/Utils/Toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
class Home extends StatefulWidget{
  @override
  State<Home> createState() => _HomeState();
}
class _HomeState extends State<Home> {
  final nameController=TextEditingController();
  final googleSignIn=GoogleSignIn();
  final auth=FirebaseAuth.instance;
  final searchController=TextEditingController();
  bool toggle=false;
  static const KEYINT='keyint';
  late int c;
  final ref=FirebaseFirestore.instance.collection('Emails');
  @override
  void initState() {
    write();
    super.initState();
  }
  void write()async{
    final pre=await SharedPreferences.getInstance();
    c=pre.getInt(KEYINT)??0;
    if(c==0){
      pre.setInt(KEYINT, 1);
      final id=DateTime.now().millisecondsSinceEpoch.toString();
        ref.doc(id).set({
          'Name':auth.currentUser!.displayName.toString(),
          'Email':auth.currentUser!.email.toString(),
          'PhotoUrl':auth.currentUser!.photoURL.toString(),
          'Id':0,
          'Switch':false,
          'Address':id
        }).then((value){
          Toast.toastMessage('Done');
        }).catchError((e){
          Toast.toastMessage(e.toString());
        });
      }
  }
  @override
  Widget build(BuildContext context) {
    final coll=FirebaseFirestore.instance.collection('Emails').orderBy('Id',descending: true).snapshots();
    final mediaQuery=MediaQuery.of(context).size;
    void signOut()async{
      final pref=await SharedPreferences.getInstance();
      pref.setInt(KEYINT, 0);
      googleSignIn.signOut().then((value){
        Navigator.pushReplacementNamed(context, '/login');
        Toast.toastMessage('Logged Out');
      }).catchError((e){
        Toast.toastMessage(e.toString());
      });
    }
    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
       appBar: AppBar(
         title: toggle? Padding(
           padding: const EdgeInsets.all(10.0),
           child: TextFormField(
             autofocus: true,
             onFieldSubmitted: (_){
               searchController.clear();
             },
             cursorColor: Colors.black,
             style: TextStyle(
               fontWeight: FontWeight.bold,
               fontSize: 18
             ),
             onChanged: (value){
               setState(() {

               });
             },
             controller: searchController,
             decoration: const InputDecoration(
               border: InputBorder.none,
               hintText: 'Search',
             ),
           ),
         ) : Text('Cyborg Tracker'),
         actions: [
           IconButton(
               onPressed: (){
                 searchController.clear();
                 if(toggle){
                   toggle=false;
                   setState(() {

                   });
                 }else{
                   toggle=true;
                   setState(() {

                   });
                 }
               },
               icon: toggle? const Icon(Icons.cancel) : const Icon(Icons.search)
           ),
           IconButton(onPressed: (){
                 signOut();
           }, icon: Icon(Icons.logout_outlined))
         ],
       ),
        body: SizedBox(
          height: mediaQuery.height,
          width: mediaQuery.width,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              child: StreamBuilder(
                stream: coll,
                builder: (context,snapshot){
                  if(!snapshot.hasData){
                    return const Center(child: CircularProgressIndicator(),);
                  }else{
                    return ListView.builder(
                        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context,index) {
                          if (searchController.text.toString().isEmpty) {
                            if (snapshot.data!.docs[0]['Switch']) {
                              return Card(
                                color: const Color(0xffededed),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: ListTile(
                                  onTap: (){
                                    showMyDialogUpdate(snapshot.data!.docs[index]['Name'].toString(),snapshot.data!.docs[index]['Address'].toString());
                                  },
                                  onLongPress: (){
                                    showMyDialogDelete(snapshot.data!.docs[index]['Address'].toString());
                                  },
                                    leading: CircleAvatar(
                                      backgroundImage: NetworkImage(
                                          snapshot.data!.docs[index]['PhotoUrl']
                                              .toString()),
                                    ),
                                    title: Text(snapshot.data!.docs[index]['Name']
                                        .toString()),
                                    subtitle: Text(
                                        snapshot.data!.docs[index]['Email']
                                            .toString()),
                                    trailing: Switch(
                                      activeColor: Colors.green,
                                      value: snapshot.data!.docs[index]['Switch'],
                                      onChanged: snapshot.data!
                                          .docs[index]['Switch'] ? (value) {
                                        if (value) {
                                          ref.doc(
                                              snapshot.data!.docs[index]['Address'])
                                              .update({
                                            'Id': 1,
                                            'Switch': true
                                          })
                                              .then((value) async {
                                            final pre = await SharedPreferences
                                                .getInstance();
                                            pre.setInt(KEYINT, 1);
                                            setState(() {

                                            });
                                          }).catchError((e) async {
                                            final pre = await SharedPreferences
                                                .getInstance();
                                            pre.setInt(KEYINT, 1);
                                            setState(() {

                                            });
                                          });
                                        } else {
                                          ref.doc(
                                              snapshot.data!.docs[index]['Address'])
                                              .update({
                                            'Id': 0,
                                            'Switch': false
                                          })
                                              .then((value) async {
                                            final pre = await SharedPreferences
                                                .getInstance();
                                            pre.setInt(KEYINT, 1);
                                            setState(() {

                                            });
                                          }).catchError((e) async {
                                            final pre = await SharedPreferences
                                                .getInstance();
                                            pre.setInt(KEYINT, 1);
                                            setState(() {

                                            });
                                          });
                                        }
                                      } : null,
                                    )
                                ),
                              );
                            } else {
                              return Card(
                                color: const Color(0xffededed),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: ListTile(
                                  onTap: (){
                                    showMyDialogUpdate(snapshot.data!.docs[index]['Name'].toString(),snapshot.data!.docs[index]['Address'].toString());
                                  },
                                  onLongPress: (){
                                    showMyDialogDelete(snapshot.data!.docs[index]['Address'].toString());
                                  },
                                    leading: CircleAvatar(
                                      backgroundImage: NetworkImage(
                                          snapshot.data!.docs[index]['PhotoUrl']
                                              .toString()),
                                    ),
                                    title: Text(snapshot.data!.docs[index]['Name']
                                        .toString()),
                                    subtitle: Text(
                                        snapshot.data!.docs[index]['Email']
                                            .toString()),
                                    trailing: Switch(
                                      activeColor: Colors.green,
                                      value: snapshot.data!.docs[index]['Switch'],
                                      onChanged: (value) {
                                        if (value) {
                                          ref.doc(
                                              snapshot.data!.docs[index]['Address'])
                                              .update({
                                            'Id': 1,
                                            'Switch': true
                                          })
                                              .then((value) async {
                                            final pre = await SharedPreferences
                                                .getInstance();
                                            pre.setInt(KEYINT, 1);
                                            setState(() {

                                            });
                                          }).catchError((e) async {
                                            final pre = await SharedPreferences
                                                .getInstance();
                                            pre.setInt(KEYINT, 1);
                                            setState(() {

                                            });
                                          });
                                        } else {
                                          ref.doc(
                                              snapshot.data!.docs[index]['Address'])
                                              .update({
                                            'Id': 0,
                                            'Switch': false
                                          })
                                              .then((value) async {
                                            final pre = await SharedPreferences
                                                .getInstance();
                                            pre.setInt(KEYINT, 1);
                                            setState(() {

                                            });
                                          }).catchError((e) async {
                                            final pre = await SharedPreferences
                                                .getInstance();
                                            pre.setInt(KEYINT, 1);
                                            setState(() {

                                            });
                                          });
                                        }
                                      },
                                    )
                                ),
                              );
                            }
                          }else if(snapshot.data!.docs[index]['Name'].toString().toLowerCase().contains(searchController.text.toLowerCase().toString())){
                            if (snapshot.data!.docs[0]['Switch']) {
                              return Card(
                                color: const Color(0xffededed),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: ListTile(
                                    onTap: (){
                                      showMyDialogUpdate(snapshot.data!.docs[index]['Name'].toString(),snapshot.data!.docs[index]['Address'].toString());
                                    },
                                    onLongPress: (){
                                      showMyDialogDelete(snapshot.data!.docs[index]['Address'].toString());
                                    },
                                    leading: CircleAvatar(
                                      backgroundImage: NetworkImage(
                                          snapshot.data!.docs[index]['PhotoUrl']
                                              .toString()),
                                    ),
                                    title: Text(snapshot.data!.docs[index]['Name']
                                        .toString()),
                                    subtitle: Text(
                                        snapshot.data!.docs[index]['Email']
                                            .toString()),
                                    trailing: Switch(
                                      activeColor: Colors.green,
                                      value: snapshot.data!.docs[index]['Switch'],
                                      onChanged: snapshot.data!
                                          .docs[index]['Switch'] ? (value) {
                                        if (value) {
                                          ref.doc(
                                              snapshot.data!.docs[index]['Name'])
                                              .update({
                                            'Id': 1,
                                            'Switch': true
                                          })
                                              .then((value) async {
                                            final pre = await SharedPreferences
                                                .getInstance();
                                            pre.setInt(KEYINT, 1);
                                            setState(() {

                                            });
                                          }).catchError((e) async {
                                            final pre = await SharedPreferences
                                                .getInstance();
                                            pre.setInt(KEYINT, 1);
                                            setState(() {

                                            });
                                          });
                                        } else {
                                          ref.doc(
                                              snapshot.data!.docs[index]['Name'])
                                              .update({
                                            'Id': 0,
                                            'Switch': false
                                          })
                                              .then((value) async {
                                            final pre = await SharedPreferences
                                                .getInstance();
                                            pre.setInt(KEYINT, 1);
                                            setState(() {

                                            });
                                          }).catchError((e) async {
                                            final pre = await SharedPreferences
                                                .getInstance();
                                            pre.setInt(KEYINT, 1);
                                            setState(() {

                                            });
                                          });
                                        }
                                      } : null,
                                    )
                                ),
                              );
                            } else {
                              return Card(
                                color: const Color(0xffededed),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: ListTile(
                                    onTap: (){
                                      showMyDialogUpdate(snapshot.data!.docs[index]['Name'].toString(),snapshot.data!.docs[index]['Address'].toString());
                                    },
                                    onLongPress: (){
                                      showMyDialogDelete(snapshot.data!.docs[index]['Address'].toString());
                                    },
                                    leading: CircleAvatar(
                                      backgroundImage: NetworkImage(
                                          snapshot.data!.docs[index]['PhotoUrl']
                                              .toString()),
                                    ),
                                    title: Text(snapshot.data!.docs[index]['Name']
                                        .toString()),
                                    subtitle: Text(
                                        snapshot.data!.docs[index]['Email']
                                            .toString()),
                                    trailing: Switch(
                                      activeColor: Colors.green,
                                      value: snapshot.data!.docs[index]['Switch'],
                                      onChanged: (value) {
                                        if (value) {
                                          ref.doc(
                                              snapshot.data!.docs[index]['Name'])
                                              .update({
                                            'Id': 1,
                                            'Switch': true
                                          })
                                              .then((value) async {
                                            final pre = await SharedPreferences
                                                .getInstance();
                                            pre.setInt(KEYINT, 1);
                                            setState(() {

                                            });
                                          }).catchError((e) async {
                                            final pre = await SharedPreferences
                                                .getInstance();
                                            pre.setInt(KEYINT, 1);
                                            setState(() {

                                            });
                                          });
                                        } else {
                                          ref.doc(
                                              snapshot.data!.docs[index]['Name'])
                                              .update({
                                            'Id': 0,
                                            'Switch': false
                                          })
                                              .then((value) async {
                                            final pre = await SharedPreferences
                                                .getInstance();
                                            pre.setInt(KEYINT, 1);
                                            setState(() {

                                            });
                                          }).catchError((e) async {
                                            final pre = await SharedPreferences
                                                .getInstance();
                                            pre.setInt(KEYINT, 1);
                                            setState(() {

                                            });
                                          });
                                        }
                                      },
                                    )
                                ),
                              );
                            }
                          }else{
                            return Container(

                            );
                          }
                        }
                    );
                  }
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
  void showMyDialogUpdate(String name,String id){
    nameController.text=name;
    showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            title: Text('Edit Your Name'),
            content: TextFormField(
              controller: nameController,
            ),
            actions: [
              TextButton(
                  onPressed: (){
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancel')
              ),
              TextButton(
                  onPressed: (){
                    ref.doc(id).update({
                      'Name':nameController.text.toString()
                    });
                    Navigator.of(context).pop();
                  },
                  child: Text('Update')
              ),
            ],
          );
        }
    );
  }
  void showMyDialogDelete(String id){
    showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            title: Icon(Icons.delete,size: 40,),
            content: Text('Are You Sure Want To Delete?'),
            actions: [
              TextButton(
                  onPressed: (){
                    Navigator.of(context).pop();
                  },
                  child: Text('No')
              ),
              TextButton(
                  onPressed: (){
                    ref.doc(id).delete();
                    Navigator.of(context).pop();
                  },
                  child: Text('Yes')
              ),
            ],
          );
        }
    );
  }
}