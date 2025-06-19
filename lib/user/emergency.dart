/*
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:torch_light/torch_light.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:shake/shake.dart';
import 'package:geolocator/geolocator.dart';
import 'package:firebase_database/firebase_database.dart';

class EmergencyShakeHandler extends StatefulWidget {
  const EmergencyShakeHandler({super.key});

  @override
  State<EmergencyShakeHandler> createState() => _EmergencyShakeHandlerState();
}

class _EmergencyShakeHandlerState extends State<EmergencyShakeHandler> {
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
      // Check if the file exists in the correct path
      debugPrint("Attempting to load audio from: assets/audio/alert.mp3");

      await _audioPlayer.play(AssetSource('audio/aa.mp3'));
      debugPrint("Audio played successfully");
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

    // Send to Firebase Realtime Database
    final databaseRef = FirebaseDatabase.instance.ref('emergency_alerts').push();
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
    return const Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Text(
          'Shake the phone to trigger emergency mode.',
          style: TextStyle(color: Colors.white, fontSize: 18),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
*/
