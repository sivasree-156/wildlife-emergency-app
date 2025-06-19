import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';  // Import the intl package for formatting
import 'package:vvxplore/police/policelogin.dart';

class PoliceUI extends StatefulWidget {
  @override
  _PoliceUIState createState() => _PoliceUIState();
}

class _PoliceUIState extends State<PoliceUI> {
  final DatabaseReference alertsRef = FirebaseDatabase.instance.ref("emergency_alerts");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
        backgroundColor: Colors.indigo,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => PoliceLoginPage()),
              );
            },
          ),
        ],
      ),
      body: Container(
        color: Colors.grey[100],
        child: StreamBuilder<DatabaseEvent>(
          stream: alertsRef.onValue,
          builder: (context, snapshot) {
            if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
              return Center(child: CircularProgressIndicator());
            }

            Map<Object?, Object?> rawData = snapshot.data!.snapshot.value as Map<Object?, Object?>;
            List<Map<String, dynamic>> alerts = [];

            rawData.forEach((outerKey, outerValue) {
              if (outerValue is Map<Object?, Object?>) {
                outerValue.forEach((innerKey, innerValue) {
                  if (innerValue is Map<Object?, Object?>) {
                    alerts.add(Map<String, dynamic>.from(innerValue.map((key, value) => MapEntry(key.toString(), value))));
                  }
                });
              }
            });

            return ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: alerts.length,
              itemBuilder: (context, index) {
                var alert = alerts[index];
                double lat = alert['latitude'] is double ? alert['latitude'] : 0.0;
                double lng = alert['longitude'] is double ? alert['longitude'] : 0.0;

                return Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  elevation: 5,
                  margin: EdgeInsets.only(bottom: 16),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.warning_amber_rounded, color: Colors.red, size: 30),
                            SizedBox(width: 10),
                            Text(
                              'Emergency Alert #${index + 1}',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.red[700],
                              ),
                            ),
                          ],
                        ),
                        Divider(thickness: 1, height: 20),
                        Text('📍 Latitude: ${lat != 0.0 ? lat.toString() : 'N/A'}'),
                        Text('📍 Longitude: ${lng != 0.0 ? lng.toString() : 'N/A'}'),
                        Text('⏰ Time: ${_formatTimestamp(alert['timestamp'] ?? '')}'),
                        SizedBox(height: 10),
                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.indigo,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            icon: Icon(Icons.directions),
                            label: Text("Directions"),
                            onPressed: () {
                              _openMap(lat, lng);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  String _formatTimestamp(String isoString) {
    try {
      if (isoString.isNotEmpty) {
        final dateTime = DateTime.parse(isoString);
        final formatter = DateFormat('MMM d, yyyy - hh:mm a'); // e.g., May 6, 2025 - 06:47 PM
        return formatter.format(dateTime);
      } else {
        return "Unknown";
      }
    } catch (e) {
      return "Unknown";
    }
  }

  Future<void> _openMap(double lat, double lng) async {
    final Uri googleMapUrl = Uri.parse(
        'https://www.google.com/maps/dir/?api=1&destination=$lat,$lng&travelmode=driving');

    if (!await launchUrl(googleMapUrl, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $googleMapUrl';
    }
  }
}
