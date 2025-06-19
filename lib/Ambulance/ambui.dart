import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import 'amblogin.dart';

class HospitalDashboard extends StatefulWidget {
  @override
  _HospitalDashboardState createState() => _HospitalDashboardState();
}

class _HospitalDashboardState extends State<HospitalDashboard> {
  final DatabaseReference alertsRef =
  FirebaseDatabase.instance.ref("emergency_alerts");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
        backgroundColor: Colors.white30,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HLoginPage()),
              );
            },
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        color: Colors.grey[100],
        child: StreamBuilder<DatabaseEvent>(
          stream: alertsRef.onValue,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
              return Center(child: Text('No emergency alerts found.'));
            }

            Map<Object?, Object?> rawData =
            snapshot.data!.snapshot.value as Map<Object?, Object?>;
            List<Map<String, dynamic>> alerts = [];

            rawData.forEach((outerKey, outerValue) {
              if (outerValue is Map<Object?, Object?>) {
                outerValue.forEach((innerKey, innerValue) {
                  if (innerValue is Map<Object?, Object?>) {
                    alerts.add(Map<String, dynamic>.from(innerValue.map(
                          (key, value) => MapEntry(key.toString(), value),
                    )));
                  }
                });
              }
            });

            if (alerts.isEmpty) {
              return Center(child: Text("No alerts available."));
            }

            return ListView.builder(
              itemCount: alerts.length,
              itemBuilder: (context, index) {
                final alert = alerts[index];

                final double? lat = _toDouble(alert['latitude']);
                final double? lng = _toDouble(alert['longitude']);
                final String timestamp = alert['timestamp'] ?? '';

                return Card(
                  margin: EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 8,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.indigo.shade300, Colors.indigo.shade700],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.warning_amber_rounded,
                                color: Colors.amberAccent, size: 30),
                            SizedBox(width: 10),
                            Text(
                              'Emergency Alert #${index + 1}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        Divider(height: 20, color: Colors.white70),
                        Text(
                          '📍 Latitude: ${lat?.toStringAsFixed(6) ?? 'N/A'}',
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          '📍 Longitude: ${lng?.toStringAsFixed(6) ?? 'N/A'}',
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          '⏰ Time: ${_formatTimestamp(timestamp)}',
                          style: TextStyle(color: Colors.white70),
                        ),
                        SizedBox(height: 12),
                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              if (lat != null && lng != null) {
                                _openMap(lat, lng);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Invalid coordinates for this alert.")),
                                );
                              }
                            },
                            icon: Icon(Icons.directions, color: Colors.white),
                            label: Text("Directions", style: TextStyle(color: Colors.white)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepOrangeAccent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
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

  double? _toDouble(dynamic value) {
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  String _formatTimestamp(String isoString) {
    try {
      if (isoString.isEmpty) return "Unknown";
      final dt = DateTime.parse(isoString);
      return DateFormat('MMM d, yyyy - hh:mm a').format(dt);
    } catch (e) {
      return "Unknown";
    }
  }

  Future<void> _openMap(double lat, double lng) async {
    final Uri googleMapUrl = Uri.parse(
        'https://www.google.com/maps/dir/?api=1&destination=$lat,$lng&travelmode=driving');

    if (!await launchUrl(googleMapUrl,
        mode: LaunchMode.externalApplication)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not launch Google Maps.')),
      );
    }
  }
}
