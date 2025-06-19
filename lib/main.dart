import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'authgate/auth1.dart';
import 'authgate/auth2.dart';
import 'authgate/auth3.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.teal,

        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('VVxplore App'),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/123.gif'),
            fit: BoxFit.fill,
            onError: (error, stackTrace) {
              print("Image load error: $error");
            },
          ),
        ),
        child: Stack(
          children: [
            Container(
              color: Colors.black.withOpacity(0.1),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Welcome to VV xplore',
                      style: TextStyle(
                        fontSize: 27.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1.5,
                        shadows: [
                          Shadow(
                            blurRadius: 10.0,
                            color: Colors.black,
                            offset: Offset(2, 2),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 50.0),
                    _buildGradientButton(
                      text: 'User',
                      colors: [Colors.greenAccent, Colors.green],
                      onPressed: () {
                        // Uncomment and adjust the navigation as needed
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AuthGate(),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 50.0),
                    _buildGradientButton(
                      text: 'Ambulance',
                      colors: [Colors.blueAccent, Colors.lightBlue],
                      onPressed: () {
                        // Uncomment and adjust the navigation as needed
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AuthGated(),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 50.0),
                    _buildGradientButton(
                      text: 'police station',
                      colors: [Colors.blueAccent, Colors.purple],
                      onPressed: () {
                        // Uncomment and adjust the navigation as needed
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AuthGatedh(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGradientButton({
    required String text,
    required List<Color> colors,
    required VoidCallback onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 10.0,
            offset: Offset(0, 5),
          ),
        ],
        gradient: LinearGradient(
          colors: colors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 18.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 22.0,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
