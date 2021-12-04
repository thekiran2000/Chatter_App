import 'dart:convert';



import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trashforsigninsignout/pages/home2.dart';
import 'package:trashforsigninsignout/pages/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Myposts extends StatefulWidget {
  @override
  _MypostsState createState() => _MypostsState();
}

class _MypostsState extends State<Myposts> {

  final databaseReference = FirebaseFirestore.instance;
//  void deleteimage(var time)async{
//    await databaseReference.collection("posts").doc("for").collection("all").doc(time.toString()).delete();
////    Reference storageReference = FirebaseStorage.instance.getReferenceFromUrl("https://firebasestorage.googleapis.com/v0/b/***********************-5fac-45b6-bbda-ed4e8a3a62ab");
////    Reference ref = await FirebaseStorage.instance.getReference();
////    ref.delete();
//  }

  deletepost(var x) async{


    showDialog(
      context: this.context,
      builder: (ctx) => Padding(
        padding: const EdgeInsets.only(top:210.0,bottom: 210),
        child: AlertDialog(
          title: Text("Deletepost ?"),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              InkWell(
                  onTap: (){
                    Navigator.of(ctx).pop();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text("Cancel"),
                  )
              ),
              InkWell(
                  onTap: ()async{
                    await databaseReference.collection("posts").doc("for").collection("all").doc(x.toString()).delete();
//                    Reference j= await FirebaseStorage.instance.ref(p);
//                    j.delete();
                    Navigator.of(ctx).pop();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text("Delete for me"),
                  )
              ),

            ],
          ),

        ),
      ),
    );


  }

  final User user = FirebaseAuth.instance.currentUser;
  var togle=true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(FontAwesomeIcons.arrowLeft),
            onPressed: () {
              Navigator.pop(context);
            }),
        title: Text('My Posts',style: GoogleFonts.playfairDisplay(fontSize: 26,fontWeight: FontWeight.bold),),


        toolbarHeight: 70,
        backgroundColor: Colors.blueGrey[800],
      ),
      body: SingleChildScrollView(

        child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('posts').doc("for").collection("all").snapshots(),

          builder: (context,snapshot){
            if(snapshot.hasData){

              return ListView.builder(
                  physics: BouncingScrollPhysics(),

                  shrinkWrap: true,
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context,index){
                    DocumentSnapshot documentSnapshot=snapshot.data.documents[index];


                    if(documentSnapshot["user_id"]==user.uid){
                      togle=true;
                    }
                    else{
                      togle=false;
                    }

                    return togle ? InkWell(
                      onLongPress: (){
                        deletepost(documentSnapshot["time"]);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Column(
                          children: [
                            Card(
                              color: Colors.grey[900],
                              elevation: 16,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Row(children: [
                                      SizedBox(width: 10,),
                                      CircleAvatar(
                                        radius: 28,
                                        backgroundImage: NetworkImage(
                                            documentSnapshot["photo_url"]),
                                      ),
                                      SizedBox(width: 20,),
                                      Text(documentSnapshot["name"],style: GoogleFonts.zillaSlab(fontSize: 20,color: Colors.grey[100],fontWeight: FontWeight.bold),)
                                    ],),
                                  ),
                                  Card(
                                    color: Colors.blueGrey[800],
                                    elevation: 8,
                                    child: Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: Container(
                                        height: 355,
                                        decoration: BoxDecoration(
                                            image: DecorationImage( image: NetworkImage(documentSnapshot["post_url"]),fit: BoxFit.fill)),

                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Text(documentSnapshot["desc"],style: GoogleFonts.courgette(fontSize: 20,color: Colors.grey[100]),),
                                  ),


                                ],
                              ),
                            ),
                            SizedBox(height: 4,),
                            Padding(
                              padding: const EdgeInsets.only(left:10.0,right: 10),
                              child: Divider(color: Colors.grey[700],thickness: 1.3,),
                            ),
                          ],
                        ),

                      ),
                    ):SizedBox(height: 0,);
                  }


              );
            }
            if (!snapshot.hasData){
              print('test phrase');
              return SizedBox();
            }

          },

        ),
      ),
    );
  }
}
