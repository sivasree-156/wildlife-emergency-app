
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../Ambulance/amblogin.dart';
import '../Ambulance/ambui.dart';



void main() {
  runApp(new MaterialApp(
    home: new AuthGated(),



  ));




}


class AuthGated extends StatelessWidget {
  const AuthGated({super.key});


  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context,snapshot){
          if(!snapshot.hasData) {
            return const HLoginPage();

          }
          return HospitalDashboard();
        }

    );

  }
}








