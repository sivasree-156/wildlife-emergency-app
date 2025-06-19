import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../police/policelogin.dart';
import '../police/policeui.dart';

class HosAuthService {
  Future<void> createUsers(Map<String, String> data, BuildContext context) async {
    try {
      // Create a user with email and password
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: data['email']!,
        password: data['password']!,
      );

      // Reference to Firebase Realtime Database
      DatabaseReference _database = FirebaseDatabase.instance.ref();

      // Get the current user and their ID
      User? user = FirebaseAuth.instance.currentUser;
      String? userId = user?.uid;

      if (userId != null) {
        // Save user data in the 'hospitaldoc' node
        await _database.child('police').child(userId).set({
          'email': data['email'],
          'password': data['password'],
          'name': data['name'],
          'contact': data['contact'],
          'latitude': data['latitude'],
          'longitude': data['longitude'],
          'hospitalname': data['hospitalname'],
          'location': data['location'],
          'ukey': userId,
          'status': "request",
        });

        // Send email verification
        await sendVerificationEmail();

        // Notify user of successful registration
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registered Successfully')),
        );

        // Navigate to the login page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => PoliceLoginPage()),
        );
      }
    } catch (e) {
      // Show error dialog if registration fails
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Sign Up Failed"),
            content: Text(e.toString()),
          );
        },
      );
    }
  }

  Future<void> userlogin(Map<String, String> data, BuildContext context) async {
    try {
      // Sign in the user with email and password
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: data['email']!,
        password: data['password']!,
      );

      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await user.reload();
        user = FirebaseAuth.instance.currentUser;

        if (user!.emailVerified) {
          // Reference to Firebase Realtime Database
          DatabaseReference _database = FirebaseDatabase.instance.ref();
          String? userId = user.uid;

          // Reference to the user's data
          DatabaseReference databaseReference = _database.child('police').child(userId);

          // Retrieve user data
          DatabaseEvent event = await databaseReference.once();
          var userData = event.snapshot.value;

          if (userData is Map) {
            // Notify user of successful login
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Login Successfully')),
            );

            // Navigate to the hospital dashboard
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => PoliceUI()),
            );
          } else {
            // Show error dialog if no user data is found
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text("Error"),
                  content: Text("No user data found."),
                );
              },
            );
          }
        } else {
          // Show error dialog if email is not verified
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text("Email not verified"),
                content: Text("Please Verify Your Email"),
              );
            },
          );
        }
      }
    } catch (e) {
      // Show error dialog if login fails
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Login Error"),
            content: Text(e.toString()),
          );
        },
      );
    }
  }

  Future<void> sendVerificationEmail() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
      print("Verification email sent to ${user.email}");
    }
  }
}
