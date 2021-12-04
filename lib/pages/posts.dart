import 'dart:convert';
import 'dart:io';
//import 'dart:html';




import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:trashforsigninsignout/pages/home2.dart';
import 'package:trashforsigninsignout/pages/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Posts extends StatefulWidget {
  @override
  _PostsState createState() => _PostsState();
}

class _PostsState extends State<Posts> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    vvv();
  }


  void vvv() async{
    final User user = FirebaseAuth.instance.currentUser;
    final snapShot = await FirebaseFirestore.instance.collection('users').doc("${user.uid}").get();
    setState(() {
      gg=snapShot.data()["name"];
      gg2=snapShot.data()["photo_url"];
    });
  }

  var gg;
  var gg2;


  final User user = FirebaseAuth.instance.currentUser;
  final myController = TextEditingController();

//  void profileview(BuildContext context){
//    showDialog(
//      context: context,
//      builder: (ctx) => AlertDialog(
//
//        content:Container(
//          height: 220,
//          child: Column(
//            children: [
//              InkWell(
//                  onTap: (){
//                      getImage();
//                  },
//                  child: Image.network("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRJ_b4wi7ZqUCtuJWaHxFwEbI44bU2R-uUygA&usqp=CAU",height: 120,)),
//
//              TextField(
//                controller: myController,
//
//                  style: GoogleFonts.zillaSlab(fontSize: 20,fontWeight: FontWeight.bold),
//                  decoration: InputDecoration(
//
//                  hintText: "Enter Description",
//                  hintStyle: GoogleFonts.zillaSlab(fontSize: 20,fontWeight: FontWeight.bold),
//
//
//                  ),
//
//
//              ),
//              SizedBox(
//                height: 3,
//              ),
//              RaisedButton(
//                onPressed: (){
//                    uploadPic(context, myController.text,DateTime.now().microsecondsSinceEpoch);
//                },
//                color: Colors.blueGrey,child:Text("Add",style: GoogleFonts.aladin(fontWeight: FontWeight.bold,letterSpacing: 1,fontSize: 20),),)
//            ],
//          ),
//        ),
//
//      ),
//    );
//  }
  File _image;

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);


    setState(() {
      _image = image;
      print('Image Path $_image');
    });
  }
  final databaseReference = FirebaseFirestore.instance;

  Future uploadPic(BuildContext context,var i,var time) async{

    String fileName = basename(_image.path);
    Reference firebaseStorageRef = FirebaseStorage.instance.ref().child(fileName);
    UploadTask uploadTask = firebaseStorageRef.putFile(_image);
    TaskSnapshot taskSnapshot=await uploadTask.whenComplete(() =>
        setState(() {
          Scaffold.of(context).showSnackBar(SnackBar(content: Text('Post Uploaded')));
        })
    );

    String url = (await firebaseStorageRef.getDownloadURL()).toString();

    await databaseReference.collection("posts")
        .doc("for").collection("all").doc(time.toString())
        .set({
      'name':gg,
      'post_url':url,
      'photo_url':gg2,
      'user_id':user.uid,
      'desc':i,
      'time':time,
    });


  }




  clearTextInput(){

    myController.clear();

  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      resizeToAvoidBottomInset: false,
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(FontAwesomeIcons.arrowLeft),
              onPressed: () {
                Navigator.pop(context);
              }),
          title: Text('All Posts',style: GoogleFonts.playfairDisplay(fontSize: 26,fontWeight: FontWeight.bold),),

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



                      return Padding(
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
                                    padding: const EdgeInsets.all(6.0),
                                    child: Row(children: [
                                      SizedBox(width: 10,),
                                      CircleAvatar(
                                        radius: 25,
                                        child:CachedNetworkImage(
                                          imageUrl:documentSnapshot["photo_url"],
                                          imageBuilder: (context, imageProvider) => Container(

                                            decoration: BoxDecoration(
                                              shape:BoxShape.circle,
                                              image: DecorationImage(

                                                  image: imageProvider, fit: BoxFit.cover),
                                            ),
                                          ),



                                          placeholder: (context, url) => CircularProgressIndicator(),
                                          errorWidget: (context, url, error) => Icon(Icons.error),
                                        ),
                                      ),
                                      SizedBox(width: 20,),
                                      Text(documentSnapshot["name"],style: GoogleFonts.zillaSlab(fontSize: 19,color: Colors.grey[100],fontWeight: FontWeight.bold),)
                                    ],),
                                  ),
                                  Card(
                                    color: Colors.blueGrey[800],
                                    elevation: 8,
                                    child: Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: Container(
                                        height: 355,
                                        child:CachedNetworkImage(
                                          imageUrl:documentSnapshot["post_url"],
                                          imageBuilder: (context, imageProvider) => Container(

                                            decoration: BoxDecoration(

                                              image: DecorationImage(
                                                  image: imageProvider, fit: BoxFit.fill),
                                            ),
                                          ),



                                          placeholder: (context, url) => CircularProgressIndicator(),
                                          errorWidget: (context, url, error) => Icon(Icons.error),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Text(documentSnapshot["desc"],style: GoogleFonts.courgette(fontSize: 16,color: Colors.grey[100]),),
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

                      );
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


      floatingActionButton: Builder(
        builder: (context) => InkWell(
        onTap: () {
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(

              content:Container(
                height: 244,
                child: Column(
                  children: [
                    InkWell(
                        onTap: (){
                          getImage();
                        },
                        child: Card(elevation:10,child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.network("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRJ_b4wi7ZqUCtuJWaHxFwEbI44bU2R-uUygA&usqp=CAU",height: 120,),
                        ))),

                    TextField(
                      controller: myController,

                      style: GoogleFonts.zillaSlab(fontSize: 20,fontWeight: FontWeight.bold),
                      decoration: InputDecoration(

                        hintText: "Enter Description",
                        hintStyle: GoogleFonts.zillaSlab(fontSize: 20,fontWeight: FontWeight.bold),


                      ),


                    ),
                    SizedBox(
                      height: 3,
                    ),
                    RaisedButton(
                      onPressed: (){
                        uploadPic(context, myController.text,DateTime.now().microsecondsSinceEpoch);
                        clearTextInput();
                      },
                      color: Colors.blueGrey,child:Text("Add",style: GoogleFonts.aladin(fontWeight: FontWeight.bold,letterSpacing: 1,fontSize: 20),),)
                  ],
                ),
              ),

            ),
          );
        },
        child:   Container(
          width: 70,
          height: 70,
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                  Radius.circular(90)),
            ),
            child: Icon(Icons.group,color: Colors.white,),
            color: Colors.blueGrey[600],
          ),
        ),
      ),
      )
    );
  }
}
