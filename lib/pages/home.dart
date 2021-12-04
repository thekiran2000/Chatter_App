import 'dart:convert';



import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trashforsigninsignout/pages/home2.dart';
import 'package:trashforsigninsignout/pages/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
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

class ScaleRoute extends PageRouteBuilder {
  final Widget page;
  ScaleRoute({this.page})
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
        ScaleTransition(
          scale: Tween<double>(
            begin: 0.0,
            end: 1.0,
          ).animate(
            CurvedAnimation(
              parent: animation,
              curve: Curves.fastOutSlowIn,
            ),
          ),
          child: child,
        ),
  );
}

class _HomeState extends State<Home> {


  final databaseReference = FirebaseFirestore.instance;
  final User user = FirebaseAuth.instance.currentUser;



  void createuser() async{
    final User user = FirebaseAuth.instance.currentUser;

    final snapShot = await FirebaseFirestore.instance.collection('users').doc("${user.uid}").get();

    if (!snapShot.exists){
      try{
        var name="vish";
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Center(child: Text("Name please!!!",style: GoogleFonts.zillaSlab(fontSize: 23,fontWeight: FontWeight.bold,color: Colors.red[400]),)),
                content: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: TextFormField(

                            onFieldSubmitted: (value){
                              setState(() {
                                name=value;
                              });
                            },
                            style: GoogleFonts.zillaSlab(fontSize: 20,fontWeight: FontWeight.bold),
                            decoration: InputDecoration(

                              hintText: "Enter Your Name..",
                              hintStyle: GoogleFonts.zillaSlab(fontSize: 20,fontWeight: FontWeight.bold),


                            ),


                          ),
                        ),
                      ),
                    ),
                    Container(height:46,width: 220,child: RaisedButton(color: Colors.blue,child:Text("Submit",style: GoogleFonts.aladin(fontWeight: FontWeight.bold,letterSpacing: 1,fontSize: 20),),
                        onPressed:() async{
                          await databaseReference.collection("users")
                              .doc("${user.uid}")
                              .set({
                            'name': "$name",
                            'about': "Hey i am using chatter",
                            'user_id': "${user.uid}",
                            'photo_url': "https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80",
                            'status': false,

                          });
                          await databaseReference.collection("colors")
                              .doc("${user.uid}")
                              .set({
                            'color': false,
                          });
                          Navigator.of(context).pop();
                    }))
                  ],
                ),

              );
            });


      }
      catch(e){
        print(e);

      }


    }

    else{
      print("user already there boy");
    }

  }

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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    createuser();
    chagestatustotrue();
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

  void profileview(var photo,var name){
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Center(child: Text("$name",style: GoogleFonts.mcLaren(fontSize: 23,color: Colors.blueGrey),)),
        content:Container(
          height: 300,
          decoration: BoxDecoration(
              image: DecorationImage( image: NetworkImage('$photo'),fit: BoxFit.cover)),
        ),

      ),
    );
  }
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
  bool togle=true;

  Color col=Colors.grey[200];
  Color col1=Colors.blueGrey[900];

  Color colfont=Colors.grey[900];
  Color colfont1=Colors.grey[200];

  bool coltoggle=true;
  bool coltogglefont=true;

//  void vvv()async{
//    final snapShot = await FirebaseFirestore.instance.collection('colors').doc("${user.uid}").get();
//    setState(() {
//      coltoggle=snapShot.data()["color"];
//      coltogglefont=snapShot.data()["color"];
//    });
//  }



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
                    Text("All Users",style: GoogleFonts.cookie(fontSize: 26,color: Colors.grey[400],letterSpacing: 0.7),),
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
                              stream: FirebaseFirestore.instance.collection('users').snapshots(),

                              builder: (context,snapshot){
                                if(snapshot.hasData){

                                  return ListView.builder(
                                      physics: BouncingScrollPhysics(),

                                      shrinkWrap: true,
                                      itemCount: snapshot.data.documents.length,
                                      itemBuilder: (context,index){
                                        DocumentSnapshot documentSnapshot=snapshot.data.documents[index];

                                        if(documentSnapshot["user_id"]==user.uid.toString()){
                                          togle=false;
                                        }
                                        else{
                                          togle=true;
                                        }



                                        return togle ? Container(

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
                                                                    profileview(documentSnapshot["photo_url"],documentSnapshot["name"]);
                                                                  },
                                                                  child: Container(
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
                                        ) : SizedBox(height: 0,);
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
                          SizedBox(height: 500,)
                        ],
                      ),
                    ),
                  ),
                );
              }
              else{
//                  print('test phrase');
                return SizedBox();
              }
              }

            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: 2,
            backgroundColor: Colors.blueGrey[800],
            items: [
              BottomNavigationBarItem(
                icon: InkWell(onTap: (){
                  Navigator.pushReplacement(context, SlideRightRoute(page: friends()));
                },child: InkWell(
                    onTap: (){
                      Navigator.pushReplacement(context, SlideRightRoute(page: friends()));
                    },
                    child: new Icon(Icons.people,size: 25,),)),
                title: new Text('Friends',style: GoogleFonts.zillaSlab(fontSize: 15,fontWeight: FontWeight.bold)),
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
                    child: new Icon(Icons.chat,color: Colors.white,))),
                title: new Text('All Users',style: GoogleFonts.zillaSlab(fontSize: 15,fontWeight: FontWeight.bold,color: Colors.white)),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
