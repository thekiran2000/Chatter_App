import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:trashforsigninsignout/pages/addpost.dart';
import 'package:trashforsigninsignout/pages/auth_service.dart';
import 'package:trashforsigninsignout/pages/chatpage.dart';
import 'package:trashforsigninsignout/pages/home.dart';
import 'package:trashforsigninsignout/pages/home2.dart';
import 'package:trashforsigninsignout/pages/login.dart';
import 'package:trashforsigninsignout/pages/myposts.dart';
import 'package:trashforsigninsignout/pages/otherprofile.dart';
import 'package:trashforsigninsignout/pages/posts.dart';
import 'package:trashforsigninsignout/pages/settings.dart';
import 'package:trashforsigninsignout/pages/signup.dart';
import 'package:firebase_core/firebase_core.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(
    providers: [
      Provider<Auth_serve>(
        create: (_)=>Auth_serve(FirebaseAuth.instance),
      ),
      StreamProvider(create: (context)=> context.read<Auth_serve>().authStateChanges)
    ],
    child: MaterialApp(
      initialRoute: '/aoth',
      routes: {

        "/login": (context)=>Login(),
        "/signup": (context)=>Signup(),
        "/home": (context)=>Home(),
        "/chatpage": (context)=>Chat(),
        "/settings": (context)=>ProfilePage(),
        "/otherprofile": (context)=>Otherprofile(),
        "/friends": (context)=>friends(),
        "/aoth": (context)=>Aoth(),
        "/posts": (context)=>Posts(),
//        "/addpost": (context)=>Addpost(),
        "/myposts": (context)=>Myposts(),
      },

    ),
  ));
}

class Aoth extends StatelessWidget {

  const Aoth({
    Key key,
  }) : super(key:key);

  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User>();
    if(firebaseUser != null){
      return Home();
    }

    else{
      return Login();
    }
  }
}