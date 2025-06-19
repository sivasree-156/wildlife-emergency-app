
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../police/policelogin.dart';
import '../police/policeui.dart';

void main() {
  runApp(new MaterialApp(
    home: new AuthGatedh(),



  ));




}


class AuthGatedh extends StatelessWidget {
  const AuthGatedh({super.key});


  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context,snapshot){
          if(!snapshot.hasData) {
            return const PoliceLoginPage();

          }
          return PoliceUI();
        }

    );

  }
}


