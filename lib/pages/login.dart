import 'dart:convert';



import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trashforsigninsignout/pages/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';


class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
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

class _LoginState extends State<Login> {
  final _formkey=GlobalKey<FormState>();
  var Email,Password;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,

      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [

              Colors.limeAccent[200],

              Colors.teal[300],

            ],
          ),
        ),
        child: Column(
          children: [
            SizedBox(height: 50,),
            Container(
//                child: Image.asset("lib/asset/login.png",width: 220,)
            ),
            Text("Improving",style: GoogleFonts.zillaSlab(fontSize: 20,fontWeight: FontWeight.bold),),
            Text("Agriculture for lives",style: GoogleFonts.zillaSlab(fontSize: 24,fontWeight: FontWeight.bold),),
            SizedBox(height: 45,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text("Sign In",style: GoogleFonts.zillaSlab(fontSize: 35,fontWeight: FontWeight.bold,color: Colors.green[900]
                ),),
                InkWell(onTap:(){
                  Navigator.pushReplacement(context, SlideRightRoute(page: Signup()));
                },child: Text("Sign Up",style: GoogleFonts.zillaSlab(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.green[900]),)),
              ],
            ),
            Form(
              key: _formkey,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(35.0,35,35,15),
                    child: TextFormField(
                      decoration: InputDecoration(icon:Icon(Icons.mail,color: Colors.white60,),labelText: "Email",labelStyle: GoogleFonts.zillaSlab(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.green[900])),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value){
                        if(value.isEmpty || !value.contains('@')){
                          return 'Invalid email';
                        }
                        return null;
                      },
                      onSaved: (value){
                        Email=value;
                      },
                    ),
                  )
                  ,Padding(
                    padding: const EdgeInsets.fromLTRB(35.0,15,35,15),
                    child: TextFormField(
                      obscureText: true,
                      decoration: InputDecoration(icon:Icon(Icons.lock,color: Colors.white60,),labelText: "Password",labelStyle: GoogleFonts.zillaSlab(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.green[900])),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value){
                        if(value.isEmpty || value.length <= 5 ){
                          return 'Invalid Password';
                        }
                        return null;
                      },
                      onSaved: (value){
                        Password=value;
                      },
                    ),
                  ),
                  SizedBox(height: 30,),
                  Container(
                    width: 320,
                    child: RaisedButton(
                      onPressed: signin,
                      color:Colors.green[100],
                      child: Text("SIGN IN",
                        style: GoogleFonts.zillaSlab(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.blueGrey[900]),
                      ),
                    ),
                  ),
                ],
              ),
            ),



          ],
        ),
      ),

    );
  }

  Future<void> signin() async{
    final formState=_formkey.currentState;
    if(formState.validate()){
      formState.save();
      try{
        UserCredential user = await FirebaseAuth.instance.signInWithEmailAndPassword(email: Email, password: Password);
        Navigator.pushReplacementNamed(context, '/home');
        //TODO : Navigate to home
      }catch(e){
        print(e.message);
      }
    }
  }
}
