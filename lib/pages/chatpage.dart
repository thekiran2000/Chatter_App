import 'dart:convert';



import 'package:bubble/bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trashforsigninsignout/pages/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Chat extends StatefulWidget {
  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    vvv();



  }

  var userdata={};
  var user_id;
  var name;
  var my_id;

  var chat="";

  final databaseReference = FirebaseFirestore.instance;
  final User user = FirebaseAuth.instance.currentUser;

//  var time;



  void chat_messages(var chat,var other_id,var timestamp)async{

    final snapShot = await FirebaseFirestore.instance.collection('friends').doc("$user_id").collection("dost").doc("${user.uid}").get();
    final snapShot1 = await FirebaseFirestore.instance.collection('friends').doc("${user.uid}").collection("dost").doc("$user_id").get();

    if(chat==""){
      return;
    }

    else {
      await databaseReference.collection("messages")
          .doc("${user.uid}").collection("$other_id").doc("$timestamp").
      set({
        'msg': "$chat",
        'status': "from_me",
        'time': "${timestamp}",

      });
      await databaseReference.collection("messages")
          .doc("$other_id").collection("${user.uid}").doc("$timestamp").
      set({
        'msg': "$chat",
        'status': "from_other",
        'time': "${timestamp}",

      });

      if(!snapShot.exists || !snapShot1.exists){
          try {
            await databaseReference.collection("friends").doc("${user.uid}")
                .collection("dost").doc("$user_id")
                .set({
              'name': "$name",
              'about': "$about",
              'user_id': "$user_id",
              'photo_url': "$photo",
              'msg_count': 0,

            });
            await databaseReference.collection("friends").doc("$user_id")
                .collection("dost").doc("${user.uid}")
                .set({
              'name': "$gg",
              'about': "$gg1",
              'user_id': "${user.uid}",
              'photo_url': "$gg2",
              'msg_count': 0,

            });
          }
          catch(e){
            print(e);
          }
      }

    }

  }

  void deletechats()async{
    await FirebaseFirestore.instance.collection('messages').doc("${user.uid}").collection("$user_id").snapshots().forEach((element) {
      for (QueryDocumentSnapshot snapshot in element.docs) {
        snapshot.reference.delete();
      }
    });

  }

   Future<bool> msg_count_to_zero()async{
    final User user = FirebaseAuth.instance.currentUser;
    await databaseReference.collection("friends").doc("${user.uid}")
        .collection("dost").doc("$user_id")
        .update({
      'msg_count': 0,
    });
    return true;
  }

  void mes_zero()async{
    await databaseReference.collection("friends").doc("${user.uid}")
        .collection("dost").doc("$user_id")
        .update({
      'msg_count': 0,
    });
  }
  void msg_count()async{
    final User user = FirebaseAuth.instance.currentUser;
    final snapShot = await FirebaseFirestore.instance.collection('friends').doc("$user_id").collection("dost").doc("${user.uid}").get();
    var message;

    if(snapShot.exists){
      message=snapShot.data()["msg_count"]+1;
      await databaseReference.collection("friends").doc("$user_id")
          .collection("dost").doc("${user.uid}")
          .update({
        'msg_count': message,
      });
    }

  }





  var gg;
  var gg1;
  var gg2;

  void vvv() async{
    final User user = FirebaseAuth.instance.currentUser;
    final snapShot = await FirebaseFirestore.instance.collection('users').doc("${user.uid}").get();
    gg=snapShot.data()["name"];
    gg1=snapShot.data()["about"];
    gg2=snapShot.data()["photo_url"];

  }


  
  void delete_message(var timestamp){
    showDialog(
      context: context,
      builder: (ctx) => Padding(
        padding: const EdgeInsets.only(top:210.0,bottom: 210),
        child: AlertDialog(
          title: Text("Delete message?"),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SizedBox(height: 15,),
              InkWell(
                onTap: ()async{
                  await databaseReference.collection("messages").doc("${user.uid}").collection("$user_id").doc("$timestamp").delete();
                  Navigator.of(ctx).pop();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text("Delete for me"),
                  )
              ),
              SizedBox(height: 15,),
              InkWell(
                  onTap: (){
                    Navigator.of(ctx).pop();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text("Cancel"),
                  )
              ),
              SizedBox(height: 15,),
              InkWell(
                  onTap: ()async{
                    await databaseReference.collection("messages").doc("$user_id").collection("${user.uid}").doc("$timestamp").delete();
                    await databaseReference.collection("messages").doc("${user.uid}").collection("$user_id").doc("$timestamp").delete();
                    Navigator.of(ctx).pop();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text("Delete for everyone"),
                  )
              ),
            ],
          ),

        ),
      ),
    );
  }
  
  void delete_for_me(var timestamp){
    showDialog(
      context: context,
      builder: (ctx) => Padding(
        padding: const EdgeInsets.only(top:210.0,bottom: 210),
        child: AlertDialog(
          title: Text("Delete message from $name ?"),
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
                  await databaseReference.collection("messages").doc("${user.uid}").collection("$user_id").doc("$timestamp").delete();
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

  bool toggle=true;
  var Time;
  var Hour;
  var Minute;



  void timetodaily(var i){
    i=int.parse(i);
    Time=DateTime.fromMicrosecondsSinceEpoch(i,isUtc: false);
    Hour=Time.hour;
    Minute=Time.minute;
    if(Minute.toString().length==1){
      Minute="0$Minute";
    }

  }



  final nameHolder = TextEditingController();


  clearTextInput(){

    nameHolder.clear();

  }



  var photo;
  var about;

  var kk="";

  @override

  Widget build(BuildContext context) {
    userdata=ModalRoute.of(context).settings.arguments;
    user_id=userdata['user_id'];
    name=userdata['name'];
    my_id=userdata['my_id'];
    photo=userdata['photo_url'];
    about=userdata['about'];





    return WillPopScope(
      onWillPop: msg_count_to_zero,
      child: Scaffold(

        backgroundColor: Colors.blueGrey[100],
        appBar: AppBar(
          leading: IconButton(
            iconSize: 18,
              icon: Icon(FontAwesomeIcons.arrowLeft),
              onPressed: () {
                mes_zero();
                Navigator.pop(context);
              }),
          title: InkWell(
            onTap: (){
              Navigator.pushNamed(context,"/otherprofile",arguments: {
                'name':name,
                'about':about,
                'photo_url':photo,
              });
            },
            child: Container(
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundImage: NetworkImage(
                        "$photo"),
                  ),
                  SizedBox(width: 12,),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("$name",style: GoogleFonts.zillaSlab(fontSize: 25,fontWeight: FontWeight.bold,color: Colors.grey[100]),),
                      StreamBuilder(
                      stream: FirebaseFirestore.instance.collection('users').doc('$user_id').snapshots(),
                      builder: (context,snapshot){
                      if(snapshot.hasData){
                        DocumentSnapshot documentSnapshot=snapshot.data;
                        if(documentSnapshot["status"].toString()=="true"){
                          kk="online";
                        }
                        else{
                          kk="";
                        }
                        return Text("$kk",style: GoogleFonts.zillaSlab(fontSize: 16,fontWeight: FontWeight.bold,color: Colors.grey[100]),);
                      }
                      else{
//                  print('test phrase');
                        return SizedBox();
                      }

                        }
                      ),
                    ],
                  )

//                  InkWell(onTap:(){
//                    deletechats();
//                  },child: Text("hello")),
                ],
              ),
            ),
          ),
          toolbarHeight: 70,
          backgroundColor: Colors.blueGrey[900],
          elevation: 0.0,
        ),

        body: Container(
          decoration: BoxDecoration(
              image: DecorationImage( image: AssetImage('assets/dark2.jpg'),fit: BoxFit.cover)),
          child: Stack(
            children: [
              Container(
                height: 540,
                child: ListView(
                    physics: BouncingScrollPhysics(),
                    reverse: true,
                  children:[
                    Column(
                    children: [
                      StreamBuilder(
                        stream: FirebaseFirestore.instance.collection("messages").doc("${user.uid}").collection("$user_id").orderBy('time',descending: false).snapshots(),

                        builder: (context,snapshot){
                          if(snapshot.hasData){


                            return ListView.builder(
                                physics: BouncingScrollPhysics(),

                                shrinkWrap: true,
                                itemCount: snapshot.data.documents.length,
                                itemBuilder: (context,index){
                                  DocumentSnapshot documentSnapshot=snapshot.data.documents[index];

                                  if(documentSnapshot["status"]=="from_me")
                                    {
                                      toggle=true;
                                    }
                                  else{
                                    toggle=false;
                                  }

                                  timetodaily(documentSnapshot["time"]);
                                   return  toggle ? Padding(
                                    padding: const EdgeInsets.only(right:15.0),
                                    child: InkWell(
                                      onLongPress: (){
                                        delete_message(documentSnapshot["time"]);
                                      },
                                      child: Bubble(
                                        margin: BubbleEdges.only(top: 10),
                                        alignment: Alignment.topRight,
                                        nipWidth: 10,
                                        nipHeight: 15,
                                        nip: BubbleNip.rightTop,
                                        color: Colors.cyan[100],
                                        child: Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: Column(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.all(6.0),
                                                child: Text(documentSnapshot["msg"], textAlign: TextAlign.right,style: GoogleFonts.zillaSlab(fontSize: 22),),
                                              ),
                                              Text("$Hour:$Minute", textAlign: TextAlign.right,style: GoogleFonts.stylish(fontSize: 15),),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ) :
                                   Padding(
                                     padding: const EdgeInsets.only(left:15.0),
                                     child: InkWell(
                                       onLongPress: (){
                                         delete_for_me(documentSnapshot["time"]);
                                       },
                                       child: Bubble(
                                         margin: BubbleEdges.only(top: 10),
                                         alignment: Alignment.topLeft,
                                         nipWidth: 10,
                                         nipHeight: 15,
                                         nip: BubbleNip.leftTop,
                                         color: Colors.amber[300],
                                         child: Padding(
                                           padding: const EdgeInsets.all(4.0),
                                           child: Column(
                                             children: [
                                               Padding(
                                                 padding: const EdgeInsets.all(6.0),
                                                 child: Text(documentSnapshot["msg"], textAlign: TextAlign.right,style: GoogleFonts.zillaSlab(fontSize: 22),),
                                               ),
                                               Container(child: Column(

                                                 children: [
                                                   Text("$Hour:$Minute", textAlign: TextAlign.end,style: GoogleFonts.stylish(fontSize: 15),),
                                                 ],
                                               )),
                                             ],
                                           ),
                                         ),
                                       ),
                                     ),
                                   )
                                   ;
                                }


                            );
                          }
                          if (!snapshot.hasData){
                            print('test phrase');
                            return Text("");
                          }

                        },

                      ),
                      SizedBox(height: 55,)
                    ],
                  ),
                ]
                ),
              ),


              Stack(
                  children:[
                    Positioned(
                      bottom: 0.0,
                      left: 0.0,
                      right: 0.0,
                      child: Row(
                        children: [
                          Card(
                            elevation: 20,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(55.0),
                            ),
                            child: new ConstrainedBox(
                              constraints: new BoxConstraints(
                                minWidth: 200,
                                maxWidth: 285,
                                minHeight: 25.0,
                                maxHeight: 120.0,
                              ),
                              child: new Scrollbar(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: new TextField(
                                    controller: nameHolder,
                                    cursorColor: Colors.red,
                                    keyboardType: TextInputType.multiline,
                                    maxLines: null,
//
//
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.only(
                                          top: 2.0,
                                          left: 13.0,
                                          right: 13.0,
                                          bottom: 2.0),
                                      hintText: "Type your message",
                                      hintStyle: TextStyle(
                                        color:Colors.grey,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: (){

                              chat_messages(nameHolder.text, user_id, DateTime.now().microsecondsSinceEpoch);
                              clearTextInput();
                              msg_count();
                            },
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(40))),
                              color: Colors.blueGrey,
                              child: Padding(
                                padding: const EdgeInsets.all(13.0),
                                child: Icon(Icons.send,size: 32,color: Colors.white,),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ]
              ),
            ],
          ),
        ),


      ),
    );
  }
}
