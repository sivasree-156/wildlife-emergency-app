import 'dart:async';
import 'package:flutter/material.dart';
import 'package:torch_light/torch_light.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:shake/shake.dart';
import 'package:geolocator/geolocator.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:vvxplore/user/timetovisit.dart';
import 'package:vvxplore/user/up.dart';
import 'package:vvxplore/user/userlogin.dart';
import 'cb.dart';
import 'do.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'User Interface Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: TextTheme(
          bodyMedium: TextStyle(fontFamily: 'Poppins'), // Apply font globally
        ),
      ),
      home: UserInterface(),
    );
  }
}

class UserInterface extends StatefulWidget {
  final String? userId;

  const UserInterface({Key? key, this.userId}) : super(key: key);

  @override
  _UserInterfaceState createState() => _UserInterfaceState();
}

class _UserInterfaceState extends State<UserInterface> {
  ShakeDetector? _shakeDetector;
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isFlashOn = false;

  @override
  void initState() {
    super.initState();
    _initializeShakeDetection();
  }

  void _initializeShakeDetection() {
    _shakeDetector = ShakeDetector.autoStart(
      onPhoneShake: () async {
        await _handleEmergency();
      },
    );
  }

  Future<void> _handleEmergency() async {
    _turnOnFlashlight();
    _playAlertSound();
    _sendLocationToFirebase();
  }

  Future<void> _turnOnFlashlight() async {
    try {
      if (!_isFlashOn) {
        await TorchLight.enableTorch();
        setState(() => _isFlashOn = true);

        // Auto turn off after 10 seconds
        Future.delayed(const Duration(seconds: 10), () async {
          await TorchLight.disableTorch();
          setState(() => _isFlashOn = false);
        });
      }
    } catch (e) {
      debugPrint("Flashlight error: $e");
    }
  }

  Future<void> _playAlertSound() async {
    try {
      await _audioPlayer.play(AssetSource('audio/aa.mp3'));
    } catch (e) {
      debugPrint("Audio error: $e");
    }
  }

  Future<void> _sendLocationToFirebase() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check location permission
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      debugPrint("Location services are disabled.");
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse && permission != LocationPermission.always) {
        debugPrint("Location permission denied.");
        return;
      }
    }

    // Get current location
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    // Get the current user's ID from FirebaseAuth
    String? userId = FirebaseAuth.instance.currentUser?.uid;


    if (userId == null) {
      debugPrint("User is not authenticated.");
      return;
    }

    // Send to Firebase Realtime Database
    final databaseRef = FirebaseDatabase.instance.ref('emergency_alerts/$userId').push();
    await databaseRef.set({
      'latitude': position.latitude,
      'longitude': position.longitude,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  @override
  void dispose() {
    _shakeDetector?.stopListening();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('User Interface'),
        actions: [
          IconButton(
            icon: Icon(Icons.access_time_sharp),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DeepLearning()),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.do_not_touch_sharp),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => WildlifeGuidelinesScreen()),
              );
            },
          ),
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert),
            onSelected: (String value) async {
              if (value == 'logout') {
                await FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem<String>(
                  value: 'notification',
                  child: Row(
                    children: [
                      Icon(Icons.notifications, color: Colors.deepPurple.shade700),
                      SizedBox(width: 10),
                      Text('Notification'),
                    ],
                  ),
                ),
                PopupMenuItem<String>(
                  value: 'logout',
                  child: Row(
                    children: [
                      Icon(Icons.logout, color: Colors.deepPurple.shade700),
                      SizedBox(width: 10),
                      Text('Logout'),
                    ],
                  ),
                ),
              ];
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/img.jpg'), // Background image
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Welcome to VV Xplore',
                  style: TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 30.0),
                _buildButton(context, 'Ask me', Icons.question_answer, Colors.green, () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => ChatBotScreen()),
                  );
                }),

                _buildButton(context, 'Classification', Icons.upload, Colors.orange, () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => Dataset()),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildButton(BuildContext context, String label, IconData icon, Color color, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, color: Colors.white, size: 28.0),
        label: Text(label, style: TextStyle(fontSize: 20.0)),
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white, backgroundColor: color,
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          elevation: 5.0,
        ),
      ),
    );
  }
}
