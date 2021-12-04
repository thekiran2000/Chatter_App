import 'dart:convert';



import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trashforsigninsignout/pages/home.dart';
import 'package:trashforsigninsignout/pages/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';

class friends extends StatefulWidget {
  @override
  _friendsState createState() => _friendsState();
}

class SlideRightRoute extends PageRouteBuilder {
  final Widget page;
  SlideRightRoute({this.page})
      : super(
    pageBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        ) =>
    page,
    transitionsBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        Widget child,
        ) =>
        SlideTransition(

          position: Tween<Offset>(
            begin: const Offset(0, 0),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        ),
  );
}

class _friendsState extends State<friends> {

  Future<bool> _onBackPressed() {
    return showDialog(
      context: context,
      builder: (context) => Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,

            colors: [

              Colors.green[500],
              Colors.greenAccent,
              Colors.lightGreen,
              Colors.lightGreenAccent,
              Colors.green,


            ],
          ),
        ),

        child: new AlertDialog(
          title: new Text('Are you sure?',style: GoogleFonts.zillaSlab(fontWeight: FontWeight.bold,color: Colors.green[900],fontSize: 35),),
          content: new Text('Do you want to exit an App',style: GoogleFonts.zillaSlab(color: Colors.green[900],fontSize: 20),),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: new GestureDetector(
                onTap: () => Navigator.of(context).pop(false),
                child:  Text("NO",style: GoogleFonts.zillaSlab(fontWeight: FontWeight.bold,color: Colors.green[900],fontSize: 20),),
              ),
            ),
            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: new GestureDetector(
                onTap: () {
                  chagestatustofalse();
                  Navigator.of(context).pop(true);
                },
                child: Text("YES",style: GoogleFonts.zillaSlab(fontWeight: FontWeight.bold,color: Colors.green[900],fontSize: 20),),
              ),
            ),
          ],
        ),
      ),
    ) ??
        false;
  }



  final databaseReference = FirebaseFirestore.instance;
  final User user = FirebaseAuth.instance.currentUser;

  void chagestatustotrue()async{
    await databaseReference.collection("users")
        .doc("${user.uid}")
        .update({
      'status': true,

    });
  }

  void chagestatustofalse()async{
    await databaseReference.collection("users")
        .doc("${user.uid}")
        .update({
      'status': false,

    });
  }


  Future signOut() async{
    chagestatustofalse();
    try{

      await FirebaseAuth.instance.signOut();

      Navigator.pushReplacementNamed(context, "/login");
    }
    catch(e){

      return null;
    }
  }

  void handleClick(String value) {
    switch (value) {
      case 'Logout':signOut();
      break;
      case 'Settings':Navigator.pushNamed(context, "/settings");
      break;
      case 'Theme':changetheme();
      break;
      case 'My posts':Navigator.pushNamed(context, "/myposts");
      break;
    }
  }

  void profileview(var photo,var name,var id){
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Center(child: Text("$name",style: GoogleFonts.mcLaren(fontSize: 23,color: Colors.blueGrey),)),
        content:Container(
          height: 325,
          child: Column(
            children: [
              Container(
                height: 300,
                decoration: BoxDecoration(
                    image: DecorationImage( image: NetworkImage('$photo'),fit: BoxFit.cover)),
              ),
              Row(
                children: [
                  SizedBox(width: 60,),
                  Text("Delete friend"),
                  InkWell(
                      onTap: (){
                        deletefriend(name, id);

                      },
                      child: Icon(Icons.delete))
                ],
              )
            ],
          ),
        ),

      ),
    );
  }

  Color col=Colors.grey[200];
  Color col1=Colors.blueGrey[900];

  Color colfont=Colors.grey[900];
  Color colfont1=Colors.grey[200];

  bool coltoggle=true;
  bool coltogglefont=true;

  void changetheme()async{
    final snapShot = await FirebaseFirestore.instance.collection('colors').doc("${user.uid}").get();
    setState(() {
      coltoggle=!snapShot.data()["color"];
      coltogglefont=!snapShot.data()["color"];
    });
    if(snapShot.exists) {
      await databaseReference.collection("colors")
          .doc("${user.uid}")
          .update({
        'color': coltoggle,
      });
    }
    else{
      setState(() {
        coltoggle=false;
        coltogglefont=false;
      });

      await databaseReference.collection("colors")
          .doc("${user.uid}")
          .set({
        'color': false,
      });
    }
  }





  void deletefriend(var name,var id)async{
    showDialog(
      context: context,
      builder: (ctx) => Padding(
        padding: const EdgeInsets.only(top:210.0,bottom: 210),
        child: AlertDialog(
          title: Text("Delete friend $name?"),
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
                    await databaseReference.collection("friends").doc("${user.uid}").collection("dost").doc("$id").delete();
                    Navigator.of(ctx).pop();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text("Delete friend"),
                  )
              ),

            ],
          ),

        ),
      ),
    );
  }

  bool tagle=true;



  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Container(
        decoration: BoxDecoration(
            image: DecorationImage( image: AssetImage('assets/star.jpg'),fit: BoxFit.cover)),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            elevation: 0.0,
            title: Row(
              children: [
                Image.asset("assets/logo.jpg",width: 55,),
                SizedBox(width: 6,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Chatter",style: GoogleFonts.cookie(fontSize: 53,color: Colors.grey[400],letterSpacing: 0.7),),
                    Text("Friends",style: GoogleFonts.cookie(fontSize: 26,color: Colors.grey[400],letterSpacing: 0.7),),
                  ],
                ),
              ],
            ),
            toolbarHeight: 100,

            backgroundColor: Colors.transparent,
            actions: <Widget>[
              PopupMenuButton<String>(
                onSelected: handleClick,
                itemBuilder: (BuildContext context) {
                  return {'Logout', 'Settings','Theme','My posts'}.map((String choice) {
                    return PopupMenuItem<String>(
                      value: choice,
                      child: Text(choice),
                    );
                  }).toList();
                },
              ),
            ],

          ),

          body:   SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: StreamBuilder(
              stream: FirebaseFirestore.instance.collection('colors').doc('${user.uid}').snapshots(),
              builder: (context,snapshot){
              if(snapshot.hasData){
                DocumentSnapshot documentSnapshot1=snapshot.data;
                return Container(

                  child: Card(
                    color: documentSnapshot1["color"] ? col: col1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                          top: Radius.circular(30)),
                    ),
                    child: Container(
                      child: Column(
                        children: [
                          SizedBox(height: 10,),
                          Card(
                            elevation: 0,
                            color: documentSnapshot1["color"] ? col: col1,
                            child: StreamBuilder(
                              stream: FirebaseFirestore.instance.collection('friends').doc("${user.uid}").collection("dost").snapshots(),

                              builder: (context,snapshot){
                                if(snapshot.hasData){

                                  return ListView.builder(
                                      physics: BouncingScrollPhysics(),

                                      shrinkWrap: true,
                                      itemCount: snapshot.data.documents.length,
                                      itemBuilder: (context,index){
                                        DocumentSnapshot documentSnapshot=snapshot.data.documents[index];

                                        if(documentSnapshot["msg_count"]==0){

                                          tagle=false;

                                        }
                                        else{
                                          tagle=true;
                                        }

                                        return Container(

                                          child: Column(
                                            children: [
                                              Card(
                                                elevation: 0,
                                                color: documentSnapshot1["color"] ? col: col1,
                                                child: Padding(
                                                  padding: const EdgeInsets.all(0.0),
                                                  child: Column(
                                                    children: [
                                                      InkWell(
                                                          onTap: () {


                                                            Navigator.pushNamed(

                                                                context, "/chatpage",
                                                                arguments: {
                                                                  'name': documentSnapshot["name"],
                                                                  'user_id':documentSnapshot["user_id"],
                                                                  'my_id':user.uid,
                                                                  'photo_url':documentSnapshot["photo_url"],
                                                                  'about':documentSnapshot["about"],

                                                                });


                                                          },
                                                          child: Padding(
                                                            padding: const EdgeInsets
                                                                .all(5.0),
                                                            child: Row(

                                                              children: [
                                                                InkWell(
                                                                  onTap:(){
                                                                    profileview(documentSnapshot["photo_url"],documentSnapshot["name"],documentSnapshot["user_id"]);
                                                                  },

                                                                  child: CircleAvatar(
                                                                    radius: 28,
                                                                    child:CachedNetworkImage(
                                                                      imageUrl:documentSnapshot["photo_url"],
                                                                      imageBuilder: (context, imageProvider) => Container(
                                                                        width: 80.0,
                                                                        height: 80.0,
                                                                        decoration: BoxDecoration(
                                                                          shape: BoxShape.circle,
                                                                          image: DecorationImage(
                                                                              image: imageProvider, fit: BoxFit.cover),
                                                                        ),
                                                                      ),



                                                                      placeholder: (context, url) => CircularProgressIndicator(),
                                                                      errorWidget: (context, url, error) => Icon(Icons.error),
                                                                    ),
                                                                  ),
                                                                ),
                                                                SizedBox(width: 15,),
                                                                Column(
                                                                  crossAxisAlignment: CrossAxisAlignment
                                                                      .start,
                                                                  children: [
                                                                    Text(
                                                                      documentSnapshot["name"],
                                                                      style: GoogleFonts
                                                                          .mcLaren(
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          fontSize: 18,
                                                                          color: documentSnapshot1["color"] ? colfont : colfont1),),
                                                                    Padding(
                                                                      padding: const EdgeInsets
                                                                          .all(2.0),
                                                                      child: Text(
                                                                        documentSnapshot["about"],
                                                                        style: GoogleFonts
                                                                            .mcLaren(
                                                                            fontSize: 12,
                                                                            color: documentSnapshot1["color"] ? colfont : colfont1),),
                                                                    ),
                                                                  ],
                                                                ),
                                                                SizedBox(width: 70,),

                                                                tagle ? Container(
                                                                  width: 30,
                                                                  height: 30,
                                                                  child: Card(
                                                                    color: Colors.amber,
                                                                    shape: RoundedRectangleBorder(
                                                                      borderRadius: BorderRadius.all(
                                                                          Radius.circular(30)),
                                                                    ),
                                                                    child: Center(child: Text(documentSnapshot["msg_count"].toString(),style: GoogleFonts.zillaSlab(color: Colors.grey[800],fontWeight: FontWeight.bold),)),
                                                                  ),
                                                                ):SizedBox(height: 0,),
                                                              ],
                                                            ),
                                                          )),

                                                    ],

                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.fromLTRB(
                                                    77.0, 0, 10, 0),
                                                child: Divider(thickness: 1.4,
                                                  color: Colors.grey[400],),
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
                          SizedBox(height: 600,)
                        ],
                      ),
                    ),
                  ),
                );
              }
              if (!snapshot.hasData){

                return SizedBox();
              }
              }


            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: 0,
            backgroundColor: Colors.blueGrey[800],
            items: [
              BottomNavigationBarItem(
                icon: new Icon(Icons.people,color: Colors.white,size: 25,),
                title: new Text('Friends',
                  style: GoogleFonts.zillaSlab(fontSize: 15,fontWeight: FontWeight.bold,color: Colors.white),),
              ),
              BottomNavigationBarItem(
                icon: InkWell(onTap: (){
                  Navigator.pushNamed(context, "/posts");
                },child: new Icon(Icons.photo)),
                title: new Text('Posts',style: GoogleFonts.zillaSlab(fontSize: 15,fontWeight: FontWeight.bold)),
              ),
              BottomNavigationBarItem(
                icon: InkWell(onTap: (){
                  Navigator.pushReplacement(context, SlideRightRoute(page: Home()));
                },child: InkWell(
                    onTap: (){
                      Navigator.pushReplacement(context, SlideRightRoute(page: Home()));
                    },
                    child: new Icon(Icons.chat))),
                title: new Text('All Users',style: GoogleFonts.zillaSlab(fontSize: 15,fontWeight: FontWeight.bold)),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
