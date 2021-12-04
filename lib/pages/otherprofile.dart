import 'dart:convert';



import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trashforsigninsignout/pages/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';


class Otherprofile extends StatefulWidget {
  @override
  _OtherprofileState createState() => _OtherprofileState();
}

class _OtherprofileState extends State<Otherprofile> {
  var photo;
  var about;
  var userdata={};

  var name;

  @override
  Widget build(BuildContext context) {
    userdata=ModalRoute.of(context).settings.arguments;

    name=userdata['name'];
    photo=userdata['photo_url'];
    about=userdata['about'];


    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            iconSize: 18,
            icon: Icon(FontAwesomeIcons.arrowLeft),
            onPressed: () {
              Navigator.pop(context);
            }),
        title: Container(
          child: Row(
            children: [
              Text("Profile",style: GoogleFonts.zillaSlab(fontSize: 25,fontWeight: FontWeight.bold,color: Colors.grey[100]),),
            ],
          ),
        ),
        toolbarHeight: 70,
        backgroundColor: Colors.blueGrey[900],
        elevation: 0.0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
              height: 370,
              decoration: BoxDecoration(
                  image: DecorationImage( image: NetworkImage('$photo'),fit: BoxFit.cover)),
            ),
            SizedBox(height: 3,),
            Padding(
              padding: const EdgeInsets.all(1.0),
              child: Container(
                color: Colors.blueGrey[900],
                width: double.infinity,
                child: Card(
                    color: Colors.indigo[200],
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text("Name:",style: GoogleFonts.oswald(fontSize: 27,fontWeight: FontWeight.bold),),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text("$name",style: GoogleFonts.oswald(fontSize: 17,fontWeight: FontWeight.bold),),
                          ),
                        ],
                      ),
                    )
                ),
              ),
            ),
            SizedBox(height: 3,),
            Padding(
              padding: const EdgeInsets.all(1.0),
              child: Container(
                color: Colors.blueGrey[900],
                width: double.infinity,
                child: Card(
                  color: Colors.cyan[200],
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text("About:",style: GoogleFonts.oswald(fontSize: 27,fontWeight: FontWeight.bold),),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text("$about:",style: GoogleFonts.oswald(fontSize: 17,fontWeight: FontWeight.bold),),
                          ),
                        ],
                      ),
                    )
                ),
              ),
            ),


          ],
        ),
      ),
    );
  }
}
